FROM alpine:latest AS downloader

RUN apk add --no-cache wget tar

WORKDIR /sources

# get new mirror from https://www.openssh.com/portable.html should this one fail
RUN wget https://ftp.hostserver.de/pub/OpenBSD/OpenSSH/portable/openssh-9.9p1.tar.gz -O openssh.tar.gz && \
    tar -xzvf openssh.tar.gz

FROM gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0 


COPY ./CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache 

RUN yum -y install xorg-x11-xauth 


COPY --from=downloader /sources/openssh-9.9p1 /src/openssh-portable

WORKDIR /src/openssh-portable
RUN ./configure --without-openssl --without-zlib
RUN make install
COPY ./sshd_config /usr/local/etc/sshd_config

# modify this as you wish
RUN passwd root --delete

RUN useradd sshd

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN echo "cd /workspaces/computer-architecture" >> /root/.bashrc

WORKDIR /workspaces/computer-architecture
# uncomment if vivado shows blank screen
# RUN echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> /root/.bashrc

CMD ["/entrypoint.sh"]
