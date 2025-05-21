path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

#install binary
cd /root
# add install cmds here

#create env
cd $path
[ -f env ] || cp env.sample env
nano env

#create service
printf "[Unit]
Description=nock-leader node
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/nock/env
User=root
Group=root
ExecStart=make run-nockchain-leader
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=nock-leader
WorkingDirectory=/root/nockchain/target/release

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nock-leader.service

printf "[Unit]
Description=nock-follower node
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/nock/env
User=root
Group=root
ExecStart=make run-nockchain-follower
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=nock-follower
WorkingDirectory=/root/nockchain/target/release

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nock-follower.service

sudo systemctl daemon-reload
sudo systemctl enable nock-leader
