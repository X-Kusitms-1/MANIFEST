output "server_instance_no" {
  value       = ncloud_server.this.id
  description = "Server instance number"
}

output "server_private_ip" {
  value       = ncloud_server.this.private_ip
  description = "Server private IP"
}

output "server_public_ip" {
  value       = try(ncloud_public_ip.this[0].public_ip, null)
  description = "Server public IP (null if assign_public_ip=false)"
}

# 최종 서버에서 쓸 코드(지금 코드대로면 둘 다 .id 사용)
output "final_image_code" {
  value       = try(data.ncloud_server_image.ubuntu.id, null)
  description = "ncloud_server_image.ubuntu 가 반환한 코드(=id)"
}

output "final_spec_code" {
  value       = try(data.ncloud_server_product.spec.product_code, null)
  description = "ncloud_server_product.spec 의 product_code"
}