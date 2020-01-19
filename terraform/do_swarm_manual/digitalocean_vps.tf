variable "do_api_token" {}
variable "do_sshkey_id" {}

provider "digitalocean" {
    token = "${var.do_api_token}"
}

locals {
  swarm_manager_count = 1
  swarm_worker_count = 2
}

resource "digitalocean_droplet" "managers" {
  count = "${local.swarm_manager_count}"
  name = "swarm-manager-${count.index}"
  image = "ubuntu-18-04-x64"
  size = "2gb"
  region = "ams3"
  ssh_keys = ["${var.do_sshkey_id}"]
}

resource "digitalocean_droplet" "workers" {
  count = "${local.swarm_worker_count}"
  name = "swarm-worker-${count.index}"
  image = "ubuntu-18-04-x64"
  size = "2gb"
  region = "ams3"
  ssh_keys = ["${var.do_sshkey_id}"]
}


