# ALASTRIA red B

[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://alastria.slack.com/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/alastria/alastria-node/blob/testnet2/LICENSE)

## Introduction

Alastria red B Network is a public-permissioned Blockchain network that uses the [Hyperledger BESU](https://www.hyperledger.org/use/besu) technology, [IBFT 2.0](https://besu.hyperledger.org/en/stable/Tutorials/Private-Network/Create-IBFT-Network/) consensus algorithm, and it's managed by [Alastria](https://alastria.io/en/) partners, :vulcan_salute:.

If you are a _rookie_ in Blockchain or Ethereum please consider reading these references:
* https://besu.hyperledger.org/en/stable/
* https://wiki.hyperledger.org/display/BESU/Hyperledger+Besu

If you would like you to know more about [Hyperledger](https://www.hyperledger.org/) Ecosystem, this [link](https://www.hyperledger.org/use/tutorials) is a good start.

## Administrative requirements

[Alastria](https://alastria.io/en/) partners can add its own node. Otherwise contact support@alastria.io to start with administrative permissioning.

Nodes in the network must be permissioned. Do the installation process and then fill out this [electronic form](https://portal.r2docuo.com/alastria/forms/noderequest). Other guides related with operation of Alastria Node are available in following documents:

* Alastria Networks Operation and Government Policies [(en_GB)](https://alastria.io/wp-content/uploads/2020/04/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/04/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF.pdf)

* Alastria Network Operational Conditions for Regular Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF.pdf)

* Alastria Network Operational Conditions for Critial Nodes (boot && validator) Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-OPERACIO-N-RED-T-POR-PARTE-DE-NODOS-CRI-TICOS-V1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2020/06/CONDICIONES-OPERACIO%CC%81N-RED-T-POR-PARTE-DE-NODOS-CRI%CC%81TICOS-V1.1-DEF.pdf)

If a member wants to remove a node from the network, please send us a **removal request** using the same [electronic form](https://portal.r2docuo.com/alastria/forms/noderequest).

## System requirements

* Operating System: Ubuntu 16.04/18.04/20.04 LTS 64 bits. CentOS, Redhat,... and other _rpm_ systems are also allowed.

* Hosting: Euro Zone; in order to complain with GDPR directives.

* Hardware:

| Hardware       | Minimum | Desired |
| :---           | :---    | :---    |
| **CPU's**:     | 2       | 4       |
| **Memory**:    | 4 Gb    | 8 Gb    |
| **Hard Disk**: | 32 Gb   | 256 Gb  |

Blockchain database is about 16Gb at mid-2021 and grows at rate of 2Gb/month. Take this into consideration when provisioning space for cache, logs etc.

## Firewall configuration

You need to open the following ports to deploy a node:

### Incoming rules

| Port  | Type |      From     | Definition                                   |
| :---  | :--  | :---          | :---                                         |
| 30303 | TCP  |    0.0.0.0    | Ethereum client data transfer ports          |
| 30303 | UDP  |    0.0.0.0    | Ethereum client listener and discovery ports |
| 9545  | TCP  | 185.180.8.152 | External Prometheus metrics                  |

Notes:
* Logging from `185.180.8.152` is needed in order to pull metrics from `red B` [Network Monitor](https://alastria-netstats2.planisys.net:8443/?orgId=1) (Thanks [Planisys](https://www.planisys.net/) :raised_hands:)

### Optional ports:

| Port  | Type |     From        | Definition                                        |
| :---  | :--  | :---            | :---                                              |
| 8080  | TCP  | (orion parners) | Orion port (in case you use private transactions) |
| 8545  | TCP  |  (web3 client)  | json+rpc (in case you use remix/truffle/.../web3) |
| 8546  | TCP  |  (web3 client)  | json+ws (in case you use remix/truffle/.../web3)  |

Notes:
* :warning: Please, be very carefull opening web3 ports: this protocol does not have enabled (natively) neither authentication nor encryption!
* :warning: Opening web3 ports, can be tuned in `/data/alastria-node-besu/regular/config/besu/config.toml` file: listening interface, `web3` methods available,...
* Ninja sysadmins don't use outbound firewall rules :joy:
## Installation

The following guide is ready for installation on a dedicated machine (bare metal, virtual machine,...), with data files stored on `/data` partition. 
**Please**, consider the following guide to add a [dedicated disk](docs/mount-dedicated-disk.md) for the node database, independent of the system disk.

### Installation Type

* Users who want deploy applications should use [Regular node Installation Guide](docs/Regular-Configuration&Installation.md)
* Users who want to improve the availability of the network should add [Validator](docs/Validator-Configuration&Installation.md) or [Regular](docs/Validator-Configuration&Installation.md) node. Keep in mind the dedicated use of these nodes and the special security considerations for these core nodes.

## Help! :fire_extinguisher:
### Slack

[Alastria](https://alastria.io/en/) has a group of channels available on `Slack` message platform, url: `alastria.slack.com`. You need to be invited, for it, please send a email to support@alastria.io asking to join the channel. Provide the following information:

* Name and organization.
* e-mail address to be added.
* Channel list where to be joined.

### Available channels by default
Once accepted in the Alastria Slack group you are automatically included in:

* `#general` General purpose channel (public)
* `#notificaciones` Notifications Github channel (public)

You can add yourself to the following channels:

* `#besu-group` Channel for the `red B` team, :beer:

### Open an issue

If you need to open an issue on the [alastria-node-besu](https://github.com/alastria/alastria-node-besu) repository, please follow the instructions [here](https://help.github.com/articles/creating-an-issue/).

### Create a pull request

If you want to do a Pull Request on the [alastria-node-besu](https://github.com/alastria/alastria-node-besu) repository, please follow [these](https://services.github.com/on-demand/github-cli/open-pull-request-github) instructions.


## FAQ

* How to launch an interactive console for debugging purposes?

```sh
$ sudo /data/alastria-node-besu/regular/bin/besu --config-file="/data/alastria-node-besu/regular/config/besu/config.toml"
```

* How to know if the node is already permissioned?

```
2021-04-29 14:58:44.465+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 10145800 (0x82c9..ea34), Peers: 1
```

The last column should show, at least, one "Peer".

* How to know if the node has finished syncing?

Use `eth_syncing` [method](https://web3py.readthedocs.io/en/stable/web3.eth.html#web3.eth.Eth.syncing) to see the synchronization progress:

```sh
$ curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://127.0.0.1:8545
```

* How can I manage the node?

Enable this object at the node: add "ADMIN" to the list of supported methods:

```sh
$ sudo vim /data/alastria-node-besu/regular/config/besu/config.toml

[...]
rpc-http-api=["ADMIN", "ETH","NET","WEB3"]
[...]
```

```sh
$ curl -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' http://127.0.0.1:8545
$ curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545
```

Other `ADMIN` methods, in https://besu.hyperledger.org/en/stable/Reference/API-Methods/

* Will the functionality (docker | ansible | whatever) be supported soon? 

It's in your hands! [Alastria](https://alastria.io/en/) is an open group and everyone is welcome to contribute. If you need any support we are here to help :hugs:

* Connection from Remix
(TBD)

* Connection from Truffle
(TBD)

## Links

- [Red B Network Monitor](https://alastria-netstats2.planisys.net:8443/?orgId=1)
- [Red B Block Explorer - Hosted by Eurogestión](http://5.153.57.78)
- [Red B Permissioning DApp - Hosted by Eurogestión](http://5.153.57.78:3000/)

## Other Guides

Internal documentation for `red B` core admins:

* [Red B Initial Schema](docs/AlastriaRedB.png)
* [Alethio Lite Explorer Installation Guide](docs/blockexplorer-installation.md)
* [Permissioning DApp](docs/permissioning-dapp.md)
* [Genesys file Description](docs/about-genesis-file.md)
