#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

rm -rf /root/.socket/.data.nockchain /root/.socket/nockchain_npc.sock

systemctl restart $folder.service

journalctl -n 200 -u $folder.service -f --no-hostname -o cat
