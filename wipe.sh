#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

read -p "Sure ? " sure
[ $sure -ne "y" -a $sure -ne "Y" ] && exit 1

rm -r $WORKDIR/.data.nockchain
rm -r $WORKDIR/.socket
rm -r $WORKDIR/.nockchain_identity  
rm -r $WORKDIR/.nockchain_identity.peerid
