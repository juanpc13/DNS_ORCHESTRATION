# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc etcd

# Variable de entorno para usar etcdctl
ENV ETCDCTL_API=3

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/sh\n\
etcd --listen-client-urls="$cluster" --advertise-client-urls="$cluster"\n\
etcdctl get torreja_local --print-value-only | base64 --decode > /etc/bind/named.conf.local\n\
etcdctl get torreja_db --print-value-only | base64 --decode > /etc/bind/db.torreja.com\n\
named-checkzone torreja.com /etc/bind/db.torreja.com\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind\n\
/bin/bash' > /root/update-dns.sh

# etcd
EXPOSE 2379/tcp

# Bind9
EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/bin/bash", "/root/update-dns.sh"]