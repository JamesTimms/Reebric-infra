variable "region" {}
variable "zone" {}

provider "google" {
  version = "~>3.58.0"
  region  = var.region
  zone    = var.zone
}
