FROM ubuntu:16.04
LABEL maintainer="ELOUIZ BADR <elouiz.badr@gmail.com>"
LABEL description="A Dockerized SSH Server."

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates apt-transport-https openssh-server python && \
    mkdir /var/run/sshd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    mkdir /root/.ssh && \
    chmod -R go= /root/.ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY rsa_key.pub /root/.ssh/rsa_key.pub

RUN cat /root/.ssh/rsa_key.pub >> /root/.ssh/authorized_keys && \
    rm /root/.ssh/rsa_key.pub 

EXPOSE 22 80 443

CMD ["/usr/sbin/sshd", "-D"]
