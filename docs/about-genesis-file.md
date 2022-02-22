# About Genesis file

## Genesis file Base

The [genesis.json](../configs/genesis.json) file have been generated based on [Hyperledger Besu IBFT2 documentation](https://besu.hyperledger.org/en/stable/Tutorials/Private-Network/Create-IBFT-Network/) with some modifications:

* **gasLimit**: Set to 10485760 (0xa00000), as in [Hyperledger Besu Docs - Creating a Permissioned Network](https://besu.hyperledger.org/en/stable/Tutorials/Permissioning/Create-Permissioned-Network/)
* **alloc** / "Account Ingress smart contract" / "Node Ingress smart contract: Changed to the [PegaSys Permissioning Smart Contracts](https://github.com/PegaSysEng/permissioning-smart-contracts/blob/master/genesis.json)
* **extradata**: Changed to reflect our [initial Red B bootnodes](#extradata)

## "extradata" generation

### :information_source: List of the initial Red B bootnodes

Node | IP | Node Address | enode
---- | ---- | ---- | ----  
Sngular 1 | 3.232.21.149 | 0x20c5b6250f99e3c41d8ae1593eef0520e4e3fcc1 | enode://5e15792a10fefc24bf495c44896734a177ed01857b8b162879b317c5fdcd7f16a0cb8af877a6bb510dc0eb15990cfa92deaa85a87c9edd03e833d928eb6f9f78@3.232.21.149:30303
Sngular 2 | 52.16.154.220 | 0x8c0b92801cc7fdc62f74b7c0c248053fe92f9959 | enode://f5a31862af9adbe702562481663c0fecfc3fa4a6e5a21b16907e23e537f641d40ee361880d68e4d5d97a105a06fe6775c4fca07e507d0ea322018dc0f754546b@52.16.154.220:30303
SigneBlock | 158.176.139.92 | 0xab601b7d7382e24eecb369e508c2de2e710d88d6 | enode://abe1d7baf32e88849526f01369bd432119188ff3f8e369d1abab89e75e14557c33322ea8eced2ab2b4722cf3e3301ef5af9385411c509060e97aa35f1ea1b60c@158.176.139.92:30303
Eurogestion | 5.153.57.78 | 0x6f81cf8b4e36b4ae99567d2c96b8a4ca40585e92 | enode://76af726fa65c4a1fb6e150960eda7e5ac12a58f34dc544911190c44ee32dff3357a5c323639626e9b35e5c3fef4e2a07b21dc82d099560808ae8e4ae870425d5@5.153.57.78:30303

* Create file toEncode.json:

```sh
cat /data/alastria-node-besu/besu/keys/besu/nodeAddress # Extract nodeAddress from all 4 nodes
vi toEncode.json
```

### toEncode.json

```json
[
  "20c5b6250f99e3c41d8ae1593eef0520e4e3fcc1",
  "8c0b92801cc7fdc62f74b7c0c248053fe92f9959",
  "0xab601b7d7382e24eecb369e508c2de2e710d88d6",
  "6f81cf8b4e36b4ae99567d2c96b8a4ca40585e92"
]
```

### :information_source: Information generated from this enodes

#### Create genesis.json/extraData

In this step, we create our genesis.json. For this, we first need the `Node Public Key` we generated in the previous step of the nodes we want as validators. We will then create a json file with an array of said public keys, and encode it to RLP format. We then have to put the result in `extradata` of our genesis.json.

```sh
cd /data/alastria-node-besu/validator
$ bin/besu rlp encode --from=toEncode.json
# result:
#0xf87ea00000000000000000000000000000000000000000000000000000000000000000f854948c0b92801cc7fdc62f74b7c0c248053fe92f99599420c5b6250f99e3c41d8ae1593eef0520e4e3fcc194ab601b7d7382e24eecb369e508c2de2e710d88d6946f81cf8b4e36b4ae99567d2c96b8a4ca40585e92808400000000c0
$ vi genesis.json
```

* Fill [genesis.json](../configs/genesis.json) with this extradata
