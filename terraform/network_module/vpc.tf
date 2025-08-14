resource "ncloud_vpc" "this" {
  ipv4_cidr_block = var.vpc_cidr
  name            = var.vpc_name
}