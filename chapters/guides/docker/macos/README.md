# Utilizare imagine docker MacOS

## Cerințe necesare

### Docker Desktop

Instalare [Docker Desktop](https://www.docker.com/products/docker-desktop/).

### Instalre XQuartz

Instalare [XQuartz](https://www.xquartz.org/)

### Visual Studio Code

Descărcați și instalați [Visual Studio Code](https://code.visualstudio.com/download)

### Clonați repo-ul materiei

```bash
git clone https://github.com/cs-pub-ro/computer-architecture.git
```

## Rulare

### Porniți XQuartz

1. Deschideți Applications > Utilities > XQuartz


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
