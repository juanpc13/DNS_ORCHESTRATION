#construccion
docker build -t torreja:1.0 .

#run
docker run --name torreja --hostname torreja -v "$PWD"/db.torreja.com:/etc/bind/db.torreja.com \
--env-file dns.env -e ipEsclavo=$atol --publish 53:53/udp --publish 53:53/tcp \
--rm -it torreja:1.0
