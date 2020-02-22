data "google_compute_zones" "available" {}
variable "network_name" {}

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  project                 = google_project.project.project_id
  auto_create_subnetworks = "true"
}

resource "google_compute_instance" "vm_instance" {
  project      = google_project.project.project_id
  zone         = var.zone
  name         = "tf-compute-1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network       = "${google_compute_network.vpc_network.self_link}"
    access_config {
      #Ephemeral IP
    }
  }
}

output "instance_id" {
  value = google_compute_instance.vm_instance.self_link
}
