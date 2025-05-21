path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

#follower
printf "[Unit]
Description=nock miner
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/nock/env
Environment="PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin"
User=root
Group=root
ExecStart=make run-nockchain
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=nock
WorkingDirectory=/root/nockchain

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nock.service

sudo systemctl daemon-reload
sudo systemctl enable nock
