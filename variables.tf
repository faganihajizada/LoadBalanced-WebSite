# ---------------------------------------------------------------------------------------------------------------------
# Define variables
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
    type = string
}

variable "aws_profile" {
    type = string
}

variable "cidr-block" {
    type = string
    default = "192.168.16.0/24"
}

variable "vpc-name" {
    default = "web-app-infra-vpc"
    type = string
}

variable "cidr-block-subnet1" {
    default = "192.168.16.0/26"
}

variable "cidr-block-subnet2" {
    default = "192.168.16.64/26"
}

variable "subnet-name" {
    default = "web-app-infra-Subnet"
}

variable "igw-name" {
    default = "web-app-infra-IGW"
}

variable "cidr-block-rt" {
    default = "0.0.0.0/0"
}

variable "rt-name" {
    default = "web-app-infra-RT"
}

variable "sg-name" {
    default = "web-app-infra-SG"
}

variable "sg-desc" {
    default = "Allow HTTP, SSH, ingress_haproxy_exporter_web, haproxy_frontend_stats, grafana, node-explorer inbound and outbound traffic"
}

variable "key-name" {
    default = "web-app-infra-terraform-key"
}

variable "pub-key" {
    # paste public key here
    default = ""
}

variable "intance-type" {
    default = "t2.micro"
}

variable "instance-name" {
    default = "web-app-infra"
}

variable "load-balancer-name" {
    default = "web-app-infra-lb"
}

variable "load-balancer-target-group-name" {
    default = "web-app-infra-lb-target"
}

variable "ami-id" {
    default = "ami-05f7491af5eef733a"
}