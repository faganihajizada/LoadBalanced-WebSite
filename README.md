### LoadBalanced-WebSite
Provision a load-balanced static HTML page whose metrics are collected by Prometheus &amp; illustrated by Grafana on AWS using Terraform and Ansible.

### Requirements
----------------

| Name | Version | Notes |
|------|---------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_ansible"></a> [ansible](#requirement\_ansible) | >= 2.9 |
| <a name="requirement_ansible_community"></a> [ansible community.grafana collection ](#requirement\_requirement_ansible_community) | >= 1.2.1 | To install it use: `ansible-galaxy collection install community.grafana`

### Tested on

The role was tested in the following distributions on AWS.

| Distribution                | Tested             |
| --------------------------- |:------------------:|
| Ubuntu 20.04  | :white_check_mark: |


### Usage
----------

#### Quickstart

- You need to have access to your AWS Account
- Edit variables.tf file if you need to set/edit terraform variables. All variables have default value except `aws_region` and `aws_profile`.
- Edit [grafana variable file](./ansible/roles/grafana/vars/main.yml) and set Garafana admin password
- Optionally all configuration related variables can be changed from the according role's default folder

Here is an example to provision a load-balanced static HTML page whose metrics are collected by Prometheus &amp; illustrated by Grafana on AWS using Terraform and Ansible:

```
$ terraform init
$ terraform plan
$ terraform apply
...
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

```
- After provisioning infrastructure with terraform a new `inventory file` will be created in `ansible` folder
- Use created inventory file to configure infrastructure with ansible:

```
$ ansible-playbook -i ansible/inventory ansible/site.yml

...
PLAY RECAP ***********************************************************************************************************************************************************
grafana1                   : ok=17   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
loadbalancer1              : ok=31   changed=19   unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
web_server1                : ok=19   changed=16   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
web_server2                : ok=19   changed=16   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

```

Now we can get the IP address of `loadbalancer` and `grafana UI` from inventory file. We can just open the `./ansible/inventory` file or use bash tools like awk to get the required IP addresses (ex: `awk '{print $1 "\t" $2}'  ./ansible/inventory`)

```
$ awk '{print $1 "\t" $2}'  ./ansible/inventory

[webservers]
web_server1     ansible_host=3.67.145.153
web_server2     ansible_host=35.157.56.87

[loadbalancers]
loadbalancer1   ansible_host=18.156.139.80

[grafanaservers]
grafana1        ansible_host=18.157.65.105

```

Try to access web site:
```
$ curl http://18.156.139.80        

<html>
    <head>
        <title>Welcome to 35.157.56.87 !</title>
    </head>
    <body>
        <h1>The apache virtual is running! IP Address: 35.157.56.87! </h1>
    </body>
</html>%


$ curl http://18.156.139.80

<html>
    <head>
        <title>Welcome to 3.67.145.153 !</title>
    </head>
    <body>
        <h1>The apache virtual is running! IP Address: 3.67.145.153! </h1>
    </body>
</html>%
```
As we can see the HAProxy `roundrobin` configuration works!

In order to access Grafana UI and check dashboards and collected metrics open the grafana1 host (18.157.65.105) in browser and access via password which set in [grafana variable file](./ansible/roles/grafana/vars/main.yml).

There will be 1 datasource `prometheus` and 2 dashboards `HAProxy and Node Exporter Full` created.

- The `HAProxy` dashboard contains metrics from loadbalancer. The `Relative time ranges` and `Refresh dashboard` settings can be configured to see data.

- The `Node Exporter Full` dashboard contains metrics from these servers:
  
  - `loadbalancer1 ansible_host=18.156.139.80`
  - `web_server1 ansible_host=3.67.145.153`
  - `web_server2 ansible_host=35.157.56.87`

Note: A bash code can be run to create traffic on loadbalancer and monitor: ```while true;do curl http://{locadbalancer1 IP Address};done```

### Architecture
----------

![Architecture](repo-files/architecture.png "Architecture")

## Credits

I've been inspired by the following open source projects:

* [ prometheus/haproxy_exporter ](https://github.com/prometheus/haproxy_exporter)
* [ rfrail3/grafana-dashboards ](https://github.com/rfrail3/grafana-dashboards)
