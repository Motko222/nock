#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

read -p "Grep? " g

journalctl -n 1000000 -u $folder.service -f --no-hostname -o cat | grep -E "$g"
