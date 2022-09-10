resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc_network.self_link
  region        = "europe-west1"
}

resource "google_compute_network" "vpc_network" {
  name = "custom-vpc-network"
}

resource "google_compute_instance" "default" {
  name                      = "instance-1"
  machine_type              = "f1-micro"
  zone                      = "europe-west1-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.custom_subnet.self_link

    access_config {
      //   Ephemeral   IP
    }
  }
}
