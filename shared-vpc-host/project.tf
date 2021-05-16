resource "random_id" "id" {
  prefix      = var.project_name
  byte_length = 4
}

resource "google_project" "project" {
  name            = var.project_name
  org_id          = var.org_id
  project_id      = random_id.id.hex
  billing_account = var.billing_account
}

resource "google_project_service" "service" {
  for_each = toset([
    "iam.googleapis.com",
    "compute.googleapis.com"
  ])

  service = each.key
  project = google_project.project.project_id

  disable_on_destroy = false
}

data "google_compute_default_service_account" "default_sa" {
  project = google_project.project.project_id  
}
