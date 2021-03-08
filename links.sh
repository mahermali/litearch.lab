CLIENT=`multipass list | awk -F ' ' '(NR>1) $1 ~ "C" {printf "%s",$3; exit}' | awk '{print substr($0, 1, length($0))}'`
echo $CLIENT
echo "Consul: http://${CLIENT}:8500/ui/"
echo "Nomad:  http://${CLIENT}:4646/ui/"
echo "Fabio:  http://${CLIENT}:9998/"
echo "Portal:  http://${CLIENT}/trafik-portal"
multipass exec C1 -- dig +short trafik-api.service.consul @localhost | xargs printf "API URL: http://%s/trafik-api/topology\n"
