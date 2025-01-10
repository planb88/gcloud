variable "env_name" {
  type    = string
  default = ""
}

variable "dns_zone_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "backend_services_id" {
  type = string
}

variable "certificate_id" {
  type = string
}
