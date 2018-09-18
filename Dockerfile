FROM ubuntu:16.04
LABEL maintainer="ELOUIZ BADR <elouiz.badr@gmail.com>"
LABEL description="A Dockerized SSH Server."

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server
RUN mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh && chmod 700 /root/.ssh && \
    touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

COPY id_rsa.pub /root/.ssh

RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    rm /root/.ssh/id_rsa.pub && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
