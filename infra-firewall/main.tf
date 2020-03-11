variable "home_ip" {}

provider "google" {
  version = "~>3.9.0"
}

provider "null" {
  version = "~> 2.1"
}

module "net-firewall" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = "${data.terraform_remote_state.infra_dev.outputs.project_id}"
  network                 = "${data.terraform_remote_state.infra_dev.outputs.vpc_name}"
  internal_ranges_enabled = true
  internal_ranges         = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  custom_rules = {
    reebric-home-all-ssh-allow = {
      description          = "Allow SSH from home IP to all instances."
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["${var.home_ip}"]
      sources              = null
      targets              = null
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = [22]
        }
      ]
      extra_attributes = {}
    }
    reebric-internal-all-icmp-allow = {
      description          = "Allow pings from all internal IPs."
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
      sources              = null
      targets              = null
      use_service_accounts = false
      rules = [
        {
          protocol = "icmp"
          ports    = null
        }
      ]
      extra_attributes = {}
    }
    reebric-internal-allow-all = {
      description          = "Allow all TCP and UDP internal traffic."
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
      sources              = null
      targets              = null
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        }
      ]
      extra_attributes = {} 
    }
  }
}

data "terraform_remote_state" "infra_dev" {
  backend = "gcs"
  config = {
    bucket  = "reebric-terraform-admin"
    prefix  = "terraform/state/infra-dev"
  }
}
