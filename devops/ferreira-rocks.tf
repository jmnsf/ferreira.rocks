resource "google_compute_instance" "vm_instance" {
  name         = "ferreira-rocks"
  machine_type = "f1-micro"
  zone         = var.gcp_zone

  deletion_protection = true

  boot_disk {
    auto_delete = false

    initialize_params {
      image = "debian-cloud/debian-10"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.default.self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "jmnsf:${file(var.pub_key)}"
  }

  metadata_startup_script = <<EOT
  export PATH=$PATH:/usr/bin
  sudo apt update
  sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

  sudo apt update
  sudo apt -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io

  sudo curl \
    -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

  sudo chmod +x /usr/local/bin/docker-compose

  sudo usermod -aG docker $USER
  EOT
}
