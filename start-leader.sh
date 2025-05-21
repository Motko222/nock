#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

systemctl restart nock-leader.service

journalctl -n 200 -u nock-leader.service -f --no-hostname -o cat
