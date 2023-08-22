output "redshift_cluster_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

#output "generated_password" {
#  value = random_password.password.result
#}
