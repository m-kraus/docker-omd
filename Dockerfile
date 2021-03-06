FROM debian:9-slim
MAINTAINER Michael Kraus, michael.kraus@consol.de
EXPOSE 80 443 22 4730 5666 8086 9090 9091 9100

ENV DEBIAN_FRONTEND noninteractive

RUN  echo 'net.ipv6.conf.default.disable_ipv6 = 1' > /etc/sysctl.d/20-ipv6-disable.conf; \
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/20-ipv6-disable.conf; \
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/20-ipv6-disable.conf; \
cat /etc/sysctl.d/20-ipv6-disable.conf; sysctl -p

RUN gpg --keyserver keys.gnupg.net --recv-keys F8C1CA08A57B9ED7 && \
gpg --armor --export F8C1CA08A57B9ED7 | apt-key add - && \
echo 'deb http://labs.consol.de/repo/testing/debian stretch main' >> /etc/apt/sources.list && \
apt-get update && \
apt-get install -y omd-labs-edition-daily net-tools iputils-ping openssh-server; \
apt-get clean; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i 's|echo "on"$|echo "off"|' /opt/omd/versions/default/lib/omd/hooks/TMPFS

RUN omd create demo && \
su - demo -c "ssh-keygen -b 2048 -t rsa -N '' -f /omd/sites/demo/.ssh/id_rsa" && \
mv /omd/sites/demo/local /omd/sites/demo/local.docker && \
mv /omd/sites/demo/etc /omd/sites/demo/etc.docker && \
mv /omd/sites/demo/var /omd/sites/demo/var.docker

VOLUME /omd/sites/demo/local
VOLUME /omd/sites/demo/etc
VOLUME /omd/sites/demo/var

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
