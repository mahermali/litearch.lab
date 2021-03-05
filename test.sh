declare -a CLIENTS=("node,app" "node,app" "node,storge")

CLIENTS_COUNT=${#CLIENTS[@]}
for (( i=1; i<${CLIENTS_COUNT}+1; i++ ));
do
    installClient $i ${CLIENTS[$i-1]}
done