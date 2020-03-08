terraform {
 backend "gcs" {
   bucket  = "reebric-terraform-admin"
   prefix  = "terraform/state/dev-vms"
 }
}
