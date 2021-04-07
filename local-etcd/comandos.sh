#Datos Generales
#IPV4
atol=10.128.0.2
#atol=34.68.172.16
torreja=10.128.0.3
#torreja=34.72.150.183
vm=10.128.0.4
#vm=34.68.214.22
current_ip=$atol

cluster="atol=http://$atol:2380,torreja=http://$torreja:2380,vm=http://$vm:2380"

etcd_cmd="etcd --name cluster --initial-advertise-peer-urls http://$current_ip:2380 \
  --listen-peer-urls http://$current_ip:2380 --listen-client-urls http://$current_ip:2379,http://127.0.0.1:2379 
  --advertise-client-urls http://$current_ip:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $cluster --initial-cluster-state new"

#ETCD
export ETCDCTL_API=3

#Datos para DB y Local de atol en etcd
atol_local=`cat local/named.conf.local.atol | base64`
atol_db=`cat db/db.atol.com | base64`
etcdctl put atol_local "$atol_local"
etcdctl put atol_db "$atol_db"

#Datos para DB y Local de torreja en etcd
torreja_local=`cat local/named.conf.local.torreja | base64`
torreja_db=`cat db/db.torreja.com | base64`
etcdctl put torreja_local "$torreja_local"
etcdctl put torreja_db "$torreja_db"

#Consumir Datos
etcdctl get atol_local --print-value-only | base64 --decode
etcdctl get atol_db --print-value-only | base64 --decode
etcdctl get torreja_local --print-value-only | base64 --decode
etcdctl get torreja_db --print-value-only | base64 --decode

#Correr cluster
etcd --listen-client-urls="$cluster" --advertise-client-urls="$cluster"
#atol
etcd --name atol --initial-advertise-peer-urls http://$atol:2380 \
  --listen-peer-urls http://$atol:2380 --listen-client-urls http://$atol:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://$atol:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster atol=http://$atol:2380,torreja=http://$torreja:2380 --initial-cluster-state new
#torreja
etcd --name torreja --initial-advertise-peer-urls http://$torreja:2380 \
  --listen-peer-urls http://$torreja:2380 --listen-client-urls http://$torreja:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://$torreja:2379 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster atol=http://$atol:2380,torreja=http://$torreja:2380 --initial-cluster-state new


# Correr los contenedores con las variables de entorno
# atol
docker build -t atol:1.0 .
docker run --name atol --hostname atol -e etcd_cmd="$etcd_cmd" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379/tcp --publish 2380:2380/tcp \
--rm -it atol:1.0

# torreja
docker build -t torreja:1.0 .
docker run --name torreja --hostname torreja -e etcd_cmd="$etcd_cmd" \
--publish 53:53/udp --publish 53:53/tcp --publish 2379:2379/tcp \
--rm -it torreja:1.0