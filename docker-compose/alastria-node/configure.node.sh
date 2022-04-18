#!/bin/sh

mkdir config

wget -q -O ./config/genesis.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/genesis.json
wget -q -O ./config/log-config.xml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/log-config.xml
wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml

case ${NODE_TYPE} in
	"validator")
	
		bootnodes=$(wget -q -O - https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json)
		regularnodes=$(wget -q -O - https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json)
		echo "nodes-allowlist=$(echo "[$bootnodes, $regularnodes]" | jq '[.[0][], .[1][]]' )" > /data/alastria-node-besu/config/allowed-nodes.toml
	
		echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN","IBFT","PERM"]' >> ./config/config.toml
		echo '' >> ./config/config.toml
		echo 'permissions-nodes-config-file-enabled=true' >> ./config/config.toml
		echo 'permissions-nodes-config-file="/data/alastria-node-besu/config/allowed-nodes.toml"' >> ./config/config.toml
		echo '' >> ./config/config.toml
		echo "bootnodes=$bootnodes" >> ./config/config.toml
		
	;;
	"regular")
	
		wget -q -O ./config/static-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
		
		echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN"]' >> ./config/config.toml
		echo '' >> ./config/config.toml
		echo 'discovery-enabled=false' >> ./config/config.toml
		echo 'static-nodes-file="/data/alastria-node-besu/config/static-nodes.json"' >> ./config/config.toml
		
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac
