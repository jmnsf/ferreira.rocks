terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_zone" {
  default = "us-east1-d"
}

variable "gcp_service_account" {
  default = "devops/constant-cursor-295616-ferreira-rocks-prod-f9bc92a2b178.json"
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

provider "google" {
  project = "constant-cursor-295616"
  region  = var.gcp_region
  zone    = var.gcp_zone

  credentials = file("FerreiraRocks-542aab0986e4.json")
}

resource "google_compute_network" "default" {
  name                    = "default"
  auto_create_subnetworks = true
  description             = "Default network for the project"
}
