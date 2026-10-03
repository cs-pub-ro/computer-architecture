# Mediu Docker pentru Computer Architecture — Linux

Imaginea folosește Ubuntu 24.04 și include unelte open-source pentru simulare Verilog, Rust, Typst și fluxul FPGA openXC7. Nu include Vivado sau alte unelte proprietare AMD/Xilinx.

## Cerințe

- Docker Engine sau Docker Desktop
- Visual Studio Code și extensia [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Deschidere în container

1. Deschideți rădăcina depozitului `computer-architecture` în VS Code.
2. Rulați **Dev Containers: Reopen in Container** din Command Palette.
3. La prima utilizare, construiți imaginea `sdc_dev_stage`; etapa FPGA poate necesita câțiva GB de memorie și timp suplimentar.

Depozitul este montat în `/workspace`, iar `SDC_ROOT=/workspace` este setat de configurația Dev Container. Funcțiile zsh ale etapelor sunt citite din depozitul montat; ele nu sunt copiate în imagine.

## Utilizare

- Simulare: `make -C assignments/sim/mux build_solution`, apoi `vvp solution_mux.vvp`.
- Forme de undă: `vwave test.vcd` sau `gtkwave test.vcd` dintr-o sesiune cu acces la display X11/Wayland.
- Typst: `mkdir -p build && tc slides/courses/2/main.typ build/course-2.pdf`. Pachetele Typst folosite de document sunt descărcate la prima compilare și păstrate în cache în directorul personal al utilizatorului; este necesară conexiune la internet la prima utilizare.
- Sinteză și programare FPGA: din rădăcina depozitului rulați `./synth_and_flash.sh chapters/verilog/basic/drills/tasks/fulladder/fulladder.v`. Implicit, scriptul caută fișierul XDC cu același nume în directorul designului; pentru altă locație, setați `FPGA_XDC` la o cale relativă la acel director sau la o cale din container, precum `/workspace/common/verilog/labcpu/cpu_debugger.xdc`. Fluxul openXC7 folosește subsetul XDC acceptat de nextpnr; păstrați listele `get_ports` fără spații în interiorul acoladelor și fără punct și virgulă finală pe comenzile `set_property`.

Pe Linux, containerul rulează cu acces privilegiat la dispozitive. Dacă placa nu este accesibilă, verificați permisiunile USB/udev de pe gazdă și confirmați placa cu `fpga_detect`.

## Build și run fără VS Code

Din rădăcina depozitului:

```sh
docker build --file docker/dev.Dockerfile --target sdc_dev_stage --tag computer-architecture/dev:latest docker
docker run --rm -it --privileged --volume "$PWD:/workspace" --workdir /workspace --env SDC_ROOT=/workspace computer-architecture/dev:latest
```

Dacă se construiește pe Ubuntu arm64, depozitele Ubuntu Ports nu publică metadatele serviciului Snapshot; scriptul raportează această limitare și folosește pachetele curente pentru Ports. Pe amd64, apt folosește snapshot-ul fixat în Dockerfile.
