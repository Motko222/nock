#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

journalctl -n 1000000 -u $folder.service -f --no-hostname -o cat | grep -E "generating new candidate block|Could not load mining kernel"
