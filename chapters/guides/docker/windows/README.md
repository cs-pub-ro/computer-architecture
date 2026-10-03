# Mediu Docker pentru Computer Architecture — Windows

Imaginea Ubuntu 24.04 conține unelte open-source pentru simulare Verilog, Rust, Typst și fluxul FPGA openXC7; Vivado nu este inclus.

## Cerințe

- WSL 2 cu Ubuntu 24.04
- Docker Desktop cu integrarea WSL activată pentru distribuția Ubuntu
- Visual Studio Code, extensia WSL și extensia [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Instalarea WSL, dacă este necesar:

```powershell
wsl --install -d Ubuntu-24.04
```

## Deschidere în container

1. Deschideți depozitul din filesystem-ul WSL, nu dintr-un director Windows montat sub `/mnt/c`.
2. Deschideți rădăcina `computer-architecture` în VS Code prin WSL.
3. Rulați **Dev Containers: Reopen in Container** din Command Palette.

Depozitul este montat în `/workspace`, iar `SDC_ROOT=/workspace` este setat de configurația containerului.

## Simulare și documente

- Simulare: `make -C assignments/sim/mux build_solution`, apoi `vvp solution_mux.vvp`.
- Typst: `mkdir -p build && tc slides/courses/2/main.typ build/course-2.pdf`. Pachetele Typst folosite de document sunt descărcate la prima compilare și păstrate în cache în directorul personal al utilizatorului; este necesară conexiune la internet la prima utilizare.
- GTKWave necesită un server grafic WSLg sau un X server compatibil.

## Programarea plăcii FPGA

Docker Desktop/WSL2 nu oferă automat dispozitivele USB containerului. Instalați `usbipd-win`, apoi, într-un PowerShell pornit ca Administrator, identificați și partajați placa:

```powershell
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

Verificați în Ubuntu WSL că placa apare în `/dev/bus/usb`, apoi rulați:

```sh
./synth_and_flash.sh chapters/.../design.v
```

Containerul este privilegiat pentru a accesa dispozitivul atașat. Dacă placa nu apare, verificați atașarea USB în WSL înainte de depanarea openFPGALoader.
