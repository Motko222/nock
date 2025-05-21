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
Environment="PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin"
User=root
Group=root
ExecStart=cd /root/nockchain/target/release && make run-nockchain-leader
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=nock-leader
WorkingDirectory=/root/nockchain

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nock-leader.service

#follower
printf "[Unit]
Description=nock-follower node
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/nock/env
Environment="PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin"
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
WorkingDirectory=/root/nockchain

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nock-follower.service

sudo systemctl daemon-reload
sudo systemctl enable nock-leader
