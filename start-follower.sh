#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

systemctl restart nock-follower.service

journalctl -n 200 -u nock-follower.service -f --no-hostname -o cat
