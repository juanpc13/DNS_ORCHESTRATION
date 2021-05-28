```console
export VM_IP=172.20.0.10
export ATOL_IP=172.20.0.20
export TORREJA_IP=172.20.0.30
export CLUSTER_JOIN="\"$VM_IP\", \"$ATOL_IP\", \"$TORREJA_IP\""
```
#puede ser por IPV4 tambien
export IPV6=2001:0:53aa:64c:243b:4d34:41a8:fe7d
_________________________________________________________________________
1. Arranque el contenedor
```console
    cd vm/
    docker run -d --name vm --hostname vm --net red-dns --ip $VM_IP -v "$PWD"/files:/root/files -e CURRENT_IP="$VM_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" --publish 8500:8500 -it vm:1.0
    docker run -d --name atol --hostname atol --net red-dns --ip $ATOL_IP -e CURRENT_IP="$ATOL_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" --publish 53:53/udp --publish 53:53/tcp -it atol:1.0
    docker run -d --name torreja --hostname torreja --net red-dns --ip $TORREJA_IP -e CURRENT_IP="$TORREJA_IP" -e CLUSTER_JOIN="$CLUSTER_JOIN" --publish 54:53/udp --publish 54:53/tcp -it torreja:1.0
```
    1.1 Preguntar por registro tipo A al servicio dueño de X
        dig "@$IPV6" www.atol.com +short -p 53 A

    1.2 Preguntar por registro A al servicio no dueño de X
        dig "@$IPV6" www.torreja.com +short -p 53 A

    1.3 Preguntar por registro tipo A al servicio dueño de Y
        dig "@$IPV6" www.torreja.com +short -p 54 A

    1.4 Preguntar por registro A al servicio no dueño de Y
        dig "@$IPV6" www.atol.com +short -p 54 A
_________________________________________________________________________
2. Detener contenedores e Arrancar contenedores para intercambio de zonas
```console
    docker stop torreja atol
    docker start torreja atol
```
    2.1 Preguntar por registro A al servicio no dueño de X
        dig "@$IPV6" www.torreja.com +short -p 53 A

    2.2 Preguntar por registro A al servicio no dueño de Y
        dig "@$IPV6" www.atol.com +short -p 54 A
