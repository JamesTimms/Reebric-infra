# locals {
#   net_data_users = compact(concat(
#     var.service_project_owners,
#     ["serviceAccount:${var.service_project_number}@cloudservices.gserviceaccount.com"]
#   ))
# }

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.2.2"
  
  project_id   = google_project.project.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
      {
        subnet_ip     = "10.10.10.0/24"
        subnet_name   = "public-subnet-01"
        subnet_region = "europe-west2"
      },
      {
        subnet_ip             = "10.10.20.0/24"
        subnet_name           = "private-subnet-01"
        description           = "This subnet has a description"
        subnet_region         = "europe-west2"
        # subnet_flow_logs      = "true"
        # subnet_private_access = "true"
      }
  ]

  secondary_ranges = {
    public-subnet-01 = [
      {
        range_name    = "public-subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
  }

  routes = [
    {
      name                   = "egress-internet"
      tags                   = "egress-inet"
      description            = "route through IGW to access internet"
      destination_range      = "0.0.0.0/0"
      next_hop_internet      = "true"
    },
  ]
}

# module "net-svpc-access" {
#   source  = "terraform-google-modules/network/google//modules/fabric-net-svpc-access"
#   version = "3.2.2"

#   host_project_id     = module.net-vpc-shared.project_id
#   service_project_num = count(var.service_project_ids)
#   service_project_ids = var.service_project_ids
#   host_subnets        = ["data"]
#   host_subnet_regions = ["europe-west1"]
#   host_subnet_users = {
#     data = join(",", local.net_data_users)
#   }
# }

# resource "google_compute_shared_vpc_host_project" "host" {
#   project = var.host_project_id
# }

# resource "google_compute_shared_vpc_service_project" "services" {
#   for_each = var.service_project_ids

#   service_project = var.service_project
#   host_project    = google_compute_shared_vpc_host_project.host.project
# }


