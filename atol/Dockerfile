# debian:bullseye
FROM debian:bullseye

# Actualizando repositario y agregando paquetes para dns
RUN apt update
RUN apt install -y bind9 bind9utils bind9-doc iproute2 iputils-ping

# Directorio de trabajo
WORKDIR /root

# Script para variables de entorno en named.config.local
RUN echo '#!/bin/bash\n\
named-checkzone atol.com /etc/bind/db.atol.com\n\
/usr/sbin/named -g -c /etc/bind/named.conf -u bind &\n\
/bin/bash' > update-dns.sh

# Consult

# Bind9
EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/bin/bash", "update-dns.sh"]
