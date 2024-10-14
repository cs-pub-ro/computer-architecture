# Utilizare imagine Docker Linux

## Cerințe necesare
1. Să aveți VSCode instalat
2. Să aveți un Desktop Environment sau un Window Manager ce rulează cu X Server.
3. Asigurați-vă că aveți instalat Docker CE (Atenție, nu Docker Desktop! Va fi nevoie de execuție cu privilegii pentru a redirecționa folderul `/dev`, ceea ce complică și îngreunează procesul)
   - [Ubuntu/Fedora](https://docs.docker.com/engine/install/)
   - Arch: ```sudo pacman -S docker```
      * Dacă aveți deja Docker Desktop instalat de pe AUR, o să vă apară conflicte. 
	    Vă apar pachetele conflictuale, e alegerea voastră ce pachete păstrați.

## Rulare

### Opțiunea 1 din Visual Studio Code

1. Deschideți directorul repo-ului în Visual Studio Code.
```bash
code computer-architecture
```

2. Instalați extensia [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

3. După veți avea opțiunea "Dev Containers: Reopen in container" (`CTRL+SHIFT+P`).

### Opțiunea 2 prin docker

1. Descărcați imaginea cu docker
```bash
docker pull gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0
```

2. Rulați un container cu imaginea
```bash
docker run --rm -it -v /dev:/dev gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0 /bin/bash
```

3. Rulați vivado din imagine
```bash
vivado
```

## Troubleshooting
### Primesc eroare când scriu în shell ```vivado``` / nu apare GUI-ul
Înainte de a rula următoarele soluții, **asigurați-vă că `.devcontainer/{sshd_config, Dockerfile, devcontainer.json}` respectă cerințele de securitate impuse de voi**. 
Următoarea metodă o să expună un port la SSH pe un container privilegiat, neparolat, care are expus `/dev`-ul vostru. Asigurează-te că nu există posibilitatea ca o mașină remote să se poată conecta la acel port sau modifică `sshd_config`-ul astfel încât să respecte cerințele de securitate, sau schimbă parola de root (în Dockerfile).

#### Devcontainer fără GUI
Trebuie să editezi fișierul `devcontainer.json` (liniile necesare sunt deja comentate, decomentează `image`) pentru a-l aduce în următorul format:
```json
{
	"name": "Vivado Slim Dev",
	"build": { "dockerfile": "Dockerfile" },
	// "image": "gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0",
	"runArgs": [
		"--rm",
		"--privileged"
	],
	"appPort": "2222:22",
	"mounts": ["type=bind,source=/dev,target=/dev"],
	//"otherPortsAttributes": {"requireLocalPort": "true", "elevateIfNeeded" : "true"},
	"postStartCommand": "/usr/local/sbin/sshd",
	"customizations": {
		"vscode": {
			"extensions": [
				"mshr-h.veriloghdl"
			]
		}
	}
}
```
După, apasă ```Ctrl+Shift+P``` și alege ```Dev Containers: Rebuild and Reopen in Container```.

Pentru a putea accesa `GUI`-ul, deschide-ți un terminal (nu cel din VSCode) și scrie ```ssh -XY -p 2222 root@localhost```. 
Nu ar trebui să introduci nicio parolă. 
Poți modifica portul cu ce dorești tu, atât timp cât modifici acest lucru și în `devcontainer.json` la `appPort`.

#### Setup manual de Docker fără GUI
În rădăcina proiectului `computer-architecture`, execută:
```
cd .devcontainer
docker build -t vivado-slim-sshx .
cd ..
docker run -it -v /dev:/dev -p 2222:22 -v $PWD:/workspaces/computer-architecture vivado-slim-sshx
```
### Am wayland. Ce fac?
Va trebui să faci [pasul asta](#primesc-eroare-cand-scriu-in-shell-vivadonu-apare-gui-ul).

Există 2 opțiuni rapide:
1. Instalează Xwayland și urmează setup-ul/configurarea pentru DE-ul/WM-ul tău.
2. Instalează Xephyr și folosește comanda aceasta: ```Xephyr -br -ac -noreset -screen 1920x1080 :1```. 
Înlocuiește `1920x1080` cu rezoluția folosită de tine, o să se deschidă o fereastră. 
După, scrii ```DISPLAY=:1 ssh -X -p 2222 root@localhost```. 
GUI-ul de la Vivado va apărea în noua fereastră deschisă.
S-ar putea să fie nevoie și de un ```unset XDG_SEAT``` [în cazul în care nu toate inputurile tastaturii sau mouse-ului sunt luate în considerare](https://unix.stackexchange.com/questions/690782/mouse-and-keyboard-not-getting-captured-by-xephyr)

Mai multe detalii [aici](https://www.dbts-analytics.com/notesxfwdgb.html)

### Am ecran alb când deschid cu Wayland
Scrie în `shell`, înainte să execuți Vivado, ```export _JAVA_AWT_WM_NONREPARENTING=1```.  
O altă variantă este să decommentezi linia din Dockerfile care dă `echo` la această linie în `.bashrc`.

### Stuck la deschiderea hardware managerului
În terminalul din VSCode, scrie ```hw_server```. 
Dacă o să funcționeze, o să apară un output sub următorul format:
```
****** Xilinx hw_server v2022.1
  **** Build date : Apr 18 2022 at 16:10:30
    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.

INFO: hw_server application started
INFO: Use Ctrl-C to exit hw_server application

INFO: To connect to this hw_server instance use url: TCP:ba86b6047b8c:3121
```
Copiază ce este între `TCP:` și `:3121` și folosește-l ca 'url' la conexiunea remote.
