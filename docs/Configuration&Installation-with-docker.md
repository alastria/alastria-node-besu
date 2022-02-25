# Regular Node Installation (with Docker)

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

> `NODE_NAME="REG_ExampleOrg_T_2_8_00"`

This is the name that will be given to the docker container. For the moment it does not have any other usage.

* To start the node run:

```sh
$ docker-compose up -d
```

We are done. Now, we will have the followings available:

* Node's database at `/data/alastria-node-besu/database`
  
* Node's logging files at `/data/alastria-node-besu/database`
  
## Keeping control over the keys  
  
The keys of the node will be available inside the container, and are keept through restarts thanks to the `keys` docker volume. We can create the `/data/alastria-node-besu/keys` directory and copy there the **key**, **key.pub** and **nodeAddress** files from the container. Editting the `docker-compose.yaml` file to make this change:

> ~~\- keys:/data/alastria-node-besu/keys~~ &rarr; \- /data/alastria-node-besu/keys:/data/alastria-node-besu/keys

we can now remove the container and start a new one keeping the logs, the database and the keys accesible outside the container:

```sh
$ docker-compose down
$ docker-compose up -d
```
