prometheus
=========

An ansible role to install and configure prometheus.

Requirements
------------

- Assumes a Unix/Linux OS, and has only been tested on the Ubuntu OS family

Role Variables
--------------

- The node-exporter configuration variables configured in [defaults/main.yml](./defaults/main.yml)
- It also uses `{{ ansible_host }}` fromm inventory for scrape_configs

Example Playbook
----------------

Install and configure Prometheus on linux instances.

    - name: Install and configure node-exporter
      hosts: webservers
      become: yes
      roles:
      - node-exporter