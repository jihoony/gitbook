# Install MariaDB Galera by Helm

## Install MariaDB Galera

### Create Namespace

{% code overflow="wrap" %}
```bash
$ kubectl create namespace galera
```
{% endcode %}



Result

{% code overflow="wrap" %}
```bash
$ kubectl create namespace galera
namespace/galera created
```
{% endcode %}



### Install Helm Chart

{% code overflow="wrap" %}
```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install dbcluster -n galera --set rootUser.password=Password bitnami/mariadb-galera
```
{% endcode %}



Result

{% code overflow="wrap" %}
```bash
$ helm install dbcluster -n galera --set rootUser.password=Password bitnami/mariadb-galera
NAME: dbcluster
LAST DEPLOYED: Mon Feb 20 14:24:35 2023
NAMESPACE: galera
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: mariadb-galera
CHART VERSION: 7.4.15
APP VERSION: 10.6.12

** Please be patient while the chart is being deployed **
Tip:

  Watch the deployment status using the command:

    kubectl get sts -w --namespace galera -l app.kubernetes.io/instance=dbcluster

MariaDB can be accessed via port "3306" on the following DNS name from within your cluster:

    dbcluster-mariadb-galera.galera.svc.cluster.local

To obtain the password for the MariaDB admin user run the following command:

    echo "$(kubectl get secret --namespace galera dbcluster-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 -d)"

To connect to your database run the following command:

    kubectl run dbcluster-mariadb-galera-client --rm --tty -i --restart='Never' --namespace galera --image docker.io/bitnami/mariadb-galera:10.6.12-debian-11-r3 --command \
      -- mysql -h dbcluster-mariadb-galera -P 3306 -uroot -p$(kubectl get secret --namespace galera dbcluster-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 -d) my_database

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace galera svc/dbcluster-mariadb-galera 3306:3306 &
    mysql -h 127.0.0.1 -P 3306 -uroot -p$(kubectl get secret --namespace galera dbcluster-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 -d) my_database

To upgrade this helm chart:

    helm upgrade --namespace galera dbcluster my-repo/mariadb-galera \
      --set rootUser.password=$(kubectl get secret --namespace galera dbcluster-mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 -d) \
      --set db.name=my_database \
      --set galera.mariabackup.password=$(kubectl get secret --namespace galera dbcluster-mariadb-galera -o jsonpath="{.data.mariadb-galera-mariabackup-password}" | base64 -d)
```
{% endcode %}





## Uninstall MariaDB Galera

### Uninstall Helm Chart

{% code overflow="wrap" %}
```bash
$ kubectl scale sts dbcluster-mariadb-galera -n galera --replicas=0
$ helm delete -n galera dbcluster
```
{% endcode %}

Result

```bash
$ kubectl scale sts dbcluster-mariadb-galera -n galera --replicas=0
statefulset.apps/dbcluster-mariadb-galera scaled
```

Result

```bash
$ helm delete -n galera dbcluster
release "dbcluster" uninstalled
```



### Delete Namespace

{% code overflow="wrap" %}
```bash
$ kubectl delete namespace galera
```
{% endcode %}

Result

```bash
$ kubectl delete namespace galera
namespace "galera" deleted
```



{% embed url="https://github.com/bitnami/charts/tree/main/bitnami/mariadb-galera" %}

