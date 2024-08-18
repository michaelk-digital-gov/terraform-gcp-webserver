#----------------------------------------------------------
# My Terraform
#
# Use Terraform with GCP - Google Cloud Platform
#
# Made by Michael Kravtsiv
#
#-----------------------------------------------------------
//export GOOGLE_CLOUD_KEYFILE_JSON="gcp-creds.json"
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("mygcp-creds.json")
  project     = "terraform-gcp-432819"
  region      = "us-central1"
  zone        = "us-central1-b"
}

  resource "google_compute_firewall" "web" {
    name          = "web-access-rules"
    network       = "default"
    source_ranges = ["0.0.0.0/0"]
    allow {
      protocol = "tcp"
      ports    = ["80", "443"]
    }
  }

  resource "google_compute_instance" "my_web_server" {
  name         = "my-gcp-web-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = <<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
echo "<h2>Shabak Shalom this is WebServer on GCP Build with Terraform by Michael Kravtsiv<h2>" > /var/www/html/index.html
systemctl restart apache2
EOF
  
  depends_on = [google_compute_firewall.web]
}
