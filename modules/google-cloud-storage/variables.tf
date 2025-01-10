variable "bucket_name" {
  type    = string
  default = ""
}

variable "bucket_name_prefix" {
  type    = string
  default = "app-storage"
}

variable "bucket_location" {
  type    = string
  default = "EU"
}

variable "bucket_force_destroy" {
  type    = bool
  default = true
}
