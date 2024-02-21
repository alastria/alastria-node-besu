#!/bin/sh

set -e

# Navigate to folder
cd /data/alastria-node-besu

# Set env variables in order to use them later
NODE_BRANCH=main
NODE_TYPE="regular"

# Fetch the checksum of both nodes, regulars and validator, check them in there's some change
github_md5sum_regular=$(wget https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json --quiet -O - | md5sum)
local_md5sum_regular=$(cat /data/alastria-node-besu/config/regular-nodes.json | md5sum)

github_md5sum_validator=$(wget https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json --quiet -O - | md5sum)
local_md5sum_validator=$(cat /data/alastria-node-besu/config/validator-nodes.json | md5sum)

# Rely on the node type, we take one path or the other, with differents tasks
case ${NODE_TYPE} in
    "validator")
        # Check if the local checksum is the same as the github's one, if not, must be replaced for the newest
        if [ "$github_md5sum_regular" != "$local_md5sum_regular" ] || [ "$github_md5sum_validator" != "$local_md5sum_validator" ]; then
            # Fetch github's json's nodes files
            wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
            wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json
            # Update allowed-nodes and static-nodes files
            network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
            echo "nodes-allowlist=$network_nodes" > ./config/allowed-nodes.toml
            echo $network_nodes > ./config/static-nodes.json
            # Copy new validator and regular nodes json to config folder
            cp ./validator-nodes.json ./config/validator-nodes.json
            cp ./regular-nodes.json ./config/regular-nodes.json
            #### OPTIONAL Restart besu service with the updated config
            #sudo systemctl restart besu.service
            # Delete temp files
            rm ./validator-nodes.json
            rm ./regular-nodes.json
        fi
    ;;
    "regular")
        # Check if the local checksum is the same as the github's one, if not, must be replaced for the newest
        if [ "$github_md5sum_validator" != "$local_md5sum_validator" ]; then
            # Fetch github's json's nodes files            
            wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
            # Update allowed-nodes and static-nodes files
            echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./config/allowed-nodes.toml
            cp ./validator-nodes.json ./config/static-nodes.json
            # Copy new validator nodes json to config folder
            cp ./validator-nodes.json ./config/validator-nodes.json
            #### OPTIONAL Restart besu service with the updated config
            sudo systemctl restart besu.service
            # Delete temp files
            rm ./validator-nodes.json
        fi
    ;;
    *)
        # Wrong node type
        echo "ERROR: nodetype not recognized"
        exit 1
    ;;
esac