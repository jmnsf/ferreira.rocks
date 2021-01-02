resource "google_compute_instance" "vm_instance" {
  name         = "ferreira-rocks"
  machine_type = "f1-micro"
  zone         = var.gcp_zone

  deletion_protection = false

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

  provisioner "file" {
    source      = var.gcp_service_account
    destination = "~/"
  }
}

resource "google_compute_firewall" "default_allow_icmp" {
  name        = "default-allow-icmp"
  network     = google_compute_network.default.self_link
  description = "Allow ICMP from anywhere"
  priority    = 65534

  allow {
    ports    = []
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "default_allow_internal" {
  name        = "default-allow-internal"
  network     = google_compute_network.default.self_link
  description = "Allow internal traffic on the default network"
  priority    = 65534

  source_ranges = [
    "10.128.0.0/9",
  ]

  allow {
    ports = [
      "0-65535",
    ]
    protocol = "tcp"
  }

  allow {
    ports = [
      "0-65535",
    ]
    protocol = "udp"
  }

  allow {
    ports    = []
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "default_allow_rdp" {
  name        = "default-allow-rdp"
  network     = google_compute_network.default.self_link
  description = "Allow RDP from anywhere"
  priority    = 65534

  allow {
    ports = [
      "3389",
    ]
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "default_allow_ssh" {
  name        = "default-allow-ssh"
  network     = google_compute_network.default.self_link
  description = "Allow SSH from anywhere"
  priority    = 65534

  allow {
    ports = [
      "22",
    ]
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.default.self_link

  allow {
    ports = [
      "80"
    ]
    protocol = "tcp"
  }
}
