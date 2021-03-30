# debian:bullseye
FROM debian:bullseye


# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc iproute2 miredo procps

#Habilitando ipv6 e iniciando teredo
RUN echo '\n\
sysctl net.ipv6.conf.all.disable_ipv6=0\n\
sysctl net.ipv6.conf.default.disable_ipv6=0\n\
sysctl net.ipv6.conf.lo.disable_ipv6=0\n\
service miredo restart\n\
ip -6 addr show teredo | grep -m 1 global' > /root/initipv6.sh

# Script para variables de entorno en named.config.local y db.torreja.com
RUN echo '\n\
#!/bin/sh\n\
echo -e ${NamedConfLocal//ipEsclavo/$ipEsclavo} > /etc/bind/named.conf.local\n\
echo $DbTorrejaCom > /etc/bind/db.torreja.com\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind' > /root/update-dns.sh

# Script para variables de entorno en named.config.local y db.torreja.com
RUN echo '\n\
#!/bin/sh\n\
/bin/bash /root/initipv6.sh\n\
/bin/bash /root/update-dns.sh\n\
/bin/bash' > /root/start.sh

EXPOSE 53/udp 53/tcp

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
