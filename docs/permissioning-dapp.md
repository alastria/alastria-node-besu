# Tools - Permissioning DApp

To launch the dApp for viewing and adding nodes and addresses to the network, run

## Prerequisites

The Dapp its a web3 application that uses Metamask to access to the BESU node. You should enable rcp access (and maybe take care about CORS and others RPC options in config.toml file) and start this aplication, https://github.com/ConsenSys/permissioning-smart-contracts/releases/tag/v1.1.0, using this config.json:

```
{
  "accountIngressAddress": "0x0000000000000000000000000000000000008888",
  "nodeIngressAddress": "0x0000000000000000000000000000000000009999",
  "networkId": "2020"
}
```

You can use Visual Studio Code + [LiveServer](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) in order to start a local webserer to interact with the dapp.

## Notes

- This guide is for installation in a Besu node. For installation in another server, change IP in BESU_NODE_PERM_ENDPOINT param ("localhost") with the IP of a node you can access
- Use Metamask to "login" the DApp with an admin address in order to make changes

```sh
cd alastria-node-besu/besu-node
git clone https://github.com/Eng/permissioning-smart-contracts.git
cd permissioning-smart-contracts
yarn install
docker container run -v `pwd`:`pwd` -w `pwd` -it --rm -e "ACCOUNT_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000008888" -e "NODE_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000009999" -e "BESU_NODE_PERM_ENDPOINT=http://localhost:8545" -e "NETWORK_ID=2020" -p 3000:3000 node:12 yarn start
```
