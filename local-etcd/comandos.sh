#Datos Generales
#IPV4
atol=10.128.0.2
#atol=34.68.172.16
torreja=10.128.0.3
#torreja=34.72.150.183
vm=10.128.0.4
#vm=34.68.214.22
cluster="atol=http://$atol:2380,torreja=http://$torreja:2380,vm=http://$vm:2380"

#ETCD
export ETCDCTL_API=3

#Cargando Datos para DB y Local en etcd
atol_local=`cat local/named.conf.local.atol | base64`
atol_db=`cat db/db.atol.com | base64`
torreja_local=`cat local/named.conf.local.torreja | base64`
torreja_db=`cat db/db.torreja.com | base64`

#Asginando al nodo la llave valor de los archivos
etcdctl put atol_local "$atol_local"
etcdctl put atol_db "$atol_db"
etcdctl put torreja_local "$torreja_local"
etcdctl put torreja_db "$torreja_db"

#Correr el nodo vm
current_ip=$vm
etcd_cmd="etcd --name vm --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 --listen-client-urls http://$current_ip:2379,http://127.0.0.1:2379 
  --advertise-client-urls http://$current_ip:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster --initial-cluster-state new"
$etcd_cmd

# Correr los contenedores con las variables de entorno
# atol
docker build -t atol:1.0 .

current_ip=$atol
etcd_cmd="etcd --name atol --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 --listen-client-urls http://$current_ip:2379,http://127.0.0.1:2379 
  --advertise-client-urls http://$current_ip:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster --initial-cluster-state new"

docker run --name atol --hostname atol -e etcd_cmd="$etcd_cmd" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379 --publish 2380:2380 \
--rm -it atol:1.0

# torreja
docker build -t torreja:1.0 .

current_ip=$torreja
etcd_cmd="etcd --name torreja --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 --listen-client-urls http://$current_ip:2379,http://127.0.0.1:2379 
  --advertise-client-urls http://$current_ip:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster --initial-cluster-state new"

docker run --name torreja --hostname torreja -e etcd_cmd="$etcd_cmd" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379 --publish 2380:2380 \
--rm -it torreja:1.0