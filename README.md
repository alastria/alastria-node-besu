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

* Clone or download this repository into `/data` directory:

```sh
$ sudo mount /data
$ cd /data
$ sudo git clone https://github.com/alastria/alastria-node-besu.git
```

* Edit the `.env` file in the **docker-compose** directory and modify the NODE_NAME attribute:

> Set the NODE_NAME attribute according to the name you want for this node. The name SHOULD follow the convention: `REG_<COMPANY>_B_<Y>_<Z>_<NN>`

Where _\<COMPANY\>_ is your company/entity name, _\<Y\>_ is the number of processors of the machine, _\<Z\>_ is the amount of memory in Gb and _\<NN\>_ is a sequential counter for each machine that you may have (starting at 00). For example:

> `NODE_NAME="REG_ExampleOrg_B_2_8_00"`

This is the name that will be given to the docker container.



* To start the node run:

```sh
$ docker-compose up -d
```

We are done. Now, we will have the followings available:

* Node's database at `/data/alastria-node-besu/database`
  
* Node's logging files at `/data/alastria-node-besu/logs`
  
## Keeping control over the keys  
  
The keys of the node will be available inside the container, and are keept through restarts thanks to the `keys` docker volume. We can create the `/data/alastria-node-besu/keys` directory and copy there the **key**, **key.pub** and **nodeAddress** files from the container. Editting the `docker-compose.yaml` file to make this change:

> ~~\- keys:/data/alastria-node-besu/keys~~ &rarr; \- /data/alastria-node-besu/keys:/data/alastria-node-besu/keys

we can now remove the container and start a new one keeping the logs, the database and the keys accesible outside the container:

```sh
$ docker-compose down
$ docker-compose up -d
```

# 2) Permissioning new node

Please, fill this [electronic form](https://forms.gle/mcJNnTE81Z3P1g8K6) and provide the following information in order to get the permission for joining the network:

* The exact Node Name.
* The public IP for your node. Get your public IP, for example, with `curl ifconfig.me`. Remember that the hosting should be in _Eurozone_.
* The hosting provider for your node, in case you use one. Otherwise, use `SelfHosting`.
* The system configuration: number of cores, memory and harddisk reserved for the node.
* Enode direction. You can find it in `/data/alastria-node-besu/keys/nodeAddress` file, or using `curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545`.

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
| **Hard Disk**: | 32 Gb   | 256 Gb  |

Blockchain database is about 16Gb at mid-2021 and grows at rate of 2Gb/month. Take this into consideration when provisioning space for cache, logs etc.

## Firewall configuration

You need to open the following ports to deploy a node:

### Incoming rules

| Port  | Type | From          | Definition                                   |
| :---- | :--- | :------------ | :------------------------------------------- |
| 30303 | TCP  | 0.0.0.0       | Ethereum client data transfer ports          |
| 30303 | UDP  | 0.0.0.0       | Ethereum client listener and discovery ports |
| 9545  | TCP  | 185.180.8.152 | External Prometheus metrics                  |

Notes:

- Logging from `185.180.8.152` is needed in order to pull metrics from `red B` [Network Monitor](https://alastria-netstats2.planisys.net:8443/?orgId=1) (Thanks [Planisys](https://www.planisys.net/) :raised_hands:)

### Optional ports:

| Port | Type | From            | Definition                                        |
| :--- | :--- | :-------------- | :------------------------------------------------ |
| 8080 | TCP  | (orion parners) | Orion port (in case you use private transactions) |
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

- How to launch an interactive console for debugging purposes?

```sh
$ sudo /data/alastria-node-besu/bin/besu --config-file="/data/alastria-node-besu/config/config.toml"
```

- How to know if the node is already permissioned?

```
2021-04-29 14:58:44.465+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 10145800 (0x82c9..ea34), Peers: 1
```

The last column should show, at least, one "Peer".

- How to know if the node has finished syncing?

Use `eth_syncing` [method](https://web3py.readthedocs.io/en/stable/web3.eth.html#web3.eth.Eth.syncing) to see the synchronization progress:

```sh
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://127.0.0.1:8545
```

- How can I manage the node?

Enable this object at the node: add "ADMIN" to the list of supported methods:

```sh
$ sudo vim /data/alastria-node-besu/config/config.toml

[...]
rpc-http-api=["ADMIN", "ETH","NET","WEB3"]
[...]
```

```sh
$ curl -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' http://127.0.0.1:8545
$ curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545
```

Other `ADMIN` methods, in https://besu.hyperledger.org/en/stable/Reference/API-Methods/

- Will the functionality (docker | ansible | whatever) be supported soon?

It's in your hands! [Alastria](https://alastria.io/en/) is an open group and everyone is welcome to contribute. If you need any support we are here to help :hugs:

- Connection from Remix
  (TBD)

- Connection from Truffle
  (TBD)

## Links

- [Red B Epirus Network Explorer](https://redb.trustos.telefonica.com/) - Hosted by Telefónica
- [Red B Network Monitor](https://alastria-netstats2.planisys.net:8443/?orgId=1) - Hosted by Planisys



### Operation documents of Alastria nodes

- Alastria Networks Operation and Government Policies [(en_GB)](https://alastria.io/wp-content/uploads/2020/04/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/04/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF.pdf)

- Alastria Network Operational Conditions for Regular Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF.pdf)

- Alastria Network Operational Conditions for Critial Nodes (boot && validator) Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-OPERACIO-N-RED-T-POR-PARTE-DE-NODOS-CRI-TICOS-V1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-OPERACIO%CC%81N-RED-T-POR-PARTE-DE-NODOS-CRI%CC%81TICOS-V1.1-DEF.pdf)
