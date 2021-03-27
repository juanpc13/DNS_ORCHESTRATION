# debian:bullseye
FROM debian:bullseye


# Actualizando repositario y agregando paquetes para dns
RUN apt update 
RUN apt install -y bind9 bind9utils bind9-doc

#Editando configuraciones de archivos de local y zona

#named.conf.local
RUN echo 'zone "atol.com" {\n\
    type master;\n\
    notify yes;\n\
    allow-transfer  {\n\
        127.0.0.1;//IP-Slave\n\
    };\n\
    also-notify {\n\
        127.0.0.1;//IP-Slave\n\
    };\n\
    file "/etc/bind/db.atol.com";\n\
};\n\
\n\
zone "torreja.com" {\n\
    type slave;\n\
    file "/var/cache/bind/db.torreja.com";\n\
    masters{\n\
        127.0.0.1;//IP-Master\n\
    };\n\
};' > /etc/bind/named.conf.local


#db.atol.com
RUN echo '; Datos Generales de la ZONA\n\
$TTL    86400\n\
\n\
; Record Inicio de la Autoridad de la ZONA\n\
@       IN      SOA     ns1.atol.com. jcpleitez.atol.com. (\n\
                              1         ; Serial\n\
                         604800         ; Refresh\n\
                          86400         ; Retry\n\
                        2419200         ; Expire\n\
                          86400 )       ; Negative Cache TTL\n\
;\n\
\n\
; Name Servers para el dominio\n\
@       IN      NS      ns1.atol.com.\n\
\n\
; Los registros para direcciones\n\
ns1     IN      A       190.87.1.130\n\
www     IN      A       190.87.1.130' > /etc/bind/db.atol.com

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
#/usr/sbin/named -g -c /etc/bind/named.conf -u bind
