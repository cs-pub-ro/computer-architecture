FROM ubuntu:24.04 AS vivado-install-files

ENV DEBIAN_FRONTEND noninteractive

ARG VIVADO_VERSION=2025.1
ARG VIVADO_BIN=FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145_Lin64.bin


COPY $VIVADO_BIN /root/$VIVADO_BIN
RUN chmod +x /root/$VIVADO_BIN && \
    /root/$VIVADO_BIN --noexec --target /root/vivado_installer && \
    rm -f /root/$VIVADO_BIN

# /root/vivado_installer/xsetup -b ConfigGen
# modify this file to customize your installation
COPY install_config.txt /root/install_config.txt

# You need to get this file from Xilinx website after login
# /root/vivado_installer/xsetup -b AuthTokenGen
COPY wi_authentication_key /root/wi_authentication_key

FROM ubuntu:24.04 AS vivado-fresh-install

ENV DEBIAN_FRONTEND noninteractive

COPY --from=vivado-install-files /root/vivado_installer /root/vivado_installer
RUN mkdir -p /root/.Xilinx
COPY --from=vivado-install-files /root/wi_authentication_key /root/.Xilinx/wi_authentication_key
COPY --from=vivado-install-files /root/install_config.txt /root/.Xilinx/install_config.txt

RUN chmod +x /root/vivado_installer/installLibs.sh && \
    /root/vivado_installer/installLibs.sh

RUN chmod +x /root/vivado_installer/xsetup && \
    /root/vivado_installer/xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config /root/.Xilinx/install_config.txt

FROM vivado-fresh-install AS vivado-cleaning-process

ENV DEBIAN_FRONTEND=noninteractive
ARG VIVADO_VERSION=2025.1

RUN rm -rf /root/vivado_installer && \
    rm -rf /tmp/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /tools/Xilinx/.xinstall && \
    echo "FINISHED removing .xinstall" && \
    rm -rf /tools/Xilinx/xic && \
    echo "FINISHED removing xic (information and update)"

# remove from here /tools/Xilinx/VERSION
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/Vitis && \
    echo "FINISHED removing vitis" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/gnu && \
    echo "FINISHED removing gnu (microblaze and riscv)"
# remove from here /tools/Xilinx/Vivado/VERSION/data
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/embeddedsw && \
    echo "FINISHED removing embeddedsw" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/ip && \
    echo "FINISHED removing ip" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/secureip && \
    echo "FINISHED removing secureip" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/deca && \
    echo "FINISHED removing deca" 

# remove data/parts
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/virtex4 && \
    echo "FINISHED removing virtex4" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/virtex5 && \
    echo "FINISHED removing virtex5" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/virtex6 && \
    echo "FINISHED removing virtex6" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/virtex7 && \
    echo "FINISHED removing virtex7" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/kirtex7 && \
    echo "FINISHED removing kirtex7" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan3 && \
    echo "FINISHED removing spartan3" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan3e && \
    echo "FINISHED removing spartan3e" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan6 && \
    echo "FINISHED removing spartan6" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan7 && \
    echo "FINISHED removing spartan7" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan3a && \
    echo "FINISHED removing spartan3a" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/parts/spartan3adsp && \
    echo "FINISHED removing spartan3adsp"

# remove xsim/ip
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/data/xsim/ip && \
    echo "FINISHED removing xsim ip"

# remove lnx64 tools that are not needed
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/lnx64/tools/clang-16 && \
    echo "FINISHED removing clang-16" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/lnx64/tools/clang && \
    echo "FINISHED removing clang" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/lnx64/tools/clang-3.1 && \
    echo "FINISHED removing clang-3.1" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/lnx64/tools/clang-3.9-csynth && \
    echo "FINISHED removing clang-3.9-csynth"

# remove tps/lnx64 tools that are not needed
RUN rm -rf /tools/Xilinx/${VIVADO_VERSION}/tps/lnx64/git-2.45.0 && \
    echo "FINISHED removing git-2.45.0" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/tps/lnx64/git-2.46.0 && \
    echo "FINISHED removing git-2.46.0" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/tps/lnx64/gcc-8.3.0 && \
    echo "FINISHED removing gcc-8.3.0" && \
    # rm -rf /tools/Xilinx/${VIVADO_VERSION}/tps/lnx64/gcc-9.3.0 && \
    # echo "FINISHED removing gcc-9.3.0" && \
    rm -rf /tools/Xilinx/${VIVADO_VERSION}/tps/lnx64/clangd-8.0.0 && \
    echo "FINISHED removing clangd-8.0.0"


RUN echo "source /tools/Xilinx/${VIVADO_VERSION}/Vivado/.settings64-Vivado.sh" >> /root/.bashrc

# the real working shit ....
FROM ubuntu:24.04 as vivado-final

ENV DEBIAN_FRONTEND=noninteractive
ARG VIVADO_VERSION=2025.1

RUN apt-get update && \
    apt-get install -y locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

# install de dependencies
COPY --from=vivado-install-files /root/vivado_installer/installLibs.sh /root/vivado_installer/installLibs.sh
RUN apt-get update && \
    chmod +x /root/vivado_installer/installLibs.sh && \
    /root/vivado_installer/installLibs.sh && \
    rm -rf /root/vivado_installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the final tools
COPY --from=vivado-cleaning-process /tools/Xilinx /tools/Xilinx


# install the cable drivers
RUN mkdir -p /etc/udev/rules.d
RUN /tools/Xilinx/${VIVADO_VERSION}/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers

COPY board_files/arty /tools/Xilinx/${VIVADO_VERSION}/data/boards/board_files/arty
COPY board_files/arty-a7-100 /tools/Xilinx/${VIVADO_VERSION}/data/boards/board_files/arty-a7-100
COPY board_files/nexys-a7-100t /tools/Xilinx/${VIVADO_VERSION}/data/boards/board_files/nexys-a7-100t

# add the source /tools/Xilinx/VERSION/Vivado/.settings64-Vivado.sh in bashrc
RUN echo "source /tools/Xilinx/${VIVADO_VERSION}/Vivado/.settings64-Vivado.sh" >> /root/.bashrc
