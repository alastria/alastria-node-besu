#!/bin/sh

set -e

# Navigate to folder
cd /data/alastria-node-besu

# Set env variables in order to use them later
NODE_BRANCH=main
NODE_TYPE=regular

# Fetch github's json's nodes files
wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json

# Rely on the node type, we take one path or the other, with differents tasks
case ${NODE_TYPE} in
	"validator")
        # Update allowed-nodes and static-nodes files
		network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
		echo "nodes-allowlist=$network_nodes" > ./config/allowed-nodes.toml
		echo $network_nodes > ./config/static-nodes.json
        # Copy new validator and regular nodes json to config folder
        cp ./validator-nodes.json ./config/validator-nodes.json
        cp ./regular-nodes.json ./config/regular-nodes.json
	;;
	"regular")
        # Update allowed-nodes and static-nodes files
		echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./config/allowed-nodes.toml
		cp ./validator-nodes.json ./config/static-nodes.json
        # Copy new validator and regular nodes json to config folder
        cp ./validator-nodes.json ./config/validator-nodes.json
        cp ./regular-nodes.json ./config/regular-nodes.json
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac


# Fetch github's config.toml
wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml

# Rely on the node type, we take one path or the other, with differents tasks
case ${NODE_TYPE} in
    "validator")
        # Set specific configuration for validator node
        echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN","IBFT","PERM"]' >> ./config/config.toml
        echo '' >> ./config/config.toml
        echo 'auto-log-bloom-caching-enabled=false' >> ./config/config.toml
        echo 'max-peers=256' >> ./config/config.toml
        
    ;;
    "regular")
        # Set specific configuration for regular node
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
