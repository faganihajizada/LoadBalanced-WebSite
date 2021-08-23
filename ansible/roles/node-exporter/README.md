node-exporter
=========

An ansible role to install and configure node-exporter for prometheus.

Requirements
------------

- Assumes a Unix/Linux OS, and has only been tested on the Ubuntu OS family

Role Variables
--------------

- The node-exporter configuration variables configured in [defaults/main.yml](./defaults/main.yml)

Example Playbook
----------------

Install and configure node-exporter for prometheus.

    - name: Install and configure node-exporter
      hosts: webservers, loadbalancers
      become: yes
      roles:
      - node-exporter