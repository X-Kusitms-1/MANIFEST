output "vpc_id" { value = module.network_module.vpc_id }
output "public_subnet_no" { value = module.network_module.public_subnet_no }
output "server_instance_no" { value = module.server_module.server_instance_no }
output "server_private_ip" { value = module.server_module.server_private_ip }
output "server_public_ip" { value = module.server_module.server_public_ip }
output "bucket_name" { value = module.storage_module.bucket_name }