resource "google_storage_bucket" "tf_state" {
  name                        = "iplatform2025"
  location                    = "EU"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
