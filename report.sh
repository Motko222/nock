#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$(journalctl -u $folder.service --no-hostname -o cat | grep "Build label:" | awk '{print $NF}' | tail -1)
service=$(sudo systemctl status $folder.service --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")
#balance=$(./root/nockchain/target/release/nockchain-wallet --nockchain-socket ./test-leader/nockchain.sock balance)
height=$(journalctl -u $folder.service --no-hostname -o cat | grep "added to validated blocks at" | awk '{print $NF}' | tail -1)

status="ok" && message="height=$height bal=$balance"
[ $errors -gt 500 ] && status="warning" && message="bal=$balance errors=$errors";
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
        "url":""
  }
}
EOF

cat $json | jq
