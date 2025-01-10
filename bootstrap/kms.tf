resource "google_kms_key_ring" "ip_keyring" {
  name     = "ip-keyring"
  location = "europe"
}

resource "google_kms_crypto_key" "iac" {
  name     = "ip-iac"
  key_ring = google_kms_key_ring.ip_keyring.id
}

output "iac_kms_crypto_key_id" {
  value = google_kms_crypto_key.iac.id
}
