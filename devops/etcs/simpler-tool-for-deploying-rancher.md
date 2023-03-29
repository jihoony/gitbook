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

{% file src="../../.gitbook/assets/Vagrantfile" %}

{% file src="../../.gitbook/assets/rancher_install.sh" %}

{% file src="../../.gitbook/assets/docker_install.sh" %}







