path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

#leader
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

#follower
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
