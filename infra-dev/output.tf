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
