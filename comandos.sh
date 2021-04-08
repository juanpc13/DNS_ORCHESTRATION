#Comando para crear red en docker
docker network create --subnet 172.20.0.0/16 red-dns
docker network inspect red-dns

#Datos Generales
#IPV4
atol=172.20.0.2
#atol=34.68.172.16
torreja=172.20.0.3
#torreja=34.72.150.183
vm=172.20.0.4
#vm=34.68.214.22

#Comandos para agreagar nodo
etcdctl member list
etcdctl member add atol --peer-urls=http://$atol:2380
etcdctl member add torreja --peer-urls=http://$torreja:2380


#Correr el nodo vm
# vm
docker rmi vm:1.0 .
docker build -t vm:1.0 .
current_ip=$vm
cluster="atol=http://$atol:2380,vm=http://$vm:2380"
etcd_cmd="etcd --name atol --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 \
  --listen-client-urls http://$current_ip:2379,http://localhost:2379 \
  --advertise-client-urls http://$current_ip:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster \
  --initial-cluster-state new"
docker run --name vm --hostname vm -e etcd_cmd="$etcd_cmd" --net red-dns --ip $vm \
-v "$PWD"/db/:/root/db/ -v "$PWD"/local/:/root/local/ --rm -it vm:1.0

# Correr los contenedores con las variables de entorno
# atol
docker rmi atol:1.0 .
docker build -t atol:1.0 .
current_ip=$atol
cluster="atol=http://$atol:2380,vm=http://$vm:2380"
etcd_cmd="etcd --name atol --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 \
  --listen-client-urls http://$current_ip:2379,http://localhost:2379 \
  --advertise-client-urls http://$current_ip:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster \
  --initial-cluster-state new"
docker run --name atol --hostname atol -e etcd_cmd="$etcd_cmd" --net red-dns --ip $atol \
--publish 53:53/udp --publish 53:53/tcp \
--rm -it atol:1.0

# torreja
docker rmi torreja:1.0 .
docker build -t torreja:1.0 .
current_ip=$torreja
cluster="atol=http://$atol:2380,torreja=http://$torreja:2380,vm=http://$vm:2380"
etcd_cmd="etcd --name atol --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 \
  --listen-client-urls http://$current_ip:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://$current_ip:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster \
  --initial-cluster-state new"
docker run --name torreja --hostname torreja -e etcd_cmd="$etcd_cmd" --net red-dns --ip $torreja \
--publish 54:53/udp --publish 54:53/tcp \
--rm -it torreja:1.0