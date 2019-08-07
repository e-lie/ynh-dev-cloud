variable "do_api_token" {}
variable "do_sshkey_id" {}

<provider>


# Variables
locals {
  swarm_manager_count = <num> 
  swarm_worker_count = <num>
}

resource "digitalocean_droplet" "managers" {
  count = "${local.swarm_manager_count}"
  name = "swarm-manager-${count.index}"
  image = "<image>"
  size = "2gb"
  region = "ams3"
  ssh_keys = ["${var.do_sshkey_id}"]
}

resource "digitalocean_droplet" "workers" {
  count = "${local.swarm_worker_count}"
  name = "swarm-worker-${count.index}"
  image = "<image>"
  size = "1gb"
  region = "ams3"
  ssh_keys = ["${var.do_sshkey_id}"]
}

