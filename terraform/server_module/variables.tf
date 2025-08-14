variable "subnet_no" {
  type        = string
  description = "Target subnet (module.network_module.public_subnet_no)"
}

variable "zone" {
  type        = string
  description = "Same zone as subnet (e.g., KR-2)"
}

variable "server_name" {
  type        = string
  description = "Server name"
}

variable "server_image_product_code" {
  type        = string
  description = "OS image product code"
}

variable "server_product_code" {
  type        = string
  description = "Server spec product code"
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to attach public IP immediately"
  default     = true
}

variable "user_data" {
  type        = string
  description = "Cloud-init user data (optional)"
  default     = null
}

variable "login_key_name" {
  type        = string
  description = "NCP 로그인 키 이름. generate_login_key=true면 이 이름으로 생성됨"
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

