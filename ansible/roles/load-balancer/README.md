loadbalancer
=========

An ansible role to install and configure [HAProxy](http://www.haproxy.org/) in linux instances.

Requirements
------------

- Assumes a Unix/Linux OS, and has only been tested on the Ubuntu OS family

Role Variables
--------------

- The frontend and backend loadbalancer configuration variables configured in [defaults/main.yml](./defaults/main.yml)

Example Playbook
----------------

Install and configure Grafana. Add prometheus datasource and import node-explorer and HAProxy dashboards.

    - name: Install and configure HAProxy loadbalancer
      hosts: loadbalancers
      become: true
      roles:
        - load-balancer