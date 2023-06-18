# Define provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.36"
    }
  }
}



# Define Hetzner provider token
provider "hcloud" {
  token = var.hcloud_token
}

# Firewall-Rules
resource "hcloud_firewall" "myfirewall" {
  name = "my-firewall"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# Web-Server
resource "hcloud_server" "web" {
  count        = var.instances
  name         = "web-server-${count.index}"
  image        = var.os_type
  server_type  = var.server_type
  location     = var.location
  firewall_ids = [hcloud_firewall.myfirewall.id]
  ssh_keys     = [hcloud_ssh_key.default.id]
  labels = {
    type = "web"
  }
  user_data = file("user-data.yml")
}