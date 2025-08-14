############################
# Network
############################
output "vpc_id" {
  value       = module.network_module.vpc_id
  description = "생성된 VPC의 ID(번호). NCP API/콘솔에서 참조하는 주 식별자입니다."
}

output "public_subnet_no" {
  value       = module.network_module.public_subnet_no
  description = "퍼블릭 서브넷의 인스턴스 번호. zone, 라우팅 등은 루트 변수(var.zone, var.public_subnet_cidr)를 참고하세요."
}

############################
# Storage
############################
output "bucket_name" {
  value       = module.storage_module.bucket_name
  description = "Object Storage(S3 호환) 버킷 이름. CI/CD 아티팩트/정적 파일 업로드 시 사용합니다."
}

############################
# Server (개별 값)
############################
output "server_instance_no" {
  value       = module.server_module.server_instance_no
  description = "서버 인스턴스 번호. 추가 디스크 연결/진단 API 호출 등에서 필요합니다."
}

output "server_private_ip" {
  value       = module.server_module.server_private_ip
  description = "서버의 프라이빗 IP. 같은 VPC/서브넷 내 통신에 사용합니다."
}

output "server_public_ip" {
  value       = try(module.server_module.server_public_ip, null)
  description = "서버 퍼블릭 IP. assign_public_ip=false 이면 null이 나옵니다."
}

output "root_password_file" {
  value = module.server_module.root_password_file
  description = "비밀번호"
}

############################
# Server (헬퍼 묶음)
############################
output "server_connection" {
  value = {
    os_user   = "ubuntu"
    public_ip = try(module.server_module.server_public_ip, null)

    ssh_cmd = try(
      format("ssh -i ./keys/ilhang-dev-key.pem -o IdentitiesOnly=yes ubuntu@%s",
      module.server_module.server_public_ip),
      null
    )

    # 간단한 확인용
    http_url  = try(format("http://%s", module.server_module.server_public_ip), null)
    https_url = try(format("https://%s", module.server_module.server_public_ip), null)
  }
  description = "접속/헬스체크를 위한 편의 정보 묶음. ssh_cmd의 <path-to-your-pem>만 실제 경로로 바꿔 사용하세요."
}

############################
# 전체 요약(JSON 한 방)
############################
output "inventory_json" {
  value = jsonencode({
    network = {
      vpc_id             = module.network_module.vpc_id
      public_subnet_no   = module.network_module.public_subnet_no
      zone               = var.zone
      vpc_cidr           = var.vpc_cidr
      public_subnet_cidr = var.public_subnet_cidr
    }
    server = {
      instance_no = module.server_module.server_instance_no
      private_ip  = module.server_module.server_private_ip
      public_ip   = try(module.server_module.server_public_ip, null)
      name        = var.server_name
    }
    storage = {
      bucket_name = module.storage_module.bucket_name
    }
  })
  description = "CI/스크립트에서 쓰기 좋은 단일 JSON 요약. `terraform output -raw inventory_json`으로 받아서 파싱하세요."
  sensitive   = false
}
