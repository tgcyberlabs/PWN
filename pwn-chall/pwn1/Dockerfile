FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xinetd \
        lib32z1 \
        libc6-i386 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -U ctf

WORKDIR /home/ctf

RUN cp -R --parents /lib* /home/ctf && \
    cp -R --parents /usr/lib* /home/ctf && \
    mkdir -p /home/ctf/lib64 && cp -R /lib64/* /home/ctf/lib64/

RUN mkdir -p /home/ctf/dev && \
    mknod -m 666 /home/ctf/dev/null c 1 3 && \
    mknod -m 666 /home/ctf/dev/zero c 1 5 && \
    mknod -m 666 /home/ctf/dev/random c 1 8 && \
    mknod -m 666 /home/ctf/dev/urandom c 1 9

RUN mkdir -p /home/ctf/bin && \
    cp /bin/sh /home/ctf/bin/ && \
    cp /bin/ls /home/ctf/bin/ && \
    cp /bin/cat /home/ctf/bin/

RUN echo "includedir /etc/xinetd.d" >> /etc/xinetd.conf && \
    mkdir -p /var/log/xinetd && \
    chmod 755 /var/log/xinetd

COPY ctf.xinetd /etc/xinetd.d/ctf
COPY xinetedService.sh /xinetedService.sh
COPY files/ /home/ctf/

RUN chown -R root:ctf /home/ctf && \
    chmod -R 750 /home/ctf && \
    chmod 740 /home/ctf/flag.txt && \
    find /home/ctf -type d -exec chmod 550 {} \; && \
    chmod +x /xinetedService.sh

CMD ["/xinetedService.sh"]
EXPOSE 9999