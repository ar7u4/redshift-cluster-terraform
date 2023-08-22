provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  count             = 2
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_security_group" "redshift_sg" {
  name_prefix = "redshift-sg-"
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier      = "my-redshift-cluster"
  node_type               = "dc2.large"
  master_username         = "admin"
  master_password         = random_password.password.result
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  skip_final_snapshot    = false
  final_snapshot_identifier = "my-final-snapshot"
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "my-redshift-subnet-group"
  subnet_ids = aws_subnet.main.*.id
}

resource "aws_redshift_parameter_group" "redshift_parameter_group" {
  name   = "redshift-param-group"
  family = "redshift-1.0"
  parameter {
    name  = "wlm_json_configuration"
    value = "{\"query_group\": [{\"query_group_name\": \"example\", \"query_timeout\": 1800}]}"
  }
}

resource "aws_redshift_database" "example" {
  cluster_identifier = aws_redshift_cluster.redshift_cluster.id
  database_name     = "mydatabase"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

output "redshift_cluster_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

output "generated_password" {
  value = random_password.password.result
}
