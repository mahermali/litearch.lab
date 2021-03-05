SERVER_COUNT=3
declare -a CLIENTS=("node,app" "node,app" "node,storge")

multipass delete --all
multipass purge


# Servers

for ((i=1; i <= $SERVER_COUNT; i++));
do
    SERVER="S$i"
    multipass launch -m 1G --name $SERVER
    multipass mount "$(pwd)" $SERVER
    multipass exec $SERVER -- cp "$(pwd)/server.sh" /home/ubuntu
done 

SERVERS=`multipass list | awk -F ' ' '(NR>1) $1 ~ "S" {printf "\"%s\",",$3}' | awk '{print substr($0, 1, length($0)-1)}'`
echo $SERVERS

function installServer {
    SERVER="S$1"
    multipass exec $SERVER -- sed -i "s/%IPS%/$SERVERS/g" /home/ubuntu/server.sh
    multipass exec $SERVER -- sed -i "s/#expected/$SERVER_COUNT/g" /home/ubuntu/server.sh
    multipass exec $SERVER -- sh /home/ubuntu/server.sh
}

for ((i=1; i <= $SERVER_COUNT; i++));
do
    installServer $i    
done    

# Clients

function installClient {
    CLIENT="C$1"    
      
    multipass launch -m 2G --disk 20G --name $CLIENT
    multipass mount "$(pwd)" $CLIENT
    multipass exec $CLIENT -- cp "$(pwd)/client.sh" /home/ubuntu
    multipass exec $CLIENT -- sed -i "s/%IPS%/$SERVERS/g" /home/ubuntu/client.sh
    multipass exec $CLIENT -- sed -i "s/#capabilities/$2/g" /home/ubuntu/client.sh
    multipass exec $CLIENT -- sh /home/ubuntu/client.sh
}

CLIENTS_COUNT=${#CLIENTS[@]}
for (( i=1; i<${CLIENTS_COUNT}+1; i++ ));
do
    installClient $i ${CLIENTS[$i-1]}
done

# Jobs

multipass exec S1 -- nomad run "$(pwd)/jobs/fabio.nomad"
multipass exec S1 -- nomad run "$(pwd)/jobs/redis.nomad"