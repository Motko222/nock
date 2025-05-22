#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

rm -rf /root/nockchain/.socket/.data.nockchain /root/nockchain/.socket/nockchain_npc.sock

systemctl restart $folder.service

journalctl -n 200 -u $folder.service -f --no-hostname -o cat
