#Datos del cluster
local=190.87.1.130
atol=35.225.89.211
torreja=34.68.172.16
cluster="http://$local:2379,http://$atol:2379,http://$torreja:2379"

#construccion
docker build -t atol:1.0 .

#run prueba
docker run --name atol --hostname atol -e cluster="$cluster" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379 \
--rm -it atol:1.0
