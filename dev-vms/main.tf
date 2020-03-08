variable "region" {}
variable "zone" {}

provider "google" {
  version = "~>3.9.0"
  region  = var.region
  zone    = var.zone
}

data "terraform_remote_state" "infra_dev" {
  backend = "gcs"
  
  config = {
    bucket  = "reebric-terraform-admin"
    prefix  = "terraform/state/infra-dev"
  }
}
