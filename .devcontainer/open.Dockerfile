# syntax=docker/dockerfile:1
FROM ubuntu:22.04

LABEL maintainer="stefan_dan.ciocirlan@upb.ro"
LABEL version="0.1"
LABEL description="The open source toolchain docker image for the Computer Architecture course"

# for apt-get
# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Bucharest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nano git unzip wget gedit make gcc g++
# install gtkwave through apt-get
# https://github.com/gtkwave/gtkwave
RUN apt-get install -y gtkwave

# install icaurs
# https://github.com/steveicarus/iverilog
RUN apt-get install -y iverilog

# install yosys
RUN apt-get install -y yosys
# install verilator
RUN apt-get install -y verilator
