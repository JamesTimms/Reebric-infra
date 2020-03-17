resource "google_storage_bucket" "project_bucket" {
  name          = "reebric-${var.project_name}"
  location      = "EU"
  force_destroy = false

  bucket_policy_only = true

}

resource "google_storage_bucket_object" "startup" {
  name   = "startup/startup.sh"
  source = "./startup.sh"
  bucket = google_storage_bucket.project_bucket.name
}
