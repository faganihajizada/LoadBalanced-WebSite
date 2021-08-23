grafana
=========

An ansible role to install and configure [grafana](https://grafana.com/) in linux instances.

Requirements
------------

- Assumes a Unix/Linux OS, and has only been tested on the Ubuntu OS family
- The role uses [ansible community.grafana collection](https://github.com/ansible-collections/community.grafana) for adding data sources and import dashboards. The community grafana collection should be installed:
`ansible-galaxy collection install community.grafana`

Role Variables
--------------

- This role requires {{ grafana_admin_password }}. This variable should be configured in [vars/main.yml](./vars/main.yml).
- This role uses the inventory file to get the IP address for configuration purposes: `{{ hostvars['grafana1'].ansible_host }}`

Example Playbook
----------------

Install and configure Grafana. Add prometheus datasource and import node-explorer and HAProxy dashboards.

    - name: Perform Grafana installation and configuration
      hosts: grafanaservers
      become: yes
      roles:
      - grafana