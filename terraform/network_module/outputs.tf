output "vpc_id" {
  value       = ncloud_vpc.this.id
  description = "VPC ID"
}

output "public_subnet_no" {
  value       = ncloud_subnet.public.id
  description = "Public subnet instance number"
}

