#!/bin/sh

set -e

cd /data/alastria-node-besu

# Create keys files
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export --to=./keys/key.pub
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export-address --to=./keys/nodeAddress

mkdir -p config

[[ ! -e ./config/genesis.json ]] && wget -q -O ./config/genesis.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/genesis.json
[[ ! -e ./config/log-config.xml ]] && wget -q -O ./config/log-config.xml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/log-config.xml

wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json

case ${NODE_TYPE} in
	"validator")
	
		network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
		echo "nodes-allowlist=$network_nodes" > ./config/allowed-nodes.toml
		echo $network_nodes > ./config/static-nodes.json
		
	;;
	"regular")
	
		echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./config/allowed-nodes.toml
		cp ./validator-nodes.json ./config/static-nodes.json
		
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac

if [[ ! -e ./config/config.toml ]]; then

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

fi



# Set the cron task to update peers every hour (if there are any changes)
echo "`date +"%M"` * * * * /usr/local/bin/checkForUpdates.sh" > /etc/crontabs/root
crond -l 2 -f > /dev/stdout 2> /dev/stderr &

# Start Besu
exec /data/alastria-node-besu/bin/besu --config-file=/data/alastria-node-besu/config/config.toml
