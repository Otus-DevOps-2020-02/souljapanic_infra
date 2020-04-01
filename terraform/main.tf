terraform {
  required_version = "0.12.24"
}

provider "google" {
  version = "2.15"

#  project = "infra-271907"
  project = var.project

#  region = "europe-west-1"
  region = var.region
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-d"
  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
#      image = "reddit-base"
#      image = "reddit-base-1585578160"
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
#    ssh-keys = "den_pirozhkov:${file("~/.ssh/id_rsa.pub")}"
    ssh-keys = "den_pirozhkov:${file(var.public_key_path)}"
  }

  connection {
    type = "ssh"
    host = self.network_interface[0].access_config[0].nat_ip
    user = "den_pirozhkov"
    agent = false
    private_key = file("~/.ssh/den_pirozhkov")
  }

  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}