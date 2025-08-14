variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR, e.g. 10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR, e.g. 10.20.10.0/24"
}

variable "zone" {
  type        = string
  description = "Availability zone, e.g. KR-2"
}

variable "vpc_name" {
  type        = string
  description = "VPC display name"
}

variable "name_prefix" {
  type        = string
  description = "Common name prefix for resources"
}

variable "allow_ssh_cidr" {
  type        = string
  description = "SSH allowlist CIDR (use /32 in prod)"
}
