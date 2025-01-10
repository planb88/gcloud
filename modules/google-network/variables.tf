variable "env_name" {
  type    = string
  default = ""
}

variable "ipv4_cidr" {
  type    = string
  default = "10.95.0.0/16"
}

variable "nat_ip_addresses_count" {
  type    = number
  default = 1
}

variable "root_dns_zone_name" {
  type = string
}
