output "zone_id_public" {
  description = "zone id of the public subdomain"
  value       = aws_route53_zone.perf_r53_zone_public.zone_id
}

output "zone_id_private" {
  description = "zone id of the private subdomain"
  value       = aws_route53_zone.perf_r53_zone_private.zone_id
}
