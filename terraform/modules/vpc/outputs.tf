output "vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.vpc.id
}

output "vpc_main_rt_id" {
  description = "id of the vpc main route table"
  value       = aws_vpc.vpc.main_route_table_id
}

output "internet_gateway_id" {
  description = "id of the internet gateway"
  value       = aws_internet_gateway.igw.id
}