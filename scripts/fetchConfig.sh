#!/bin/sh

set -e

cd /data/alastria-node-besu

NODE_BRANCH=main
NODE_TYPE=regular

wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json

case ${NODE_TYPE} in
	"validator")
	
		network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
		echo "nodes-allowlist=$network_nodes" > ./config/allowed-nodes.toml
		echo $network_nodes > ./config/static-nodes.json
		rm regular-nodes.json
        rm validator-nodes.json
	;;
	"regular")
	
		echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./config/allowed-nodes.toml
		cp ./validator-nodes.json ./config/static-nodes.json
		rm regular-nodes.json
        rm validator-nodes.json
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac



wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml

case ${NODE_TYPE} in
    "validator")
    
        echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN","IBFT","PERM"]' >> ./config/config.toml
        echo '' >> ./config/config.toml
        echo 'auto-log-bloom-caching-enabled=false' >> ./config/config.toml
        echo 'max-peers=256' >> ./config/config.toml
        
    ;;
    "regular")
    
        echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN"]' >> ./config/config.toml
        echo '' >> ./config/config.toml
        echo 'rpc-ws-enabled=true' >> ./config/config.toml
        echo 'rpc-ws-host="0.0.0.0"' >> ./config/config.toml
        echo 'rpc-ws-api=["ETH","NET","WEB3","ADMIN"]' >> ./config/config.toml
        
    ;;
    *)
        echo "ERROR: nodetype not recognized"
        exit 1
    ;;
esac
