# debian:bullseye
FROM debian:bullseye


# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc iproute2 miredo procps
RUN sysctl net.ipv6.conf.all.disable_ipv6=0 && sysctl net.ipv6.conf.default.disable_ipv6=0 && sysctl net.ipv6.conf.lo.disable_ipv6=0
RUN service miredo restart
#Editando configuraciones de archivos de local y zona

#named.conf.local
RUN echo 'zone "torreja.com" {\n\
    type master;\n\
    notify yes;\n\
    allow-transfer  {\n\
        128.0.0.1;//IP-Slave\n\
    };\n\
    also-notify {\n\
        128.0.0.1;//IP-Slave\n\
    };\n\
    file "/etc/bind/db.torreja.com";\n\
};\n\
\n\
zone "atol.com" {\n\
    type slave;\n\
    file "/var/cache/bind/db.atol.com";\n\
    masters{\n\
        128.0.0.1;//IP-Master\n\
    };\n\
};' > /etc/bind/named.conf.local


#db.torreja.com
RUN echo '; Datos Generales de la ZONA\n\
$TTL    86400\n\
\n\
; Record Inicio de la Autoridad de la ZONA\n\
@       IN      SOA     ns1.torreja.com. andreac.torreja.com. (\n\
                              1         ; Serial\n\
                         604800         ; Refresh\n\
                          86400         ; Retry\n\
                        2419200         ; Expire\n\
                          86400 )       ; Negative Cache TTL\n\
;\n\
\n\
; Name Servers para el dominio\n\
@       IN      NS      ns1.torreja.com.\n\
\n\
; Los registros para direcciones\n\
ns1     IN      A       191.87.1.130\n\
www     IN      A       191.87.1.130' > /etc/bind/db.torreja.com

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
#/usr/sbin/named -g -c /etc/bind/named.conf -u bind
