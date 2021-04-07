#construccion
docker build -t atol:1.0 .

#run prueba
docker run --name atol --hostname atol \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379 \
--rm -it atol:1.0
