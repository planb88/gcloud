locals {
  gcp_kms_encryption_key = "projects/aaheiev-335511/locations/europe/keyRings/ip-keyring/cryptoKeys/ip-iac"
}

generate "encryption" {
  path      = "encryption.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  encryption {
    key_provider "gcp_kms" "gcp" {
      kms_encryption_key = "${local.gcp_kms_encryption_key}"
      key_length         = 32
    }
    method "aes_gcm" "aes_gcm" {
      keys = key_provider.gcp_kms.gcp
    }
    state {
      enforced = true
      method   = method.aes_gcm.aes_gcm
    }
    plan {
      enforced = true
      method   = method.aes_gcm.aes_gcm
    }
  }
}
EOF
}
