#Comando para crear red en docker
docker network create --subnet 172.20.0.0/16 red-dns
docker network inspect red-dns

#Datos Generales, Variables de Entorno
export VM_IP=172.20.0.10
export ATOL_IP=172.20.0.20
export TORREJA_IP=172.20.0.30 #IMPLEMENTAR LUEGO
export CLUSTER_JOIN="\"$VM_IP\", \"$ATOL_IP\""
# export CURRENT_IP=$VM_IP #SE ESPECIFICA EN EL DOCKER RUN

#Correr el nodo vm
# vm
docker rmi vm:1.0 .
docker build -t vm:1.0 .
docker run --name vm --hostname vm --net red-dns --ip $VM_IP -v "$PWD"/files:/root/files \
-e VM_IP="$VM_IP" -e ATOL_IP="$ATOL_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" -e CURRENT_IP="$VM_IP" \
--publish 8500:8500 --rm -it vm:1.0

# Correr los contenedores con las variables de entorno
# atol
docker rmi atol:1.0 .
docker build -t atol:1.0 .
docker run --name atol --hostname atol --net red-dns --ip $ATOL_IP \
-e VM_IP="$VM_IP" -e ATOL_IP="$ATOL_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" -e CURRENT_IP="$ATOL_IP" \
--publish 53:53/udp --publish 53:53/tcp --rm -it atol:1.0

# torreja
docker rmi torreja:1.0 .
docker build -t torreja:1.0 .
docker run --name torreja --hostname torreja --net red-dns --ip $torreja \
--publish 54:53/udp --publish 54:53/tcp \
--rm -it torreja:1.0