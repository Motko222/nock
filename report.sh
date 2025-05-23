#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$(journalctl -u $folder.service --no-hostname -o cat | grep "Build label:" | awk '{print $NF}' | tail -1)
service=$(sudo systemctl status $folder.service --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")
height=$(journalctl -u $folder.service --no-hostname -o cat | grep "added to validated blocks at" | awk '{print $NF}' | tail -1 | sed -e $'s/\x1b\[[0-9;]*m//g' )
hits=$(./root/nockchain/target/release/nockchain-wallet --nockchain-socket $WORKDIR/.socket/nockchain_npc.sock list-notes-by-pubkey -p $PUBKEY 2>/dev/null | tr -d '\0' | grep -c signers | awk '{print $1 / 2}')
status="ok" && message="height=$height hits=$hits"
[ $errors -gt 2000 ] && status="warning" && message="height=$height hits=$hits errors=$errors";
[ $service -ne 1 ] && status="error" && message="service not running";

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
       "id":"$folder",
       "machine":"$MACHINE",
       "grp":"node",
       "owner":"$OWNER"
  },
  "fields": {
        "chain":"mainnet",
        "network":"mainnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":"$service",
        "errors":"$errors",
        "height":"$height",
        "hits":"$hits",
        "url":"$BIND $PEER"
  }
}
EOF

cat $json | jq
