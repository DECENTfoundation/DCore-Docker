## What is DCore?

DCore is the blockchain you can easily build on. As the world’s first blockchain designed for digital content, media and entertainment, it provides user-friendly software development kits (SDKs) that empower developers and businesses to build decentralized applications for real-world use cases. DCore is packed-full of customizable features making it the ideal blockchain for any size project.

Visit [DCore website](https://decent.ch/dcore)  for more details.

## What's in this image?

This image contains DCore node and CLI wallet. It exposes 2 ports: 8090 (websocket RPC to listen on) and 40000 (P2P node).
You can mount an external data directory (to persist the blockchain) and genesis file (when using custom configuration) to the running container.

```
# run the mainnet node
docker run --rm --name DCore -d -p 8090:8090 -p 40000:40000 --mount type=bind,src=/path/to/data,dst=/home/dcore/.decent/data/decentd decentnetwork/dcore.ubuntu

# run node on custom net
docker run --rm --name DCore -d -p 8090:8090 -p 40000:40000 --mount type=bind,src=/path/to/data,dst=/home/dcore/.decent/data/decentd --mount type=bind,src=/path/to/genesis.json,dst=/home/dcore/.decent/genesis.json,readonly decentnetwork/dcore.ubuntu --genesis-json /home/dcore/.decent/genesis.json

# start CLI wallet and attach to running node
docker cp /path/to/wallet.json DCore:/home/dcore/.decent/wallet.json
docker exec -it -w /home/dcore DCore cli_wallet
docker cp DCore:/home/dcore/.decent/wallet.json /path/to/wallet.json
```

The default mapping of local paths to container paths:

| Host | Container path |
| ---- | -------------- |
| /path/to/data | $DCORE_HOME/.decent/data/decentd |
| /path/to/genesis.json | $DCORE_HOME/.decent/genesis.json |
| /path/to/wallet.json | $DCORE_HOME/.decent/wallet.json |

To run the node as root user set the container environment variables:

| Environment variable | Default value |
| -------------------- | ------------- |
| DCORE_HOME | /home/dcore |
| DCORE_USER | dcore |

If you like to run a DCore seeder node you also need to start IPFS container (see [IPFS project](https://hub.docker.com/r/ipfs/go-ipfs) for detailed guide).
```
export ipfs_staging=/path/to/somewhere
export ipfs_data=/path/to/data
docker run --rm --name ipfs -d -v $ipfs_staging:/export -v $ipfs_data:/data/ipfs -p 5001:5001 ipfs/go-ipfs

# run seeder node on custom net - see also https://docs.decent.ch/Seeding/index.html#start_seeding_plugin_directly_by_setting_specific_decentd_parameters
docker run --rm --name DCore -d -p 8090:8090 -p 40000:40000 --mount type=bind,src=/path/to/data,dst=/home/dcore/.decent/data/decentd --mount type=bind,src=/path/to/genesis.json,dst=/home/dcore/.decent/genesis.json,readonly decentnetwork/dcore.ubuntu --genesis-json /home/dcore/.decent/genesis.json --ipfs-api 0.0.0.0:5001
```
