# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc iproute2 iputils-ping gettext consul

# Configuraciones de consul
ENV DATA_DIR=data-dir
ENV CONFIG_DIR=config-dir
# ./consul keygen
ENV ENCRYPT="qKWxUbmRyJnIPbRK2bmhKqP/1CQQ0whXncHhhFHX8E0="

# Directorio de trabajo
WORKDIR /root
# Directorios de consul
RUN mkdir $DATA_DIR $CONFIG_DIR

# Archivo de Plantilla para configuraciones
RUN echo '{"advertise_addr": "$CURRENT_IP","bind_addr": "$CURRENT_IP","client_addr": "0.0.0.0",\
"datacenter": "Protocolos","data_dir": "$DATA_DIR","domain": "consul","enable_script_checks": true,\
"dns_config": {"enable_truncate": true,"only_passing": true},"enable_syslog": false,"encrypt": "$ENCRYPT",\
"leave_on_terminate": true,"log_level": "INFO","rejoin_after_leave": true,"retry_join": [$CLUSTER_JOIN],\
"server": true,"start_join": [$CLUSTER_JOIN],"ui": true}' > config.json.bk

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/bash\n\
envsubst < "config.json.bk" > $CONFIG_DIR/config.json\n\
consul agent -node=atol -config-dir=$CONFIG_DIR &\n\
sleep 5\n\
consul kv get atol_local > /etc/bind/named.conf.local\n\
consul kv get atol_db > /etc/bind/db.atol.com\n\
named-checkzone atol.com /etc/bind/db.atol.com\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind &\n\
consul watch -type=keyprefix -prefix=atol/ sh /root/reload-dns.sh &\n\
/bin/bash' > update-dns.sh

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/bash\n\
consul kv get atol/local > /etc/bind/named.conf.local\n\
consul kv get atol/db > /etc/bind/db.atol.com\n\
named-checkzone atol.com /etc/bind/db.atol.com\n\
/usr/sbin/rndc reload' > reload-dns.sh

# Consul ports
EXPOSE 8300 8500

# Bind9
EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/bin/bash", "update-dns.sh"]
