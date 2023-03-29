#!/bin/bash

# https://www.suse.com/c/rancher_blog/introducing-rancherd-a-simpler-tool-for-deploying-rancher/
# export port 8443

echo "[Task 1] Swapoff"
swapoff -a

# install rancher
echo "[Task 2] Install rancher"
curl -sfL https://get.rancher.io | sh -
systemctl enable rancherd-server.service
systemctl start rancherd-server.service

# rancher config
echo "[Task 3] config"
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/var/lib/rancher/rke2/bin


echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml' >> ~/.bashrc
echo 'export PATH=$PATH:/var/lib/rancher/rke2/bin' >> ~/.bashrc


