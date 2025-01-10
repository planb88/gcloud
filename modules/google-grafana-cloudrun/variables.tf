variable "service_name" {
  type    = string
  default = ""
}

variable "service_name_prefix" {
  type    = string
  default = "grafana"
}

variable "vpc_name" {
  type = string
}

variable "cloudrun_subnet_name" {
  type = string
}

variable "data_bucket_name" {
  type = string
}

variable "grafana_db_password_secret_name" {
  type    = string
  default = "grafana-db-password"
}

variable "grafana_admin_password_secret_name" {
  type    = string
  default = "grafana-admin-password"
}

variable "grafana_secret_key_secret_name" {
  type    = string
  default = "grafana-secret-key"
}

variable "grafana_db_host" {
  type = string
}

variable "grafana_db_port" {
  type    = number
  default = 5432
}

variable "grafana_db_name" {
  type    = string
  default = "grafana"
}

variable "grafana_db_user" {
  type    = string
  default = "grafana"
}

variable "grafana_container_image" {
  type    = string
  default = "grafana/grafana"
}

variable "grafana_container_image_version" {
  type    = string
  default = "11.4.0"
}

variable "grafana_container_port" {
  type    = number
  default = 3000
}

variable "grafana_liveness_probe" {
  type    = string
  default = "/login"
}

variable "whitelist_ip_ranges" {
  type    = list(string)
  default = []
}
