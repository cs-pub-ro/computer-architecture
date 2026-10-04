# Mediu Docker pentru Computer Architecture — macOS

Imaginea Ubuntu 24.04 oferă unelte open-source pentru simulare Verilog, Rust, Typst și fluxul FPGA openXC7. Vivado nu este inclus.

## Cerințe

- Docker Desktop
- Visual Studio Code și extensia [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Deschidere în container

1. Deschideți rădăcina depozitului `computer-architecture` în VS Code.
2. Rulați **Dev Containers: Reopen in Container** din Command Palette.
3. La prima utilizare, construiți imaginea `sdc_dev_stage`; compilarea uneltelor FPGA poate dura și folosi mai mulți GB de memorie.

Depozitul este montat în `/workspace`, cu `SDC_ROOT=/workspace`. Funcțiile zsh sunt încărcate din depozitul montat.

## Utilizare

- Simulare: `make -C assignments/sim/mux build_solution`, apoi `vvp solution_mux.vvp`.
- Typst: `mkdir -p build && tc slides/courses/2/main.typ build/course-2.pdf`. Pachetele Typst folosite de document sunt descărcate la prima compilare și păstrate în cache în directorul personal al utilizatorului; este necesară conexiune la internet la prima utilizare.
- Sinteză și bitstream: `./synth_and_flash.sh chapters/.../design.v`.

Docker Desktop pentru macOS nu expune USB-ul fizic către container. Pentru programare, instalați pe gazdă o versiune compatibilă openFPGALoader, de exemplu `brew install openfpgaloader`, conectați placa și folosiți `synth_and_flash.sh`; compilarea rulează în container, iar flash-ul rulează pe macOS. XQuartz este necesar numai dacă doriți să deschideți GTKWave cu interfață grafică.

## Build și run fără VS Code

Din rădăcina depozitului:

```sh
docker build --file docker/dev.Dockerfile --target sdc_dev_stage --tag computer-architecture/dev:latest docker
docker run --rm -it --volume "$PWD:/workspace" --workdir /workspace --env SDC_ROOT=/workspace computer-architecture/dev:latest
```

Pe Apple Silicon se construiește imaginea arm64 nativ. Ubuntu Ports nu oferă metadate pentru serviciul Snapshot; instalarea apt folosește pachetele curente ale Ubuntu Ports.
