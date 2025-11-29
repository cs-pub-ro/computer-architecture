# Image used in the pipeline of prjxray
FROM ubuntu:focal

# Make will not work for prjxray unless this env is set
ENV ALLOW_ROOT=true

# prjxray dependencies
RUN DEBIAN_FRONTEND=noninteractive apt update -qq

RUN DEBIAN_FRONTEND=noninteractive apt install -qq -y \
            bash \
            bison \
            build-essential \
            ca-certificates \
            clang-format \
            cmake \
            colordiff \
            coreutils \
            flex \
            git \
            pypy3 \
            iproute2 \
            iputils-ping \
            libtinfo5 \
            netcat-openbsd \
            psmisc \
            python3 \
            python3-dev \
            python3-venv \
            xsltproc \
            sudo \
            bash bison build-essential ca-certificates clang-format cmake psmisc \
            colordiff coreutils git flex python3 python3-dev python3-venv xsltproc libtinfo5 libboost-all-dev libeigen3-dev \
            gzip \
            libftdi1-2 \
            libftdi1-dev \
            libhidapi-hidraw0 \
            libhidapi-dev \
            libudev-dev \
            zlib1g-dev \
            cmake \
            pkg-config \
            make \
            g++ \
            udev


# Open synthesys suite
RUN DEBIAN_FRONTEND=noninteractive apt install -qq -y yosys
# Open place-n-route tool (fork for xillinx devices)
RUN git clone https://github.com/gatecat/nextpnr-xilinx /root/nextpnr-xillinx
# Open chipdb generation tool
RUN git clone https://github.com/f4pga/prjxray /root/prjxray
# Open fpga flashing tool
RUN git clone https://github.com/trabucayre/openFPGALoader /root/openFPGALoader

WORKDIR /root/prjxray
RUN git submodule update --init --recursive
RUN make build -j$(nproc)
RUN sed -i '/# Vivado v2017\.2 (64-bit)/c return' utils/environment.sh
RUN make env
RUN ./download-latest-db.sh

WORKDIR /root/nextpnr-xillinx
RUN git submodule update --init --recursive

RUN cmake -DARCH=xilinx .
RUN make -j$(nproc)
RUN cp nextpnr-xilinx /usr/bin/

# Build chipdb for xc7a100t-1csg324
RUN pypy3 xilinx/python/bbaexport.py --device xc7a100tcsg324-1 --bba xilinx/xc7a100t.bba
RUN mkdir /root/chipdb && ./bba/bbasm --l xilinx/xc7a100t.bba /root/chipdb/xc7a100t.bin


WORKDIR /root/openFPGALoader
RUN mkdir build
WORKDIR build
RUN cmake .. 
RUN cmake --build .

RUN make install
WORKDIR ..
RUN cp 99-openfpgaloader.rules /etc/udev/rules.d/
# RUN udevadm control --reload-rules && sudo udevadm trigger
ENV XRAY_DIR=/root/prjxray


WORKDIR /work
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]