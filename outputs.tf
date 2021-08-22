# ---------------------------------------------------------------------------------------------------------------------
# Define outputs. In this case this tf file uses 'local-file' resource to create inventory and variables for Ansible
# ---------------------------------------------------------------------------------------------------------------------

resource "local_file" "ansible_inventory" {
 filename = "ansible/inventory"
 content = <<EOF
[webservers]
web_server1 ansible_host=${aws_eip.web_app_infra-eip[0].public_ip} ansible_ssh_connection=ssh ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
web_server2 ansible_host=${aws_eip.web_app_infra-eip[1].public_ip} ansible_ssh_connection=ssh ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[loadbalancers]
loadbalancer1 ansible_host=${aws_eip.web_app_infra-loadbalancer-eip.public_ip} ansible_ssh_connection=ssh ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[grafanaservers]
grafana1 ansible_host=${aws_eip.web_app_infra-grafana-eip.public_ip} ansible_ssh_connection=ssh ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF
}

# Export Terraform variable values to an Ansible var_file

resource "local_file" "ansible_variables_for_load_balancer_module" {
  filename = "ansible/roles/load-balancer/vars/main.yml"
  content = <<-DOC
    ---
    haproxy_backend_servers:
      - name: web-server1
        address: ${aws_eip.web_app_infra-eip[0].public_ip}
      - name: web-server2
        address: ${aws_eip.web_app_infra-eip[1].public_ip}
    DOC
}
