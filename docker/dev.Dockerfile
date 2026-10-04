# syntax=docker/dockerfile:1.7

ARG UBUNTU_IMAGE=ubuntu:24.04
ARG YOSYS_VERSION=v0.69
ARG YOSYS_COMMIT=9f75ca1f9834a39a863915b5dae0c7b1e33533bc
ARG RUSTUP_VERSION=1.28.2
ARG RUST_VERSION=1.99.0
ARG RUSTUP_SHA256_AMD64=20a06e644b0d9bd2fbdbfd52d42540bdde820ea7df86e92e533c073da0cdd43c
ARG RUSTUP_SHA256_ARM64=e3853c5a252fca15252d07cb23a1bdd9377a8c6f3efa01531109281ae47f841c
ARG TYPST_VERSION=0.15.1
ARG TYPST_SHA256_AMD64=a6d077d0a95eed5a2eba715b2dae06be954f624ccbf85758a03f389ded33118c
ARG TYPST_SHA256_ARM64=5aa8d74a3d906e60ea12a66ac2f37f8eef1b14cbad7182a745e393a10c23dcee
ARG OPENXC7_INSTALLER_VERSION=1.0.0
ARG OPENXC7_INSTALLER_COMMIT=f1f1c0caa45837eae889955c47b56abe534f3da3
ARG FPGA_PART=xc7a100tcsg324-1
ARG FPGA_BOARD=nexys_a7_100
ARG BUILD_JOBS=4
ARG DEV_USER=devuser
ARG DEV_UID=1000
ARG DEV_GID=1000

FROM ${UBUNTU_IMAGE} AS sdc_base_os

ARG DEBIAN_FRONTEND=noninteractive
ARG UBUNTU_SNAPSHOT=20260930T000000Z

ENV TZ=Europe/Bucharest \
	LANG=C.UTF-8 \
	LC_ALL=C.UTF-8 \
	UBUNTU_SNAPSHOT=${UBUNTU_SNAPSHOT}

LABEL org.opencontainers.image.title="Computer Architecture Course Environment" \
	  org.opencontainers.image.description="Ubuntu 24.04 base for the open-source course toolchain"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN --mount=type=bind,source=00-base/scripts/00-apt-snapshot.sh,target=/tmp/00-apt-snapshot.sh,ro \
	bash /tmp/00-apt-snapshot.sh

FROM sdc_base_os AS sdc_base_utils
RUN --mount=type=bind,source=00-base/scripts/10-basic-utils.sh,target=/tmp/10-basic-utils.sh,ro \
	bash /tmp/10-basic-utils.sh

FROM sdc_base_utils AS sdc_base_locale
SHELL ["/usr/bin/zsh", "-o", "pipefail", "-c"]
RUN --mount=type=bind,source=00-base/scripts/20-locale-timezone.zsh,target=/tmp/20-locale-timezone.zsh,ro \
	zsh /tmp/20-locale-timezone.zsh
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

FROM sdc_base_locale AS sdc_base_prezto
RUN --mount=type=bind,source=00-base/scripts/30-zsh-prezto.zsh,target=/tmp/30-zsh-prezto.zsh,ro \
	zsh /tmp/30-zsh-prezto.zsh

FROM sdc_base_prezto AS sdc_base_environment
RUN --mount=type=bind,source=configure_env.zsh,target=/tmp/configure_env.zsh,ro \
	zsh /tmp/configure_env.zsh 00-base

FROM sdc_base_environment AS sdc_base_stage

WORKDIR /workspace

FROM sdc_base_stage AS sdc_sim_yosys_build
ARG YOSYS_VERSION
ARG YOSYS_COMMIT
ARG BUILD_JOBS
RUN --mount=type=bind,source=10-sim/scripts/10-build-yosys.zsh,target=/tmp/10-build-yosys.zsh,ro \
	zsh /tmp/10-build-yosys.zsh

FROM sdc_base_stage AS sdc_sim_tools
COPY --from=sdc_sim_yosys_build /opt/yosys /opt/yosys
ENV PATH="/opt/yosys/bin:${PATH}"
RUN --mount=type=bind,source=10-sim/scripts/20-sim-tools.zsh,target=/tmp/20-sim-tools.zsh,ro \
	zsh /tmp/20-sim-tools.zsh

FROM sdc_sim_tools AS sdc_sim_environment
RUN --mount=type=bind,source=configure_env.zsh,target=/tmp/configure_env.zsh,ro \
	zsh /tmp/configure_env.zsh 10-sim

FROM sdc_sim_environment AS sdc_sim_stage

FROM sdc_sim_stage AS sdc_typst_rust
ARG TARGETARCH
ARG RUSTUP_VERSION
ARG RUSTUP_SHA256_AMD64
ARG RUSTUP_SHA256_ARM64
ARG RUST_VERSION
ENV RUSTUP_HOME=/opt/rustup \
	PATH="/opt/cargo/bin:${PATH}"
