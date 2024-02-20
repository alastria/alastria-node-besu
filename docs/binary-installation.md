# ALASTRIA red B

[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://alastria.slack.com/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Introduction

Alastria red B Network is a public-permissioned Blockchain network that uses the [Hyperledger BESU](https://www.hyperledger.org/use/besu) technology, [IBFT 2.0](https://besu.hyperledger.org/en/stable/Tutorials/Private-Network/Create-IBFT-Network/) consensus algorithm, and it's managed by [Alastria](https://alastria.io/en/) partners, :vulcan_salute:.

There are 2 main steps to set up an Alatria Node:

**1. Installation & configuration:** Follow the Docker installation steps and your node will be ready.

**2. Getting permissioned:** In order to use Alastria Network, your node must be previously accepted. 


If you are a _rookie_ in Blockchain or Ethereum please consider reading these references:

- https://besu.hyperledger.org/en/stable/
- https://wiki.hyperledger.org/display/BESU/Hyperledger+Besu

If you would like you to know more about [Hyperledger](https://www.hyperledger.org/) Ecosystem, this [link](https://www.hyperledger.org/use/tutorials) is a good start.

## Administrative requirements

[Alastria](https://alastria.io/en/) partners can add its own node. Otherwise contact support@alastria.io to start with administrative permissioning.

There are 2 main steps to set up an Alatria Node:

**1. Installation:** Follow the installation process and your node will be ready to be permissioned.

**2. Getting permissioned:** In order to use Alastria Network, your node must be previously accepted, after filling the form. 

If a member wants to remove a node from the network, please send us a **removal request** using the same [electronic form](https://forms.gle/UCnATiaJ4LPdGjP97).


# 1) Installation

Before starting, consider the following guide to add a [dedicated disk](docs/mount-dedicated-disk.md) for the node database, independent of the system disk.

The following process explains the installation for a node:

### Install Java

For version 22.10.3 (currently in repo), the minimun version is Java 11
```
sudo apt install openjdk-11-jre-headless
```

For future versions, it is recommended Java 17

```
sudo apt install openjdk-17-jdk openjdk-17-jre
```

### Download Besu binaries

#### Script? 

First of all, we have to set BESU_VERSION env variable in order to download the correct version of binaries, currently version is 22.10.3

```
export VERSION_BESU=22.10.3
```

Then we have to create versionesBesu folder in order to have a Besu binaries historical registry. And navigate to it.
```
mkdir versionesBesu;
cd versionesBesu
```

And execute this command to download the specific binaries and unzip them.
```
wget https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/$VERSION_BESU/besu-$VERSION_BESU.tar.gz -O - | tar -xz
```
### Symbolic links

Now, we have to create symbolic links to bin and lib folders of the binaries folders recently downloaded in order to use them for correct performance.

```
ln -s /data/alastria-node-besu/versionesBesu/besu-22.10.3/bin bin
ln -s /data/alastria-node-besu/versionesBesu/besu-22.10.3/lib lib
```
### Create keys

We need to create the new private key and also the public key and node address. We have to exec these commands.

```
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export --to=./keys/key.pub
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export-address --to=./keys/nodeAddress
```

### Config files

First step, we have to create config folder.
```
mkdir config
```

Now we have to fetch config files from the official repo in order to be synchroniced with the currently configutation. To do so, we have to set environment variable NODE_BRANCH first.(currently "main")
```
export NODE_BRANCH=main
wget -q -O ./config/genesis.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/genesis.json
wget -q -O ./config/log-config.xml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/log-config.xml
```
Now we have log-config.xml and genesis.json files in our config folder.

We have to fetch config.toml file and other files that help the node connecting to the allowed destinations.
```
sh ./scripts/fetchConfig.sh
```

### Besu service

Using binaries, we can create a systemd service in order to handle it with systemctl.
We have to create besu.service (example name), in /etc/systemd/system/ (the path may change rely on the OS) with this content.
```
[Unit]
Description=Alastria Besu Service
After=network.target

[Service]
StartLimitBurst=5
StartLimitIntervalSec=200
WorkingDirectory=/data/alastria-node-besu/
Environment=LOG4J_CONFIGURATION_FILE=config/log-config.xml
EnvironmentFile=/etc/environment
Type=simple
User=alastria_user
ExecStart=/data/alastria-node-besu/bin/besu --config-file=config/config.toml
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```
# TODO

* Clone or download this repository:

```sh
git clone https://github.com/alastria/alastria-node-besu.git
```

* Edit the `.env` file in the **docker-compose** directory and modify the NODE_NAME attribute:

```sh
cd alastria-node-besu/docker-compose
```

> Set the NODE_NAME attribute according to the name you want for this node. The name SHOULD follow the convention: `REG_<COMPANY>_B_<Y>_<Z>_<NN>`

Where _\<COMPANY\>_ is your company/entity name, _\<Y\>_ is the number of processors of the machine, _\<Z\>_ is the amount of memory in Gb and _\<NN\>_ is a sequential counter for each machine that you may have (starting at 00). For example:

> `NODE_NAME="REG_ExampleOrg_B_2_8_00"`

This is the name that will be given to the docker container.

* Optionally, uncomment the RPC API and/or WebSocket ports of the container in the `docker-compose.yaml` if you need to use them.

* To start the node run:

```sh
docker-compose up -d
```

We are done. Now, we will have the followings available:

* Node's database at `/data/alastria-node-besu/database`
  
* Node's logging files at `/data/alastria-node-besu/logs`

* Node's keys files at `/data/alastria-node-besu/keys`

# 2) Permissioning new node

All nodes in  Alastria Networks must be permissioned. To ask for permission you must enter your data in this [electronic form](https://forms.gle/BiRqqgg2V7zbxF3c7), providing these information of your node: 

**1. ENODE:** String ENODE from ENODE_ADDRESS (enode://ENODE@IP:30303)

**2. Public IP:** The external IP of your node.

**3. System details:** Hosting provider, number of cores (vCPUs), RAM Memory and Hard disk size.


In order to get permissioning, follow these steps to get the information that you will be asked for in the previous form:

* You can find the ENODE_ADDRESS using `curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545`.

* Get the IP address of your node, as seen from the external world. 

```console
curl https://ifconfig.me/
```

* Once your request is fulfilled after form submission, you will see that your node starts connecting to its peers and starts synchronizing the blockchain. The process of synchronization can take hours or even one or two days depending on the speed of your network and machine.

# Adding automatic checking for updates in node lists

If your installation was done with docker-compose everything is set up in the container and there's nothing else to do :tada:

However, if your installation was done prior to June 2022, ensure you have the more up-to-date code running in your machine following these steps:

* Stop the node with `docker-compose down`
* Do a backup of the `docker-compose.yml` and the `.env` files to make sure you don't lose any configuration
* Pull the more current code from the repository with `git pull`
* Edit the `docker-compose.yml` and the `.env` files if you need a custom configuration in `volumes` and `ports` sections, and to set the type and the name of your node
* Start the container forcing the image to be build again with `docker-compose up --build -d`

# Infraestructure details

## System requirements

- Operating System: Ubuntu 16.04/18.04/20.04 LTS 64 bits. CentOS, Redhat,... and other _rpm_ systems are also allowed.

- Hosting: Euro Zone; in order to complain with GDPR directives.

- Hardware:

| Hardware       | Minimum | Desired |
| :------------- | :------ | :------ |
| **CPU's**:     | 2       | 4       |
| **Memory**:    | 4 Gb    | 8 Gb    |
|**Hard Disk (SSD)**: | 64 Gb   | 256 Gb  |

Blockchain database is about 16Gb at mid-2021 and grows at rate of 2Gb/month. Take this into consideration when provisioning space for cache, logs etc.
[SSD Disk is mandatory](https://besu.hyperledger.org/public-networks/get-started/system-requirements#disk-type)

## Firewall configuration

You need to open the following ports to deploy a node:

### Incoming rules

| Port  | Type | From              | Definition                                   |
| :---  | :--- | :--               | :---                                         |
| 30303 | TCP  | 0.0.0.0           | Ethereum client data transfer ports          |
| 30303 | UDP  | 0.0.0.0           | Ethereum client listener and discovery ports |
| 9545  | TCP  | ~~185.180.8.152~~ | ~~External Prometheus metrics~~  (*)         |

(*) At the moment, there is no central network monitoring server. While a new system is being provided, we propose adding metric endpoints to your own management infrastructure. 

Notes:

- Default Alastria configuration exposes BESU metrics in `tcp/9545` port and exposes `http://node_ip:9545/metrics` route in order to be integrated in your local monitoring infraestructure. More information in https://besu.hyperledger.org/public-networks/how-to/monitor/metrics and https://grafana.com/grafana/dashboards/16455-besu-full/. Please, **keep this access restricted to authorized hosts, as described in the documentation**.

### Optional ports:

| Port | Type | From            | Definition                                        |
| :--- | :--- | :---            | :------------------------------------------------ |
| 8080 | TCP  | (orion parners) | :warning: **DEPRECATED** Orion port (in case you use private transactions) |
| 8545 | TCP  | (web3 client)   | json+rpc (in case you use remix/truffle/.../web3) |
| 8546 | TCP  | (web3 client)   | json+ws (in case you use remix/truffle/.../web3)  |

Notes:

- :warning: Please, be very carefull opening web3 ports: this protocol does not have enabled (natively) neither authentication nor encryption!
- :warning: Opening web3 ports, can be tuned in `/data/alastria-node-besu/config/config.toml` file: listening interface, `web3` methods available,...
- Ninja sysadmins don't use outbound firewall rules :joy:



## Help! :fire_extinguisher:

### Slack

[Alastria](https://alastria.io/en/) has a group of channels available on `Slack` message platform, url: `alastria.slack.com`. You need to be invited, for it, please send a email to support@alastria.io asking to join the channel. Provide the following information:

- Name and organization.
- e-mail address to be added.
- Channel list where to be joined.

### Available channels by default

Once accepted in the Alastria Slack group you are automatically included in:

- `#general` General purpose channel (public)
- `#notificaciones` Notifications Github channel (public)

You can add yourself to the following channels:

- `#besu-group` Channel for the `red B` team, :beer:


## FAQ

- How how can I see the logs of the container?  

```sh
docker logs -f NODE_NAME
```

- How to know if the node is already permissioned?

```
2021-04-29 14:58:44.465+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 10145800 (0x82c9..ea34), Peers: 1
```

The last column should show, at least, one "Peer".

- How to know if the node has finished syncing?

Use `eth_syncing` [method](https://web3py.readthedocs.io/en/stable/web3.eth.html#web3.eth.Eth.syncing) to see the synchronization progress:

```sh
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://127.0.0.1:8545
```

- How can I manage the node?

```sh
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' http://127.0.0.1:8545
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545
```

Other `ADMIN` methods, in [Besu API method](https://besu.hyperledger.org/en/stable/public-networks/reference/api/)

Also, `IBFT` and `PERM` methods (for validator nodes), in [Private network API methods](https://besu.hyperledger.org/en/stable/private-networks/reference/api/)

- Will the functionality (docker | ansible | whatever) be supported soon?

It's in your hands! [Alastria](https://alastria.io/en/) is an open group and everyone is welcome to contribute. If you need any support we are here to help :hugs:

- Connection from Remix/Truffle/Hardhat

You can refer to the [smart-contract-deployment](https://github.com/alastria/smart-contract-deployment) repository.

## Links

- [Red B Blockscout Network Explorer](https://b-network.alastria.izer.tech/) - Hosted by [Izertis](https://www.izertis.com/) :raised_hands:
- Red B Network Monitor (login alastria/alastria) - Hosted by Planisys :raised_hands:
  - [Regular nodes](https://alastria-netstats.planisys.net:8443/d/htKGWMq7k/alastria-besu-regulars?orgId=1&refresh=5s) 
  - [Validator nodes](https://alastria-netstats.planisys.net:8443/d/6M-DlWq7z/alastria-besu-validators?orgId=1&refresh=5s)

### Operation documents of Alastria nodes

- Alastria Networks Operation and Government Policies [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/09/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF.pdf)

- Alastria Network Operational Conditions for Regular Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/09/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF.pdf)

- Alastria Network Operational Conditions for Critial Nodes (boot & validator) Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/CONDICIONES-OPERACIO-N-RED-T-POR-PARTE-DE-NODOS-CRI-TICOS-V1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/10/CONDICIONES-OPERACION-RED-T-POR-PARTE-DE-NODOS-CRITICOS-V1.1-DEF.pdf)
