variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project = google_project.project.project_id
  disable_on_destroy = false
}

resource "google_compute_project_metadata" "metadata" {
  project = google_project.project.project_id 
  metadata = {
    startup-script-url = "${google_storage_bucket.project_bucket.url}/${google_storage_bucket_object.startup.output_name}"
    ssh-keys = <<EOF
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7zOql9P4RtKMk0Adh3OwRBCgqmyjqD2tHIJ6Zq/NIu james@home
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPceeomxGZ5P+BFM8JK4r4lmXzzVVVFkiWBbhGw3nVzn james@home2
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpt9lI0ol2EGdQd7o2SuhjYwxk2P4uGkiFUgqvpqZfB james@beepboop
EOF
  }
}
