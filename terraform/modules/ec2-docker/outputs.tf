output "public-ip" {
  value = aws_instance.ec2_docker.public_ip
}