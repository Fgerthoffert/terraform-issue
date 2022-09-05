output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "private_security_group_id" {
  value = aws_security_group.ec2_sg_private.id
}

output "subnet_id" {
  value = aws_subnet.ec2_sn.id
}

output "key_name" {
  value = aws_key_pair.ec2_key_deployer.key_name
}

output "cluster_placement_group_id" {
  value = aws_placement_group.perf_group.id
}
