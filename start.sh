#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

[ -d $WORKDIR ] && rm -rf $WORKDIR/.socket/nockchain_npc.sock || mkdir $WORKDIR

systemctl restart $folder.service

journalctl -n 200 -u $folder.service -f --no-hostname -o cat
