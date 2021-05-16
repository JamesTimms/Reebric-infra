provider "google" {
  zone    = var.zone
  region  = var.region
}

locals {
  public_subnet_cidr  = "10.0.0.0/16"
  private_subnet_cidr = "10.10.0.0/16"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.2.2"
  
  project_id   = google_project.project.project_id
  network_name = var.network_name
  routing_mode = "REGIONAL"

  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = true

  subnets = [
      {
        subnet_ip        = local.public_subnet_cidr
        subnet_name      = "public-subnet-01"
        description      = "Public IPs are allowed in this subnet"
        subnet_region    = var.region
        subnet_flow_logs = "false"
      },
      {
        subnet_ip             = local.private_subnet_cidr
        subnet_name           = "private-subnet-01"
        description           = "Only private IPs are allowed but public access is granted via the NAT gateway"
        subnet_region         = var.region
        subnet_flow_logs      = "false"
        subnet_private_access = "true"
      }
  ]

  # secondary_ranges = {
  #   public-subnet-01 = [
  #     {
  #       range_name    = "public-subnet-01-secondary-01"
  #       ip_cidr_range = "192.168.64.0/24"
  #     },
  #   ]
  # }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = true
    },
  ]
}
