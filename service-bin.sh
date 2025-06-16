path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

#follower
printf "[Unit]
Description=$folder
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/$folder/env
Environment="PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin:/usr/local/go/bin:/root/go/bin"
Environment="RUST_LOG=INFO"
Environment="MINIMAL_LOG_FORMAT=true"
User=root
Group=root
ExecStart=/root/nockchain/target/release/nockchain --mining-pubkey $PUBKEY --mine --bind $BIND --state-jam /root/$folder/state.jam
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$folder
WorkingDirectory=$WORKDIR

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$folder.service

sudo systemctl daemon-reload
sudo systemctl enable $folder
