resource "google_compute_instance" "vm_instance" {
  project      = "${data.terraform_remote_state.infra_dev.outputs.project_id}"
  zone         = var.zone
  name         = "tf-compute-1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network       = "${data.terraform_remote_state.infra_dev.outputs.vpc_network}"
    access_config {
      #Ephemeral IP
    }
  }
}
