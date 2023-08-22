variable "ssh_key_name" {
  description = "Name for the SSH key pair"
}

variable "ssh_public_key" {
  description = "SSH public key content"
}

variable "redshift_final_snapshot_identifier" {
  description = "Final snapshot identifier for Redshift cluster"
  default     = "my-final-snapshot"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}
