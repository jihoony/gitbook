# Installing Logstash

## Installing Logstash

### APT

Download and install the Public Signing Key:

{% code overflow="wrap" %}
```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
```
{% endcode %}

You may need to install the `apt-transport-https` package on Debian before proceeding:

```bash
sudo apt-get install apt-transport-https
```

Save the repository definition to `/etc/apt/sources.list.d/elastic-8.x.list`:

{% code overflow="wrap" %}
```bash
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
```
{% endcode %}

> Use the `echo` method described above to add the Logstash repository. Do no use `add-apt-repository` as it will add a `deb-src` entry as well, but we do not provide a source package. If you have added the `deb-src` entry, you will see an error like the following:
>
> {% code overflow="wrap" %}
> ```
> Unable to find expected entry 'main/source/Sources' in Release file (Wrong sources.list entry or malformed file)
> ```
> {% endcode %}
>
> Just delete the `deb-src` entry from the `/etc/apt/sources.list` file and the installation should work as expected.

Run `sudo apt-get update` and the repository is ready for use. You can install it with:

{% code overflow="wrap" %}
```bash
sudo apt-get update && sudo apt-get install logstash
```
{% endcode %}



## Running Logstash

```bash
sudo systemctl start logstash
```



## Reference

{% embed url="https://www.elastic.co/guide/en/logstash/current/installing-logstash.html#_apt" %}

