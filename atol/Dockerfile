# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc

# Script para variables de entorno en named.config.local y db.atol.com
RUN echo '#!/bin/sh\n\
echo -e ${NamedConfLocal//ipEsclavo/$ipEsclavo} > /etc/bind/named.conf.local\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind\n\
/bin/bash' > /root/update-dns.sh

EXPOSE 53/udp 53/tcp

ENTRYPOINT ["/bin/bash", "/root/update-dns.sh"]
