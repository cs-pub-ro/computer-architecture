# Download base image ubuntu 22.04
FROM ubuntu:22.04

# LABEL about the custom image
LABEL maintainer="stefan_dan.ciocirlan@upb.ro"
LABEL version="0.1"
LABEL description="Latex environment for AC course"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive
# display
ENV DISPLAY=host.docker.internal:0.0
# timezone
ENV TZ=Asia/Singapore

# Update Ubuntu Software repository
# https://stackoverflow.com/questions/39760663/docker-ubuntu-bin-sh-1-locale-gen-not-found
# https://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue/229512#229512
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y locales && \
    locale-gen "en_US.UTF-8" && \
    dpkg-reconfigure locales && \
    apt-get install -y curl sudo zip unzip git python3 python3-pip texlive-full dvipng cm-super openjdk-19-jre graphviz wget
    
#RUN wget http://beta.plantuml.net/batikAndFop.zip -P ./plantuml && wget http://beta.plantuml.net/plantuml-jlatexmath.zip -P ./plantuml
# RUN unzip -o ./plantuml/batikAndFop.zip -d ./plantuml && unzip -o ./plantuml/plantuml-jlatexmath.zip -d ./plantuml
# RUN java -Djava.awt.headless=true -jar ./plantuml/plantuml-1.2023.11.jar ./diagrams/architecturev2.uml -o ./plantuml -tpdf
# for latex coding with minted
RUN pip3 install Pygments