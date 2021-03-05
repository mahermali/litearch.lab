CLIENT=`multipass list | awk -F ' ' '(NR>1) $1 ~ "S" {printf "%s",$3; exit}' | awk '{print substr($0, 1, length($0))}'`
echo $CLIENT
echo "Consul: http://${CLIENT}:8500/ui/"
echo "Nomad:  http://${CLIENT}:4646/ui/"
echo "Fabio:  http://${CLIENT}:9998/"