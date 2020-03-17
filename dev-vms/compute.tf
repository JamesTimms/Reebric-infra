resource "google_compute_instance" "vm_instance" {
  project         = "${data.terraform_remote_state.infra_dev.outputs.project_id}"
  zone            = var.zone
  name            = "gcp-dev"
  machine_type    = "f1-micro"

  service_account {
    email  = "${data.terraform_remote_state.infra_dev.outputs.default_sa}"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  allow_stopping_for_update = false

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

  network_interface {
    network       = "${data.terraform_remote_state.infra_dev.outputs.vpc_network}"
    access_config {
      #Ephemeral IP
    }
  }
}
