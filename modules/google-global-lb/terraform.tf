terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 6.15.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 6.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.6.3"
    }
  }
}
