resource "random_integer" "index" {
  min = 10
  max = 99
}

locals {
  service_name = var.service_name == "" ? "${var.service_name_prefix}${random_integer.index.result}" : var.service_name
}
