#!/bin/bash
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
server: https://fxd.vyn.com:9345
token: K101a2f45c2570e440bfed7c5aa206652123587c9996dac3467ce8b1956e47d1915::server:e7867265ddf5b04cfcf9c751bfc1e411
EOF

apt install ufw -y

# install rke2 server
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -- --verbose
systemctl enable rke2-agent.service
systemctl start rke2-agent.service