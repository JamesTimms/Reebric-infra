output "project_id" {
  value       = google_project.project.project_id
  description = "Project ID for dev project"
}

output "vpc_network" {
  value       = module.vpc.network_self_link
  description = "VPC Network URI reference"
}

output "vpc_name" {
  value       = module.vpc.network_name
  description = "VPC Network name"
}

output "storage_bucket" {
  value       = google_storage_bucket.project_bucket.self_link
  description = "Default project storage bucket"
}

output "startup_script" {
  value       = "gs://${google_storage_bucket_object.startup.bucket}/${google_storage_bucket_object.startup.name}"
  description = "The GS bucket location of the startup.sh"
}

output "default_sa" {
  value       = data.google_compute_default_service_account.default_sa.email
  description = "Default service account for the project"
}
