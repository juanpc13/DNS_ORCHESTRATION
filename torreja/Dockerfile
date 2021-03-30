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
bash ' > /root/initipv6.sh

EXPOSE 53/udp 53/tcp

ENTRYPOINT ["/bin/bash","/root/initipv6.sh"]
#CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
#/usr/sbin/named -g -c /etc/bind/named.conf -u bind
