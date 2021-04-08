# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc etcd iproute2 iputils-ping

# Directorio de trabajo
WORKDIR /root

# Variable de entorno para usar etcdctl
ENV ETCDCTL_API=3

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/bash\n\
etcd &\n\
etcdctl get atol_local --print-value-only | base64 --decode > /etc/bind/named.conf.local\n\
etcdctl get atol_db --print-value-only | base64 --decode > /etc/bind/db.atol.com\n\
named-checkzone atol.com /etc/bind/db.atol.com\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind &\n\
/bin/bash' > update-dns.sh

# Bind9
EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/bin/bash", "update-dns.sh"]
