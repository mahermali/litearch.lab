api=$(multipass exec C1 -- dig +short trafik-api.service.consul @localhost | xargs printf "http://%s/trafik-api")

while [[ ! -z "$var" ]]
do
  echo $api
  api=$(multipass exec C1 -- dig +short trafik-api.service.consul @localhost | xargs printf "http://%s/trafik-api") 
done
echo $api
multipass exec C1 -- cp "$(pwd)/jobs/litearch/trafik/portal.nomad" /tmp/portal.nomad
multipass exec C1 -- sed -i 's|#API|'"$api"'|g' "/tmp/portal.nomad"
multipass exec C1 -- nomad run "/tmp/portal.nomad"