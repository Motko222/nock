#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

rm -r $WORKDIR/.data.nockchain
rm -r $WORKDIR/.socket
rm -r $WORKDIR/.nockchain_identity  
rm -r $WORKDIR/.nockchain_identity.peerid
