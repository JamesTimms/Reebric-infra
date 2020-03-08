variable "network_name" {}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "2.1.1"
  
  project_id   = google_project.project.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  # Temporarily using default subnets until basic Terraform structure is sorted.
  auto_create_subnetworks = "true"
  
  subnets = []
}
