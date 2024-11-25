# syntax=docker/dockerfile:1
FROM ubuntu:22.04

LABEL maintainer="stefan_dan.ciocirlan@upb.ro"
LABEL version="0.2"
LABEL description="The open source toolchain docker image for the Computer Architecture course"

# for apt-get
# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Bucharest

# Update Ubuntu Software repository
# https://stackoverflow.com/questions/39760663/docker-ubuntu-bin-sh-1-locale-gen-not-found
# https://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue/229512#229512
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y locales && \
    locale-gen "en_US.UTF-8" && \
    dpkg-reconfigure locales

# install basic tools
RUN apt-get install -y curl sudo zip unzip wget git make gcc g++ nano

# intall texlive-full
RUN apt-get install -y texlive-full dvipng cm-super

# install gtkwave through apt-get
# https://github.com/gtkwave/gtkwave
# RUN apt-get install -y gtkwave
# install icaurs
# https://github.com/steveicarus/iverilog
# RUN apt-get install -y iverilog
# install yosys
# RUN apt-get install -y yosys
# install verilator
# RUN apt-get install -y verilator
RUN apt-get install -y iverilog yosys verilator gtkwave

# install python3 and pip3 for Pygments
RUN apt-get install -y python3 python3-pip && \
    pip3 install Pygments

# install java and graphviz
# RUN apt-get install -y openjdk-19-jre graphviz

# install C/C++ development tools
# RUN apt-get install -y build-essential gdb clang-format 