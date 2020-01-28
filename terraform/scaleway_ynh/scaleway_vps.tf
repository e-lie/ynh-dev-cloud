variable "scaleway_api_secret_key" {}
variable "scaleway_api_access_key" {}
variable "scaleway_orga_id" {}

provider "scaleway" {
  access_key      = var.scaleway_api_access_key
  secret_key      = var.scaleway_api_secret_key
  organization_id = var.scaleway_orga_id
  zone            = "fr-par-1"
  region          = "fr-par"
}


locals {
  vps_count = 1
}

resource "scaleway_instance_ip" "ynh_vps_ips" {
  count = local.vps_count
}

resource "scaleway_instance_server" "ynh_vps" {
  count = local.vps_count
  name  = "ynh_vps_${count.index}"
  // Debian (mini) stretch (25GB) image id (got using curl on api GET /images)
  image = "b7382648-2a93-43bc-88e1-55a6f27ccd22"
  ip_id = "${element(scaleway_instance_ip.ynh_vps_ips.*.id, count.index)}"
  type  = "START1-XS"
  # scaleway automatically add available ssh keys from the account to every server (no need to do it manually)
}

data "scaleway_instance_image" "debian_stretch" {
  name  = "Debian Stretch"
}

output "debian_image" {
  value = data.scaleway_instance_image.debian_stretch
}
