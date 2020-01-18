## Ansible mirroring hosts section
# Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# Copy binary to ~/.terraform.d/plugins/

resource "ansible_host" "ansible_managers" {
  count = "${local.swarm_manager_count}"
  inventory_hostname = "manager_${count.index}"
  groups = ["docker_swarm_manager", "swarm_nodes"]
  vars = {
    ansible_host = "${element(digitalocean_droplet.managers.*.ipv4_address, count.index)}"
  }
}

resource "ansible_host" "ansible_workers" {
  count = "${local.swarm_worker_count}"
  inventory_hostname = "worker_${count.index}"
  groups = ["docker_swarm_worker", "swarm_nodes"]
  vars = {
    ansible_host = "${element(digitalocean_droplet.workers.*.ipv4_address, count.index)}"
  }
}