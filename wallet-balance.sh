#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

RUST_LOG=ERROR
cd /root/nockchain/target/release
./nockchain-wallet --nockchain-socket $WORKDIR/.socket/nockchain_npc.sock list-notes-by-pubkey -p $PUBKEY
