############################################
# Ubuntu 22.04 BaseOS (KVM) 이미지 자동 선택
############################################
data "ncloud_server_image" "ubuntu" {
  filter {
    name = "product_name"
    values = ["ubuntu-20.04"]
  }
}

############################################
# STANDARD(표준형) 2 vCPU / 8GB 스펙 자동 선택
############################################
data "ncloud_server_product" "spec" {
  server_image_product_code = data.ncloud_server_image.ubuntu.id

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex = true
  }
  filter {
    name   = "cpu_count"
    values = ["2"]
  }
  filter {
    name   = "memory_size"
    values = ["8GB"]
  }
  filter {
    name   = "product_type"
    values = ["STAND"]
  }
}

# 폴더 생성
resource "null_resource" "mkdir_keys" {
  count = var.generate_login_key ? 1 : 0
  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/${var.pem_output_dir}"
  }
}

############################################
# 키 생성
############################################
# 키 생성
resource "ncloud_login_key" "gen" {
  count    = var.generate_login_key ? 1 : 0
  key_name = var.login_key_name
  # lifecycle { prevent_destroy = true }
}

# pem 저장
resource "local_sensitive_file" "pem" {
  count     = var.generate_login_key ? 1 : 0
  filename  = "${path.root}/${var.pem_output_dir}/${var.login_key_name}.pem"
  content   = ncloud_login_key.gen[0].private_key
  depends_on = [null_resource.mkdir_keys]
}

# 권한
resource "null_resource" "chmod_pem" {
  count = var.generate_login_key ? 1 : 0
  provisioner "local-exec" {
    command = "chmod 400 ${path.root}/${var.pem_output_dir}/${var.login_key_name}.pem || true"
  }
  depends_on = [local_sensitive_file.pem]
}

# 서버 리소스에 사용할 '유효한' 키 이름
locals {
  effective_login_key_name = var.generate_login_key ? ncloud_login_key.gen[0].key_name : var.login_key_name
}

############################################
# 서버 리소스에 적용
############################################
resource "ncloud_server" "this" {
  name        = var.server_name
  subnet_no   = var.subnet_no
  zone        = var.zone
  login_key_name = local.effective_login_key_name

  # 자동 조회한 코드 사용
  server_image_product_code = data.ncloud_server_image.ubuntu.id
  server_product_code       = data.ncloud_server_product.spec.id

  # 네트워크 규칙은 기본 ACG에 넣었으므로 여기선 생략
  # access_control_group_no_list = (X)
}

#######################################
# 비밀번호 받아오기 (옵션)
#######################################
data "ncloud_root_password" "root_pw" {
  count              = var.save_root_password ? 1 : 0
  server_instance_no = ncloud_server.this.instance_no

  # generate_login_key=true면 TF가 만든 키, 아니면 로컬 .pem 파일에서 읽기
  private_key = var.generate_login_key ? ncloud_login_key.gen[0].private_key : file("${path.root}/${var.pem_output_dir}/${var.login_key_name}.pem")
}

resource "local_sensitive_file" "root_pw" {
  count    = var.save_root_password ? 1 : 0
  filename = "${path.root}/keys/${ncloud_server.this.name}-root_password.txt"
  content  = data.ncloud_root_password.root_pw[0].root_password
}

#######################################
# Public IP (optional)
#######################################
resource "ncloud_public_ip" "this" {
  count              = var.assign_public_ip ? 1 : 0
  server_instance_no = ncloud_server.this.id
  description        = "${var.server_name}-public-ip"
}
