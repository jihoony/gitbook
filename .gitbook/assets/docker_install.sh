#!/bin/bash
echo "[Node] Swap Off"
swapoff -a

# Install Docker
echo "[Node] Install Docker"
apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
apt-get install -y vim net-tools

#cat <<EOF > /etc/docker/daemon.json
#{
#    "insecure-registries" : [ "192.168.129.106:5001" ]
#}
#EOF

systemctl daemon-reload && systemctl restart docker


echo "[Node] ifconfig"
ifconfig | grep inet