RUN --mount=type=bind,source=20-typst/scripts/10-rust.zsh,target=/tmp/10-rust.zsh,ro \
	zsh /tmp/10-rust.zsh

FROM sdc_typst_rust AS sdc_typst_cli
ARG TYPST_VERSION
ARG TYPST_SHA256_AMD64
ARG TYPST_SHA256_ARM64
ARG TARGETARCH
ENV TYPST_FONT_PATHS=/usr/share/fonts
RUN --mount=type=bind,source=20-typst/scripts/20-typst-cli.zsh,target=/tmp/20-typst-cli.zsh,ro \
	zsh /tmp/20-typst-cli.zsh

FROM sdc_typst_cli AS sdc_typst_fonts
RUN --mount=type=bind,source=20-typst/scripts/30-fonts.zsh,target=/tmp/30-fonts.zsh,ro \
	zsh /tmp/30-fonts.zsh

FROM sdc_typst_fonts AS sdc_typst_environment
RUN --mount=type=bind,source=configure_env.zsh,target=/tmp/configure_env.zsh,ro \
	zsh /tmp/configure_env.zsh 20-typst

FROM sdc_typst_environment AS sdc_typst_stage

FROM sdc_base_stage AS sdc_fpga_toolchain
ARG BUILD_JOBS
ARG OPENXC7_INSTALLER_VERSION
ARG OPENXC7_INSTALLER_COMMIT
RUN --mount=type=bind,source=30-fpga/scripts/10-openxc7-build.zsh,target=/tmp/10-openxc7-build.zsh,ro \
	zsh /tmp/10-openxc7-build.zsh

FROM sdc_fpga_toolchain AS sdc_fpga_chipdb
ARG FPGA_PART
RUN --mount=type=bind,source=30-fpga/scripts/20-chipdb.zsh,target=/tmp/20-chipdb.zsh,ro \
	zsh /tmp/20-chipdb.zsh

FROM sdc_typst_stage AS sdc_fpga_tools
ARG FPGA_PART
ARG FPGA_BOARD
COPY --from=sdc_fpga_chipdb /opt/openxc7 /opt/openxc7
ENV PATH="/opt/openxc7/bin:${PATH}:/opt/openxc7/venv/bin" \
	NEXTPNR_XILINX_DIR=/opt/openxc7 \
	NEXTPNR_XILINX_PYTHON_DIR=/opt/openxc7/lib/python \
	PRJXRAY_DB_DIR=/opt/openxc7/share/nextpnr/prjxray-db \
	CHIPDB=/opt/openxc7/chipdb \
	FPGA_PART=${FPGA_PART} \
	FPGA_BOARD=${FPGA_BOARD} \
	FPGA_FAMILY=artix7
RUN --mount=type=bind,source=30-fpga/scripts/30-fpga-runtime.zsh,target=/tmp/30-fpga-runtime.zsh,ro \
	zsh /tmp/30-fpga-runtime.zsh

FROM sdc_fpga_tools AS sdc_fpga_environment
RUN --mount=type=bind,source=configure_env.zsh,target=/tmp/configure_env.zsh,ro \
	zsh /tmp/configure_env.zsh 30-fpga

FROM sdc_fpga_environment AS sdc_fpga_stage

FROM sdc_fpga_stage AS sdc_dev_account
ARG DEV_USER
ARG DEV_UID
ARG DEV_GID
RUN --mount=type=bind,source=40-user/scripts/10-devuser.zsh,target=/tmp/10-devuser.zsh,ro \
	zsh /tmp/10-devuser.zsh

FROM sdc_dev_account AS sdc_dev_prezto
ARG DEV_USER
RUN --mount=type=bind,source=00-base/scripts/30-zsh-prezto.zsh,target=/tmp/30-zsh-prezto.zsh,ro \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" \
		zsh /tmp/30-zsh-prezto.zsh

FROM sdc_dev_prezto AS sdc_dev_environment
ARG DEV_USER

RUN --mount=type=bind,source=configure_env.zsh,target=/tmp/configure_env.zsh,ro \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" zsh -f /tmp/configure_env.zsh 00-base && \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" zsh -f /tmp/configure_env.zsh 10-sim && \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" zsh -f /tmp/configure_env.zsh 20-typst && \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" zsh -f /tmp/configure_env.zsh 30-fpga && \
	runuser -u "${DEV_USER}" -- env HOME="/home/${DEV_USER}" ZDOTDIR="/home/${DEV_USER}" zsh -f /tmp/configure_env.zsh 40-user

FROM sdc_dev_environment AS sdc_dev_stage
ARG DEV_USER
ENV HOME="/home/${DEV_USER}"
USER ${DEV_USER}
WORKDIR /workspace
CMD ["zsh", "-l"]
