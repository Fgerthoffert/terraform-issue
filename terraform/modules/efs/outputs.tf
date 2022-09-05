output "filesystem_id" {
  description = "ID of the EFS filesystem"
  value       = aws_efs_file_system.efs.id
}

output "dns_name" {
  description = "DNS name of the EFS filesystem"
  value       = aws_efs_file_system.efs.dns_name
}