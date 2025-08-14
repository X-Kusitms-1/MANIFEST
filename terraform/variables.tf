############################################
# Provider / 공통
############################################
variable "ncloud_access_key" {
  type        = string
  description = "NCP Access Key (가능하면 환경변수 TF_VAR_ncloud_access_key로 주입)"
  sensitive   = true
}

variable "ncloud_secret_key" {
  type        = string
  description = "NCP Secret Key (가능하면 환경변수 TF_VAR_ncloud_secret_key로 주입)"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "리전 코드 (예: KR)"
  default     = "KR"
}

variable "site" {
  type        = string
  description = "NCP site (보통 public)"
  default     = "public"
}

############################################
# Network
############################################
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR (예: 10.20.0.0/16)"
  default     = "10.10.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr는 유효한 CIDR이어야 합니다. 예: 10.20.0.0/16"
  }
}

variable "public_subnet_cidr" {
  type        = string
  description = "퍼블릭 서브넷 CIDR (예: 10.20.10.0/24)"
  default     = "10.10.10.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "public_subnet_cidr는 유효한 CIDR이어야 합니다. 예: 10.20.10.0/24"
  }
}

variable "zone" {
  type        = string
  description = "가용존 (예: KR-2). network/server가 동일해야 합니다."
  default     = "KR-2"

  validation {
    condition     = can(regex("^[A-Z]{2}-\\d", var.zone))
    error_message = "zone 형식이 올바르지 않습니다. 예: KR-1, KR-2"
  }
}

variable "vpc_name" {
  type        = string
  description = "VPC 표시 이름"
  default     = "ilhang-vpc"
}

variable "name_prefix" {
  type        = string
  description = "리소스 공통 접두사"
  default     = "ilhang"
}

variable "allow_ssh_cidr" {
  type        = string
  description = "SSH 허용 CIDR (운영에서는 x.x.x.x/32 권장)"
  default     = "0.0.0.0/0"

  validation {
    condition     = can(regex("\\/\\d{1,2}$", var.allow_ssh_cidr))
    error_message = "allow_ssh_cidr는 CIDR 표기를 포함해야 합니다. 예: 1.2.3.4/32"
  }
}

############################################
# Server
############################################
variable "server_name" {
  type        = string
  description = "서버 이름"
  default     = "ilhang-web-01"
}

variable "login_key_name" {
  type        = string
  description = "NCP 콘솔에 미리 생성된 로그인 키 이름"
}

variable "server_image_product_code" {
  type        = string
  description = "OS 이미지 Product Code (NCP 콘솔/카탈로그에서 복사)"
}

variable "server_product_code" {
  type        = string
  description = "서버 스펙 Product Code (NCP 콘솔/카탈로그에서 복사)"
}

variable "assign_public_ip" {
  type        = bool
  description = "퍼블릭 IP 즉시 할당 여부"
  default     = true
}

variable "generate_login_key" {
  type        = bool
  default     = false
  description = "서버 모듈이 로그인 키를 생성하고 pem을 로컬에 저장"
}

variable "pem_output_dir" {
  type        = string
  default     = "keys"
  description = "생성된 pem 저장 경로(루트 기준)"
}
############################################
# Storage (Object Storage)
############################################
variable "bucket_name" {
  type        = string
  description = "Object Storage 버킷 이름(전역 유니크 권장)"

  validation {
    # 3~63자, 소문자/숫자/하이픈, 시작/끝은 영숫자
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{1,61}[a-z0-9])?$", var.bucket_name))
    error_message = "bucket_name은 3~63자, 소문자/숫자/하이픈만 사용하고 시작/끝은 영숫자여야 합니다."
  }
}


