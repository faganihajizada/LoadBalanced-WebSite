terraform {
  required_version = ">= 0.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# Define provider for terraform, Shared Credentials file/AWS Profile and modules
# ---------------------------------------------------------------------------------------------------------------------

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  # shared_credentials_file = "path_file_credentials like C:\Users\terraform\.aws\credentials"
}


# ---------------------------------------------------------------------------------------------------------------------
# Create VPC, subnet, elastic IP and internet gateway
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "web_app_infra_vpc" {
  cidr_block       = var.cidr-block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_eip" "web_app_infra-eip" {
  count = 2
  instance = aws_instance.web_app_infra_instance[count.index].id
  vpc      = true
}

resource "aws_eip" "web_app_infra-loadbalancer-eip" {
  instance = aws_instance.web_app_infra_loadbalancer.id
  vpc      = true
}

resource "aws_eip" "web_app_infra-grafana-eip" {
  instance = aws_instance.prometheus_grafana_stack.id
  vpc      = true
}

resource "aws_subnet" "web_app_infra_Subnet" {
  vpc_id     = aws_vpc.web_app_infra_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = var.cidr-block-subnet1

  tags = {
    Name = var.subnet-name
  }
}

resource "aws_internet_gateway" "web_app_infra_IGW" {
  vpc_id = aws_vpc.web_app_infra_vpc.id

  tags = {
    Name = var.igw-name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create route table and route table associations
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "web_app_infra_rt" {
  vpc_id = aws_vpc.web_app_infra_vpc.id

  route {
    cidr_block = var.cidr-block-rt
    gateway_id = aws_internet_gateway.web_app_infra_IGW.id
  }

  tags = {
    Name = var.rt-name
  }
}

resource "aws_route_table_association" "web_app_infra_rt-association" {
  subnet_id      = aws_subnet.web_app_infra_Subnet.id
  route_table_id = aws_route_table.web_app_infra_rt.id
}

resource "aws_main_route_table_association" "web_app_infra_default-rt" {
  vpc_id         = aws_vpc.web_app_infra_vpc.id
  route_table_id = aws_route_table.web_app_infra_rt.id
}


# ---------------------------------------------------------------------------------------------------------------------
# Create security group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "web_app_infra_SG" {
  name        = var.sg-name
  description = var.sg-desc
  vpc_id      = aws_vpc.web_app_infra_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ingress_haproxy_exporter_web"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "haproxy_frontend_stats"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "node-explorer"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create EC2 key_pair
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_key_pair" "web_app_infra_key" {
  key_name   = var.key-name
  public_key = var.pub-key
}

# ---------------------------------------------------------------------------------------------------------------------------------
# Deploy two EC2 instances to install apache web server, one instance for install load balancer and prometheus-grafana stack
# ---------------------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "web_app_infra_instance" {
  count = 2  # We create 2 ec2 instances for load balance web-app
  ami           = var.ami-id
  instance_type = var.intance-type
  vpc_security_group_ids = [aws_security_group.web_app_infra_SG.id]
  subnet_id     = aws_subnet.web_app_infra_Subnet.id
  key_name      = aws_key_pair.web_app_infra_key.id

  tags = {
    Name = var.instance-name
  }
}

resource "aws_instance" "web_app_infra_loadbalancer" {
  ami           = var.ami-id
  instance_type = var.intance-type
  vpc_security_group_ids = [aws_security_group.web_app_infra_SG.id]
  subnet_id     = aws_subnet.web_app_infra_Subnet.id
  key_name      = aws_key_pair.web_app_infra_key.id

  tags = {
    Name = var.instance-name
  }
}

resource "aws_instance" "prometheus_grafana_stack" {
  ami           = var.ami-id
  instance_type = var.intance-type
  vpc_security_group_ids = [aws_security_group.web_app_infra_SG.id]
  subnet_id     = aws_subnet.web_app_infra_Subnet.id
  key_name      = aws_key_pair.web_app_infra_key.id

  tags = {
    Name = var.instance-name
  }
}
