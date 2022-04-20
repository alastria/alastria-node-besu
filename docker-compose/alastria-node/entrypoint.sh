#!/bin/sh

set -e

mkdir -p /data/alastria-node-besu/config
cd /data/alastria-node-besu

[[ ! -e ./config/genesis.json ]] && wget -q -O ./config/genesis.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/genesis.json
[[ ! -e ./config/log-config.xml ]] && wget -q -O ./config/log-config.xml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/log-config.xml

wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json

if [[ ! -e ./config/config.toml ]]; then

	wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml

	case ${NODE_TYPE} in
		"validator")
		
			echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN","IBFT","PERM"]' >> ./config/config.toml
			echo '' >> ./config/config.toml
			echo 'permissions-nodes-config-file-enabled=true' >> ./config/config.toml
			echo 'permissions-nodes-config-file="/data/alastria-node-besu/config/allowed-nodes.toml"' >> ./config/config.toml
			echo '' >> ./config/config.toml
			printf 'bootnodes=%s' "$(cat ./validator-nodes.json)" >> ./config/config.toml
			
		;;
		"regular")
		
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

fi

case ${NODE_TYPE} in
	"validator")
	
		[[ ! -e ./config/allowed-nodes.toml ]] && echo "nodes-allowlist=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' )" > ./config/allowed-nodes.toml
		
	;;
	"regular")
	
		[[ ! -e ./config/static-nodes.json ]] && cp ./validator-nodes.json ./config/static-nodes.json
		
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac

# Start Besu
exec /data/alastria-node-besu/bin/besu --config-file=/data/alastria-node-besu/config/config.toml
