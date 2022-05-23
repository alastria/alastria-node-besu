#!/bin/sh

github_md5sum_regular=$(wget https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json --quiet -O - | md5sum)
local_md5sum_regular=$(cat /data/alastria-node-besu/regular-nodes.json | md5sum)

github_md5sum_validator=$(wget https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json --quiet -O - | md5sum)
local_md5sum_validator=$(cat /data/alastria-node-besu/validator-nodes.json | md5sum)

case ${NODE_TYPE} in
    "validator")
        if [ "$github_md5sum_regular" != "$local_md5sum_regular" ] || [ "$github_md5sum_validator" != "$local_md5sum_validator" ]; then
            pkill -f java
        fi
    ;;
    "regular")
        if [ "$github_md5sum_validator" != "$local_md5sum_validator" ]; then
            pkill -f java
        fi
    ;;
    *)
        echo "ERROR: nodetype not recognized"
        exit 1
    ;;
esac
