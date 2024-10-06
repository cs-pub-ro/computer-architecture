# Utilizare imagine docker Linux

## Cerințe necesare
1. Sa aveti VSCode instalat
2. Sa aveti un Desktop Environment sau un Window manager ce ruleaza cu X Server.
3. Sa aveti Docker CE instalat (Atentie, nu docker desktop! O sa trebuiasca privileged execution pentru a forwarda folderul /dev iar acesta face acest lucru foarte enervant si dificil)
	- [Ubuntu/Fedora](https://docs.docker.com/engine/install/)
	- Arch: ```sudo pacman -S docker```
		* Daca aveti deja docker desktop instalat de pe AUR o sa va apara conflicte. Va apar frumos acolo pachetele conflictuale, e alegerea voastra what comes next.

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
### Primesc eroare cand scriu in shell ```vivado```/nu apare GUI-ul
Inainte de a rula urmatoarele solutii, **asigurati-va inainte ca .devcontainer/{sshd_config,Dockerfile,devcontainer.json} respecta cerintele de securitate impuse de voi**. Urmatoarea metoda o sa expuna un port la ssh pe un container privilegiat neparolat care are expus /dev-ul vostru. Asigurati-va ca nu exista posibilitatea ca o masina remote sa se poata conecta la acel port al vostru, sau modificati sshd_config-ul astfel incat sa respecte cerintele de securitate, sau schimbati parola de root (in dockerfile)
#### Devcontainer fara GUI
Va trebui sa editati devcontainer.json (aveti comentate deja liniile necesare, decomentati image) ca sa va apara in felul acesta:
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
Dupa apasati ```Ctrl+Shift+P``` si apasati pe ```Dev Containers: Rebuild and Reopen in Container```.

Pentru a putea accesa gui-ul deschideti un terminal (nu acela de pe vscode) si scrieti ```ssh -XY -p 2222 root@localhost```. Nu va trebui sa introduceti nicio parola. Puteti modifica portul cu ce doriti voi atata timp cat modificati acest lucru si in devcontainer.json la appPort.

#### Setup manual de docker fara GUI
In radacina proiectului computer-architecture executati
```
cd .devcontainer
docker build -t vivado-slim-sshx .
cd ..
docker run -it -v /dev:/dev -p 2222:22 -v $PWD:/workspaces/computer-architecture vivado-slim-sshx
```
### Am wayland. Ce fac?
Va trebui sa faci [pasul asta](#primesc-eroare-cand-scriu-in-shell-vivadonu-apare-gui-ul).

Exista 2 optiuni rapide:
1. Instaleaza Xwayland si urmeaza setup-ul/configurarea pentru DE-ul/WM-ul tau
2. Instaleaxa Xephyr si foloseste comanda aceasta: ```Xephyr -br -ac -noreset -screen 1920x1080 :1```. Inlocuieste 1920x1080 cu rezolutia folosita de tine, o sa se deschida o fereastra. Dupa scrii ```DISPLAY=:1 ssh -X -p 2222 root@localhost```. Gui-ul de la vivado va aparea in fereastra de tocmai s-a deschis

Mai multe detalii [aici](https://www.dbts-analytics.com/notesxfwdgb.html)

### Am ecran alb cand deschid cu wayland
scrie in shell inainte sa executi vivado ```export _JAVA_AWT_WM_NONREPARENTING=1```. Sau decomenteaza linia din Dockerfile care da echo la aceasta linie in .bashrc

### Stuck la deschiderea hardware managerului
In terminalul din vscode scrie ```hw_server```, daca o sa functioneze o sa apare cv gen
```
****** Xilinx hw_server v2022.1
  **** Build date : Apr 18 2022 at 16:10:30
    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.

INFO: hw_server application started
INFO: Use Ctrl-C to exit hw_server application

INFO: To connect to this hw_server instance use url: TCP:ba86b6047b8c:3121
```
Copiati ce este intre TCP: si :3121 si folositi-l ca 'url' la conexiune remote
