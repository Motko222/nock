#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$(journalctl -u nock-leader.service --no-hostname -o cat | grep "Build label:" | awk '{print $NF}' | tail -1)
service1=$(sudo systemctl status nock-leader --no-pager | grep "active (running)" | wc -l)
service2=$(sudo systemctl status nock-follower --no-pager | grep "active (running)" | wc -l)
errors1=$(journalctl -u nock-leader.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")
errors2=$(journalctl -u nock-follower.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")
#balance=$(./root/nockchain/target/release/nockchain-wallet --nockchain-socket ./test-leader/nockchain.sock balance)

status="ok" && message="bal=$balance"
[ $errors1 -gt 500 ] && status="warning" && message="bal=$balance errors=$errors1/$errors2";
[ $service2 -ne 1 ] && status="error" && message="follower service not running";
[ $service1 -ne 1 ] && status="error" && message="leader service not running";

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
       "id":"$folder-$ID",
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
        "service_leader":"$service1",
        "service_follower":"$service2",
        "errors":"$errors1/$errors2",
        "url":""
  }
}
EOF

cat $json | jq
