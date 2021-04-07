#Datos Generales
#IPV4
local=190.87.1.130
atol=35.225.89.211
torreja=34.68.172.16
cluster="http://$local:2379,http://$atol:2379,http://$torreja:2379"

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

