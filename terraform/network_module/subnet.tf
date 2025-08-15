#######################################
# Public Subnet
#######################################
resource "ncloud_subnet" "public" {
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.public_subnet_cidr
  zone           = var.zone
  network_acl_no  = ncloud_vpc.this.default_network_acl_no
  subnet_type    = "PUBLIC"       # 중요: PUBLIC
  usage_type     = "GEN"
  name           = "${var.name_prefix}-public"
}

#######################################
# 기본 ACG에 바로 규칙 추가
#######################################
# 별도의 ACG 리소스 생성 없이, VPC의 기본 ACG 번호에 규칙을 건다
resource "ncloud_access_control_group_rule" "default_rules" {
  access_control_group_no = ncloud_vpc.this.default_access_control_group_no

  # SSH (운영은 /32 권장)
  inbound {
    protocol    = "TCP"
    ip_block    = var.allow_ssh_cidr
    port_range  = "22"
    description = "SSH"
  }

  # HTTP / HTTPS
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "HTTP"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    description = "HTTPS"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8081"
    description = "Green"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8080"
    description = "Blue"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "6443"
    description = "kubectl"
  }

  # Outbound: all TCP
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    description = "ALL OUT"
  }
}