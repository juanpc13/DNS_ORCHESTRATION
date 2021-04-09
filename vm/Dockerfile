# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y iproute2 iputils-ping consul

# Configuraciones de consul
ENV DATA_DIR=data-dir
ENV CONFIG_DIR=config-dir
# ./consul keygen
ENV ENCRYPT="qKWxUbmRyJnIPbRK2bmhKqP/1CQQ0whXncHhhFHX8E0="

# Directorio Principal
WORKDIR /root
# Directorios de consul
RUN mkdir DATA_DIR CONFIG_DIR

# Script inicar servicio consul
RUN echo '#!/bin/bash\n\
envsubst < "config.json.bk" > $CONFIG_DIR/config.json\n\
consul agent -node=vm -server -ui -advertise=$VM_IP -bind=$VM_IP -data-dir=$DATA_DIR -config-dir=$CONFIG_DIR \n\
consul kv put atol_local @local/named.conf.local.atol\n\
consul kv put atol_db @db/db.atol.com\n\
bash' > run-cluster.sh

# Consul ports
EXPOSE 8300 8500

ENTRYPOINT ["/bin/bash", "run-cluster.sh"]
