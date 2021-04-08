# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y etcd iproute2 iputils-ping

# Directorio de trabajo
WORKDIR /root

# Variable de entorno para usar etcdctl
ENV ETCDCTL_API=3

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/bash\n\
etcd &\n\
atol_local=`cat local/named.conf.local.atol | base64`\n\
atol_db=`cat db/db.atol.com | base64`\n\
torreja_local=`cat local/named.conf.local.torreja | base64`\n\
torreja_db=`cat db/db.torreja.com | base64`\n\
etcdctl put atol_local "$atol_local"\n\
etcdctl put atol_db "$atol_db"\n\
etcdctl put torreja_local "$torreja_local"\n\
etcdctl put torreja_db "$torreja_db"\n\
bash' > run-etcd.sh

ENTRYPOINT ["/bin/bash", "run-etcd.sh"]
