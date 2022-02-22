# Tools - Block Explorer - Alethio Lite Explorer installation guide

Use the Alethio Ethereum Lite Explorer to explore blockchain data at the block, transaction, and account level.

The Alethio Ethereum Lite Explorer is a web application that connects to any Ethereum JSON-RPC enabled node. No online server, hosting, or trusting third parties to display the blockchain data is required.

## Run Using Docker

To run the Ethereum Lite Explorer using the Docker image:

Run the alethio/ethereum-lite-explorer Docker image specifying the JSON-RPC HTTP URL (http://yourIP:8545 in this example):

```sh
docker run --rm -p 8081:80 -e APP_NODE_URL=http://yourIP:8545 alethio/ethereum-lite-explorer
```

Open http://yourIP:8081 in your browser to view the Lite Explorer.

> :information_source: Default HTTP port:
> We are using port 8081 to run the Ethereum Lite Explorer so the EthStats Lite can use port 80. You can then run both at the same time.

## Install and Run with Node.js

1. Clone the ethereum-lite-explorer repository:

```sh
git clone https://github.com/Alethio/ethereum-lite-explorer.git
```

2. Change into the ethereum-lite-explorer directory:

```sh
cd ethereum-lite-explorer
```

3. Install npm packages:

```sh
npm install
```

4. Copy the sample config:

```sh
cp config.default.json config.dev.json
```

5. Update the <code>config.dev.json</code> file:

- Set <code>APP_NODE_URL</code> to the JSON-RPC HTTP URL of your node (http://yourIP:8545 in this example)

- Remove other environment variables.

6. In another terminal, start Besu with the --rpc-http-enabled option.

7. In the ethereum-lite-explorer directory, run the Lite Explorer in development mode:

```sh
npm run build
npm run start
```

8. A browser window displays the Ethereum Lite Explorer (http://yourIP:3000/).

---

### Source:

<code>https://besu.hyperledger.org/en/stable/HowTo/Deploy/Lite-Block-Explorer/</code>
