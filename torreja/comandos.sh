#Datos del cluster
atol=10.128.0.2
torreja=10.128.0.3
cluster="http://$atol:2379,http://$torreja:2379"

#construccion
docker build -t torreja:1.0 .

#run prueba
docker run --name torreja --hostname torreja -e cluster="$cluster" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379/tcp \
--rm -it torreja:1.0