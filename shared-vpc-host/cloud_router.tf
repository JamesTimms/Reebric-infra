resource "google_compute_address" "nat_ip" {
  name        = "${module.vpc.network_name}-nat-ip"
  region      = var.region
  project     = google_project.project.project_id # Must specify as project is created during apply
  description = "Public IP address for the NAT Gateway"
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 1.0"

  name    = "${module.vpc.network_name}-cloud-router"
  region  = var.region
  project = google_project.project.project_id
  network = module.vpc.network_name

  bgp = {
    asn                 = 64514
    advertised_groups   = []
    advertised_ip_ranges = [{
      range       = local.private_subnet_cidr
      description = "Restrict NAT access to the private subnet only"
    }]
  }

  nats = [{
    name                               = "${module.vpc.network_name}-nat-gateway"
    nat_ips                            = [google_compute_address.nat_ip.self_link] # Needs resource link, not IP.
    nat_ip_allocation_options          = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [{
      name                    = "private-subnet-01"
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }]
  }]
}
