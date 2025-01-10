terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 6.12.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 6.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.6.3"
    }
  }
}
