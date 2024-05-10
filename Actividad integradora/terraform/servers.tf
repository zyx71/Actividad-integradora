terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

variable "servers_count" {
  description = "Cantidad de servidores para producción."
}
variable "digitalocean_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  email = var.cloudflare_email

}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-14-04-x64"
  count    = var.servers_count
  name     = format("web-%02d", count.index)
  region   = "nyc2"
  size     = "1gb"
}





