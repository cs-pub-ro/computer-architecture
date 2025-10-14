# docker/ — Vivado Docker helper

This directory contains Docker assets used to build a container with Xilinx Vivado tools. The current focus is on preparing the Vivado installer files that the Docker build expects.

## Overview

The Dockerfile in this folder expects the Vivado unified installer binary and a few supporting files to be present in the build context so that the installer can be extracted and used to perform an unattended installation inside the image.

## Prerequisites

- Docker or Docker Desktop installed and working on your machine.
- A valid Vivado unified installer binary downloaded from Xilinx/AMD (requires a Xilinx/AMD account).

## Required files (place in this `docker/` directory)

- The Vivado installer binary. By default the Dockerfile expects the file name:
  `FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145_Lin64.bin`
  If you use a different filename, either rename the file to match or update the `ARG VIVADO_BIN` value in the Dockerfile.
  For the next step you will need to extract the installer files, so run:
```bash
export VIVADO_BIN=FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145_Lin64.bin
chmod +x $VIVADO_BIN
./$VIVADO_BIN --noexec --target ./vivado_installer
```

- `install_config.txt` — installation configuration used by the installer. A template is already present in this folder; edit it if you need to customize the install. Or generate a new one using the installer in interactive mode or the `./vivado_installer/xsetup -b ConfigGen` command.

- `wi_authentication_key` — Xilinx Wi authentication key file (you must obtain this by running `./vivado_installer/xsetup -b AuthTokenGen`).

- `board_files/` — (optional) a directory containing any additional board files you want to install. Currently there are files for the Digilent Arty A7-100T and Nexys A7-100T boards.

## Improve the image
You can customize the Dockerfile to add more tools or IP cores to the installation. The Dockerfile is multi-stage, so you can also build intermediate images that stop at different steps of the installation process. The `Makefile` contains a target to build the final image, but you can modify it to build intermediate steps as needed.

### Example: build an intermediate image that can be used to test if the finale image size can be reduced
```bash
docker image build -t vivado-cleaning-process --target vivado-fit .
```
This image contains the the fit image step, which removes unneeded files from the full installation. You can run this image and inspect the installation folder `/tools/Xilinx/` to see if you can further reduce the size by removing more files or folders. After add the removal commands to the Dockerfile in the cleaning step, you can rebuild the final image using `make build`.