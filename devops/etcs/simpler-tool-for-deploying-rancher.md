# Simpler Tool for Deploying Rancher

As part of Rancher 2.5, we are excited to introduce a new, simpler way to install Rancher called RancherD.

RancherD is a single binary you can launch on a host to bring up a Kubernetes cluster bundled with a deployment of Rancher itself.

This means you just have one thing to manage: RancherD. Configuration and upgrading are no longer two-step processes where you first have to deal with the underlying Kubernetes cluster and _then_ deal with the Rancher deployment.

> **Note:** This feature is still in preview as we gather feedback about its usability and address bugs found by the community. It’s not quite ready for production use.

## Getting Started with RancherD

Let’s take a look at how you can get started with RancherD.

First, run the installer:

```bash
curl -sfL https://get.rancher.io | sh -
```

This will download RancherD and install it as a systemd unit on your host.

> If that systemd note caught your eye: yes, at this time, only OSes that leverage systemd are supported.

Once installed, the `rancherd` binary will be on your path. You can check out its help text like this:

```bash
rancherd --help
NAME:
   rancherd - Rancher Kubernetes Engine 2

USAGE:
   rancherd [global options] command [command options] [arguments...]

VERSION:
   v2.5.0-rc8 (HEAD)

COMMANDS:
   server       Run management server
   agent        Run node agent
   reset-admin  Bootstrap and reset admin password
   help, h      Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug        Turn on debug logs [$RKE2_DEBUG]
   --help, -h     show help
   --version, -v  print the version
```

Next, let’s launch RancherD. You can launch the binary directly via `rancherd server`, but we’re going to stick with the systemd service for this demo.

```bash
systemctl enable rancherd-server.service
systemctl start rancherd-server.service
```

You can follow the logs of the cluster coming up thusly:

```bash
journalctl -eu rancherd-server -f
```

It will take a couple minutes to come up.

Once the cluster is up and the logs have stabilized, you can start interacting with the cluster. Here’s how:

First, setup RancherD’s kubeconfig file and kubectl:

```bash
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/var/lib/rancher/rke2/bin
```

Now, you can start issuing kubectl commands. Rancher is deployed as a daemonset on the cluster, let’s take a look:

```bash
kubectl get daemonset rancher -n cattle-system

kubectl get pod -n cattle-system
```

We’re almost ready to jump into the Rancher UI, but first you need to set the initial Rancher password. Once the `rancher` pod is up and running, run the following:

```bash
rancherd reset-admin
```

This will give you the URL, username and password needed to log into Rancher. Follow that URL, plug in the credentials, and you’re up and running with Rancher!





{% embed url="https://www.suse.com/c/rancher_blog/introducing-rancherd-a-simpler-tool-for-deploying-rancher/" %}





### Vagrant Test

If you want to build with virtualbox and vagrant, check below files:

{% code title="Vagrantfile" overflow="wrap" lineNumbers="true" %}
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

class Node
    def initialize(name, cpus, memory, ip, port, script)
        @node_name = name
        @node_cpus = cpus
        @node_memory = memory
        @node_ip = ip
		@node_port = port
        @node_script = script
    end

    attr_reader :node_name
    attr_reader :node_cpus
    attr_reader :node_memory
    attr_reader :node_ip
    attr_reader :node_port
    attr_reader :node_script
end

Vagrant.configure("2") do |config|

 rancher = Node.new("rancher", 4, 4 * 1024, "192.168.56.10", 8443, "rancher_install.sh")
 master1 = Node.new("master1", 2, 2 * 1024, "192.168.56.11", nil, "docker_install.sh")
 master2 = Node.new("master2", 2, 2 * 1024, "192.168.56.12", nil, "docker_install.sh")
 master3 = Node.new("master3", 2, 2 * 1024, "192.168.56.13", nil, "docker_install.sh")
 worker1 = Node.new("worker1", 2, 2 * 1024, "192.168.56.14", nil, "docker_install.sh")
 worker2 = Node.new("worker2", 2, 2 * 1024, "192.168.56.15", nil, "docker_install.sh")


 nodes = [rancher, master1, master2, master3, worker1, worker2]

 nodes.each do |node|

	config.vm.define node.node_name do |instance|

 		instance.vm.box = "ubuntu/focal64"
		instance.vm.hostname = node.node_name + ".example.com"
		instance.vm.network "private_network", ip: node.node_ip
		instance.vm.provision "shell", path: node.node_script

		if !node.node_port.nil? then
			instance.vm.network "forwarded_port", guest: node.node_port, host: node.node_port
		end

		instance.vm.provider "virtualbox" do |vb|
			vb.name = node.node_name
			vb.cpus = node.node_cpus
			vb.memory = node.node_memory
		end
	end
 end

end
```
{% endcode %}

{% code title="rancher_install.sh" overflow="wrap" %}
```bash
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
```
{% endcode %}



{% code title="docker_install.sh" overflow="wrap" %}
```bash
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

systemctl daemon-reload && systemctl restart docker


echo "[Node] ifconfig"
ifconfig | grep inet
```
{% endcode %}

