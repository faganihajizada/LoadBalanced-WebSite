web-app
=========

An ansible role to install apache2 and create virtual host configuration.

Requirements
------------

- Assumes a Unix/Linux OS, and has only been tested on the Ubuntu OS family

Role Variables
--------------

- This role requires some variables for configure apache2. This variables stored in [vars/main.yml](./vars/main.yml)

Example Playbook
----------------

Install and configure Grafana. Add prometheus datasource and import node-explorer and HAProxy dashboards.

    - name: Configure and deploy simpe apache2 Web site
      hosts: webservers
      become: true
      roles:
        - web-app
