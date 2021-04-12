#Comando para crear red en docker
docker network create --subnet 172.20.0.0/16 red-dns
docker network inspect red-dns

#Datos Generales, Variables de Entorno
export VM_IP=172.20.0.10
export ATOL_IP=172.20.0.20
export TORREJA_IP=172.20.0.30
export CLUSTER_JOIN="\"$VM_IP\", \"$ATOL_IP\", \"$TORREJA_IP\""
# export CURRENT_IP=$VM_IP #SE ESPECIFICA EN EL DOCKER RUN

#Correr el nodo vm
# vm
docker rmi vm:1.0 .
docker build -t vm:1.0 .
docker run -d --name vm --hostname vm --net red-dns --ip $VM_IP -v "$PWD"/files:/root/files \
-e CURRENT_IP="$VM_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" \
--publish 8500:8500 -it vm:1.0

# Correr los contenedores con las variables de entorno
# atol
docker rmi atol:1.0 .
docker build -t atol:1.0 .
docker run -d --name atol --hostname atol --net red-dns --ip $ATOL_IP \
-e CURRENT_IP="$ATOL_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" \
--publish 53:53/udp --publish 53:53/tcp -it atol:1.0

# torreja
docker rmi torreja:1.0 .
docker build -t torreja:1.0 .
docker run -d --name torreja --hostname torreja --net red-dns --ip $TORREJA_IP \
-e CURRENT_IP="$TORREJA_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" \
--publish 54:53/udp --publish 54:53/tcp -it torreja:1.0