# ALASTRIA red B

[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://alastria.slack.com/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Introduction

Alastria red B Network is a public-permissioned Blockchain network that uses the [Hyperledger BESU](https://www.hyperledger.org/use/besu) technology, [IBFT 2.0](https://besu.hyperledger.org/en/stable/Tutorials/Private-Network/Create-IBFT-Network/) consensus algorithm, and it's managed by [Alastria](https://alastria.io/en/) partners, :vulcan_salute:.

There are 2 main steps to set up an Alatria Node:

**1. Installation & configuration:** Follow the binary installation steps and your node will be ready.

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

The following steps have been referenced both from the installation itself via Docker and the old documentation of the [repository](https://alastria-node-besu.readthedocs.io/en/latest/Regular-Configuration%26Installation/#besu-configuration), as well as old [tutorials](https://github.com/alastria/alastria-node-besu/commit/7073d5e5c937843608934798a72a36525721253f) found in previous commits.

The following process explains the installation for a node:

* #### Clone repository

Clone this repo for begin the proccess.

```sh
cd /data
git clone https://github.com/bc-practice/alastria-node-besu.git
```

* #### Install Java

For version 22.10.3 (currently in repo), the minimun version is Java 11

```
sudo apt install openjdk-11-jre-headless
```

For future versions, it is recommended Java 17

```
sudo apt install openjdk-17-jdk openjdk-17-jre
```

* #### Download Besu binaries 

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

* #### Symbolic links

Now, we have to create symbolic links to bin and lib folders of the binaries folders recently downloaded in order to use them for correct performance.

```
ln -s /data/alastria-node-besu/versionesBesu/besu-22.10.3/bin bin
ln -s /data/alastria-node-besu/versionesBesu/besu-22.10.3/lib lib
```

* #### Create keys

We need to create the new private key and also the public key and node address. We have to exec these commands.

```
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export --to=./keys/key.pub
/data/alastria-node-besu/bin/besu --data-path=./keys public-key export-address --to=./keys/nodeAddress
```

* #### Config files

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

We have to fetch config.toml file and other files that help the node connecting to the allowed destinations depending on the kind of node that we are going to use.

* ##### No Script (Regular)

First of all, we have to set NODE_TYPE env variable. (In this case, "regular")

```
NODE_TYPE=regular
```

Fetch te github's validator-nodes file.

```
wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
```

Update allowed-nodes and static-nodes files

```
echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./config/allowed-nodes.toml
cp ./validator-nodes.json ./config/static-nodes.json
```

Copy new validator to config folder

```
cp ./validator-nodes.json ./config/validator-nodes.json
```

And now, we must get the config.toml file from Alastria's github

```
wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml
```

And set specific configutation for Regular node

```
echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN"]' >> ./config/config.toml
echo '' >> ./config/config.toml
echo 'rpc-ws-enabled=true' >> ./config/config.toml
echo 'rpc-ws-host="0.0.0.0"' >> ./config/config.toml
echo 'rpc-ws-api=["ETH","NET","WEB3","ADMIN"]' >> ./config/config.toml
```

* ##### No Script (Validator)

First of all, we have to set NODE_TYPE env variable. (In this case, "validator")

```
NODE_TYPE=validator
```

Fetch te github's validator-nodes file. In this case, we have to get both files.

```
wget -q -O ./validator-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/validator-nodes.json
wget -q -O ./regular-nodes.json https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/data/regular-nodes.json
```

Update allowed-nodes and static-nodes files. (We must have jq installed)

```
network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
echo "nodes-allowlist=$network_nodes" > ./config/allowed-nodes.toml
echo $network_nodes > ./config/static-nodes.json
```

Copy new validator and regular nodes json to config folder

```
cp ./validator-nodes.json ./config/validator-nodes.json
cp ./regular-nodes.json ./config/regular-nodes.json
```

Now, we must get the config.toml file from Alastria's github

```
wget -q -O ./config/config.toml https://raw.githubusercontent.com/alastria/alastria-node-besu-directory/${NODE_BRANCH}/config/global-config.toml
```

And set specific configuration for validator node.

```
echo 'rpc-http-api=["ETH","NET","WEB3","ADMIN","IBFT","PERM"]' >> ./config/config.toml
echo '' >> ./config/config.toml
echo 'auto-log-bloom-caching-enabled=false' >> ./config/config.toml
echo 'max-peers=256' >> ./config/config.toml
```

* ##### Script

```
sh ./scripts/fetchConfig.sh
```

* #### Besu service

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
Type=simple
User=<YOUR_USER>
ExecStart=/data/alastria-node-besu/bin/besu --config-file=config/config.toml
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

After that, we have to reload the daemon in order to check that there's a new service that have to be started at boot, with these commands:

```
sudo systemctl daemon-reload
sudo systemctl enable besu.service
```

Now we can start the service

```
sudo systemctl start besu.service
```
And check if it was correctly started.

```
sudo systemctl status besu.service
```

The status result might be something like this:

```
● besu.service - Alastria Besu Service
     Loaded: loaded (/lib/systemd/system/besu.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-02-21 08:17:36 UTC; 1h 19min ago
   Main PID: 29536 (java)
      Tasks: 73 (limit: 9389)
     Memory: 369.5M
        CPU: 1min 2.590s
     CGroup: /system.slice/besu.service
             └─29536 java -Dvertx.disableFileCPResolving=true -Dbesu.home=/data/alastria-node-besu -Dlog4j.shutdownHookEnabled=false -Dlog4j2.formatMsgNoLookups=true -Djava.util.logging.manager=org.apache.loggin>

Feb 21 09:35:55 a266vmsl besu[29536]: 2024-02-21 09:35:55.525+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:00 a266vmsl besu[29536]: 2024-02-21 09:36:00.526+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:05 a266vmsl besu[29536]: 2024-02-21 09:36:05.527+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:10 a266vmsl besu[29536]: 2024-02-21 09:36:10.528+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:15 a266vmsl besu[29536]: 2024-02-21 09:36:15.529+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:20 a266vmsl besu[29536]: 2024-02-21 09:36:20.529+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:25 a266vmsl besu[29536]: 2024-02-21 09:36:25.530+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0
Feb 21 09:36:30 a266vmsl besu[29536]: 2024-02-21 09:36:30.531+00:00 | EthScheduler-Timer-0 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0

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

##### Example

For example, at 26th of February, a regular node spent aprox. 27 hours to complete synchronization.The node's logs will transition from this state:

```
2024-02-23 10:02:19.417+00:00 | main | INFO  | FullSyncDownloader | Starting full sync. 
2024-02-23 10:02:19.418+00:00 | main | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 0 
2024-02-23 10:02:19.540+00:00 | main | INFO  | Runner | Ethereum main loop is up. 
2024-02-23 10:02:19.888+00:00 | nioEventLoopGroup-3-6 | INFO  | FullSyncTargetManager | No sync target, waiting for peers. Current peers: 5 
2024-02-23 10:02:28.401+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 200 (0x608d112b722399ec43e9189b379d18398f2520d8c555160c44577cb0ab3734b8), - Mg/s, Peers: 5 
2024-02-23 10:02:28.824+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 400 (0x19e1629ff059b7f65e6489fc15ab4178a68867f2468fcaa4c4619a51479883dc), - Mg/s, Peers: 5 
2024-02-23 10:02:29.389+00:00 | EthScheduler-Services-5 (importBlock) | INFO  | FullImportBlockStep | Import reached block 600 (0xf1864687e4d4324fb0a3052a61b6b3e0129d346b3038a294a1d0c3bae5a9f3ce), - Mg/s, Peers: 5 
```

Here's shown that the node started to connect to others peers, and started importing blocks.
When sync ends, the node's logs will change to this state:

```
2024-02-24 12:59:20.545+00:00 | EthScheduler-Services-0 (importBlock) | INFO  | FullImportBlockStep | Import reached block 42166800 (0xb1704cadef9438e68a8850fcd90d1d935a8cd28759afd55a37ccdbff5eb96741), 6.665 Mg/s, Peers: 5 
2024-02-24 12:59:21.219+00:00 | EthScheduler-Services-0 (importBlock) | INFO  | FullImportBlockStep | Import reached block 42167000 (0x06864599b86529b2ccacad00714cbe05c016083ae97b4d294052c1fcdcac9f95), 11.009 Mg/s, Peers: 5 
2024-02-24 12:59:23.129+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported #42,167,142 / 1 tx / 0 om / 98,935 (0.9%) gas / (0x957fed46ca8c59acae3d90e14e20896748ddca987585576c1435da28def153ce) in 0.011s. Peers: 5 
2024-02-24 12:59:26.128+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported #42,167,143 / 2 tx / 0 om / 197,870 (1.9%) gas / (0xf55ad31703df60adf0331604bd9b269440c4e4eb724fe520ff7fc00d40c59455) in 0.021s. Peers: 5 
2024-02-24 12:59:29.097+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported #42,167,144 / 1 tx / 0 om / 98,935 (0.9%) gas / (0xe2df5fd251949de09f416f0c3cbef1988d81275b93ba75b37e1119cfe28df284) in 0.011s. Peers: 5 
```
In this state, the node starts to import blocks that are been currently produced, and shows other information about the block like txs, hashes and peers connected.

# Adding automatic checking for updates in node lists

If your installation was done with docker-compose everything is set up in the container and there's nothing else to do :tada:


With binaries, once the Besu node is running, we have to check periodically if there're some nodes that have been replaced, in order to do so, we can execute the updateStaticNodes script. We can execute the command manually or, on the other hand, we can set a task in crontab to be executed every hour (or another time frame).

To do manually, first we have to set env variables NODE_BRANCH and NODE_TYPE:

```
export NODE_TYPE=regular
export NODE_BRANCH=main
cd scripts
sh updateStaticNodes.sh
```

Through crontab, we have to set the task. Before that we have to set env variables NODE_BRANCH and NODE_TYPE into the script.

```
sed -i '7s/.*/NODE_TYPE=regular\n&/; 8s/.*/NODE_BRANCH=main\n&/' /data/alastria-node-besu/scripts/updateStaticNodes.sh
sudo vi /etc/crontab
# Add the task
0 * * * * <user_name> /data/alastria-node-besu/scripts/updateStaticNodes.sh
```

The script will check if there's any difference between local and remote checksums, if so, the target nodes will be replaced.

# Implementation of API Key in Nginx

An API Key is a special token used to enforce some type of authentication while making requests to a remote service. Using that, the Besu node will be more secure for unauthorized accesses or requests.

The implementation through a reverse proxy using Nginx adds an isolation layer to our node from direct users, reducing the node's exposure to potential attacks.

## Steps to deploy

> @dev: This is a derivative version of the offical Alastria repo of the [reverse proxy](https://github.com/alastria/reverse-proxy-nginx), in this steps it is explained how configure Nginx in order to use API key in query format (instead of headers), so it can be used in digital wallets, like Metamask for example

**1.** First of all, the Besu node must be correctly deployed.

**2.** Install Nginx

```
sudo apt update
sudo apt install nginx
```

**3.** Now we have to locate our nginx.conf file (it can be placed in ```/usr/local/nginx/conf```, ```/usr/local/etc/nginx``` or ```/etc/nginx``` ), and modify it or replace with one with this contain.

```
user             <YOUR_USER>;
worker_processes 1;
pid              /var/run/nginx.pid;
error_log        /var/log/nginx/error.log;

events {
  worker_connections  1024;
}

http {
  sendfile                  on;
  tcp_nopush                on;
  gzip                      on;
  ssl_prefer_server_ciphers on;
  keepalive_timeout         65;
  types_hash_max_size       2048;
  default_type              application/octet-stream;
  ssl_protocols             TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;

  access_log /var/log/nginx/access.log;
  include                   /etc/nginx/mime.types;

  server {
    listen               80      default_server; # IPv4 Listener
    listen               [::]:80 default_server; # IPv6 Listener
    server_name          _;                      # Server's name (domain name). By default `_`, which is any.
    client_max_body_size 1M;                     # Default max body size of 1 Megabyte. If more is needed, increase this number, to eg: 300M


    set $api_key_value <YOUR_API_KEY_VALUE>;

    location / {
      if ($request_method = 'OPTIONS') {
        add_header Access-Control-Allow-Headers "apikey, Authorization";
      }

      if ($arg_apikey = "") {
        return 403; # Forbidden
      }

      if ($arg_apikey != $api_key_value) {
      return 401; # Unauthorized
      }
      # Change example.com with your node's IP and Port that you would normally use to connect to
      proxy_pass  <YOUR_NODE_IP:NODE_PORT>;
  }
}
}
```

Notes:

* By default, Nginx is running at port 80, we can modify this value as we needed. For example, we can configure the Nginx listener port using the RPC port of our Besu node, previously [set up in the deployment](#optional-ports).
By default, 8545 is the configured port for our Besu RPC , we can use a different port for the Besu RPC, and configure a redirection in Nginx from the default 8545 port, to a our customized port, minimizing the number of externally open ports and increasing the security of our node.

* This configuration is set in order to accept query parameters.

   * If there is no apikey parameter in the request, the response is 403, Forbidden

   * If there is an apikey parameter but does not match with the one in the config, the response is 401, unauthorized

   * If there is an apikey parameter and the value match with the configuration's value, the request passes to the rpc port.

**4.** Restart Nginx service in order to take the changes effect.

```
sudo systemctl restart nginx.service
```

**5.** Test with a request. (for example)

```
curl -v -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' "http://<YOUR_NGINX_IP:YOUR_NGINX_PORT>?apikey=<YOUR_APIKEY_VALUE>"
```

**6.** (Optional) Test in Metamask.

  * In Settings -> Networks -> Add Network -> Add network manually, in RPC section we must fill it with the entire url of our Nginx:

  ```
  http://<YOUR_NGINX_IP:YOUR_NGINX_PORT>?apikey=<YOUR_APIKEY_VALUE>
  ```

More info about Nginx :point_right: [Nginx docs](https://nginx.org/en/docs/)

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
| 9545  | TCP  | 18.201.52.140     | Scraping Prometheus metrics from Alastria    |

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

- How how can I see the logs of the Besu service?  

```sh
sudo systemctl status besu.service
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

- [Red B Network Monitor](https://net-monitor.alastria.io/) (login alastria/alastria) - Hosted by [Alastria](https://alastria.io/) :raised_hands:

### Operation documents of Alastria nodes

- Alastria Networks Operation and Government Policies [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/09/POLI-TICAS-GOBIERNO-Y-OPERACIO-N-RED-ALASTRIA-V1.01-DEF.pdf)

- Alastria Network Operational Conditions for Regular Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/09/CONDICIONES-USO-RED-NODOS-REGULARES-A-LA-RED-ALASTRIA-v1.1-DEF.pdf)

- Alastria Network Operational Conditions for Critial Nodes (boot & validator) Nodes [(en_GB)](https://alastria.io/wp-content/uploads/2022/12/CONDICIONES-OPERACIO-N-RED-T-POR-PARTE-DE-NODOS-CRI-TICOS-V1.1-DEF-en-GB.pdf), [(es_ES)](https://alastria.io/wp-content/uploads/2022/10/CONDICIONES-OPERACION-RED-T-POR-PARTE-DE-NODOS-CRITICOS-V1.1-DEF.pdf)
