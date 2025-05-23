#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

journalctl -n 1000000 -u $folder.service -f --no-hostname -o cat | \
 grep -v -E "aborted by peer|friendship ended with|Handshake with the remote timed out|Failed outgoing connection|Failed incoming connection|command: timer|cryptographic handshake failed"
