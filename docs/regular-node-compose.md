# Regular Node Installation (with Docker Compose)

1. [Install Docker and Docker Compose](#install-docker-and-docker-compose)
2. [Clone Repo](#clone-repo)
3. [Configure Node](#configure-node)
4. [Launch Node](#launch-node)
5. [Stop Node](#stop-node)
6. [Request access to the network](#access)

## Install Docker and Docker Compose

- [Follow this guide](https://github.com/alastria/alastria-node-besu/blob/master/docs/docker-installation.md)

## Clone Repo

Clone repo and navigate to *alastria-node-besu/compose/regular-node*

```sh
git clone https://github.com/alastria/alastria-node-besu.git
cd alastria-node-besu/compose/regular-node
```

## Configure Node

### Option A: Setting up a New Node

#### New Besu Configuration

Generate your besu node key and place it under *alastria-node-besu/compose/regular-node/keys/besu*

```sh
docker container run -v `pwd`/keys/besu:/data -w /data -it --rm hyperledger/besu:1.4 --data-path=/data public-key export --to=/data/key.pub
```

### Option B: Updating an existing Node

#### Besu Configuration

Copy your existing node key to `keys/besu`

```sh
cp <besu-node-key> keys/besu
```

Create a docker volume named `regular-node_besu-database`

```sh
docker volume create regular-node_besu-database
```

Copy the contents of your existing node database to the newly created volume. For example

```sh
sudo cp -r ~/alastria-red-b/besu-node/data/database/* /var/lib/docker/volumes/regular-node_besu-database/_data
```

## Launch Node

To launch your node, run

```sh
./start.sh
```

**The ports 30303 and 8545 need to be open to the Internet in the Docker host.**

## Stop Node

To stop your node, run

```sh
./stop.sh
```

## <a name="access"></a>Request access to the network

For adding your new validator Node to the Alastria Red B network, please follow this steps:

1. [Get your **enode**](#enode)
2. [**Request the Registration of your node** in the network to Alastria Besu Core Team](#request_registration)

### <a name="enode"></a>1. Get your enode

```sh
curl -X POST --data '{"jsonrpc":"2.0","method":"net_enode","params":[],"id":1}' http://127.0.0.1:8545
```

> :warning: _Write down this value (it is your **enode**)_

### <a name="request_registration"></a>2. Request the registration of your Node

- Follow the [Guide in the Wiki](https://github.com/alastria/alastria-node-besu/wiki#0-permissioning), sending:
  - your **enode** (for registering your Node as a **Whitelisted Node** in the network)
  - **any Address** you want to send transactions from (for adding to the Accounts Whitelist)
