# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y iproute2 iputils-ping gettext consul

# Configuraciones de consul
ENV DATA_DIR=data-dir
ENV CONFIG_DIR=config-dir
# ./consul keygen
ENV ENCRYPT="qKWxUbmRyJnIPbRK2bmhKqP/1CQQ0whXncHhhFHX8E0="

# Directorio Principal
WORKDIR /root
# Directorios de consul
RUN mkdir $DATA_DIR $CONFIG_DIR

# Script inicar servicio consul
RUN echo '#!/bin/bash\n\
envsubst < "files/config.json.bk" > $CONFIG_DIR/config.json\n\
consul agent -node=vm -bootstrap-expect 1 -config-dir=$CONFIG_DIR &\n\
sleep 5\n\
consul kv put atol/local @files/local/named.conf.local.atol\n\
consul kv put atol/db @files/db/db.atol.com\n\
consul kv put torreja/local @files/local/named.conf.local.torreja\n\
consul kv put torreja/db @files/db/db.torreja.com\n\
bash' > run-cluster.sh

# Consul ports
EXPOSE 8300 8500

ENTRYPOINT ["/bin/bash", "run-cluster.sh"]
