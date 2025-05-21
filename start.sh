#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

systemctl stop nock-leader.service
systemctl stop nock-follower.service

systemctl restart nock-leader.service
systemctl restart nock-follower.service

journalctl -n 200 -u nock-leader.service -f --no-hostname -o cat
