############################################
# Network (VPC + Public Subnet + ACG)
############################################
module "network_module" {
  source = "./network_module"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  zone               = var.zone

  vpc_name       = var.vpc_name
  name_prefix    = var.name_prefix
  allow_ssh_cidr = var.allow_ssh_cidr
}

############################################
# Storage (Object Storage)
############################################
module "storage_module" {
  source = "./storage_module"

  bucket_name = var.bucket_name
}

############################################
# Server (Public Subnet + Public IP)
############################################
module "server_module" {
  source = "./server_module"

  # 네트워크 연결
  subnet_no = module.network_module.public_subnet_no
  # 키 생성/저장 옵션
  login_key_name     = var.login_key_name
  generate_login_key = var.generate_login_key
  pem_output_dir     = var.pem_output_dir

  # 서버 파라미터
  zone                      = var.zone
  server_name               = var.server_name
  server_image_product_code = var.server_image_product_code
  server_product_code       = var.server_product_code
  assign_public_ip          = var.assign_public_ip
  user_data                 = var.user_data
}
