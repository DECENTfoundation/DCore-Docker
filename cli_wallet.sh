#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 wallet_file [container_name]"; exit 1; }

if [ $# -lt 2 ]; then CONTAINER_NAME=DCore; else CONTAINER_NAME=$2; fi

docker cp $1 $CONTAINER_NAME:/home/dcore/.decent/wallet.json
docker exec -it -w /home/dcore $CONTAINER_NAME cli_wallet
docker cp $CONTAINER_NAME:/home/dcore/.decent/wallet.json $1
