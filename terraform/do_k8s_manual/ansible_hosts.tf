## Ansible mirroring hosts section
# Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# Copy binary to ~/.terraform.d/plugins/


# [kubernetes:children]
# etcd
# k8s_masters
# k8s_nodes

# [kubernetes:vars]
# docker_version="18.06.0"
# gcp_lb_name="sm-k8s-lb"
# gcp_zone="europe-west4-b"
# gcp_region="europe-west4"

# [etcd]
# k8s_master_0

# [k8s_masters]
# k8s_master_0

# [k8s_nodes]
# k8s_worker_0
# k8s_worker_1
 


resource "ansible_host" "ansible_k8s_masters" {
  count = "${local.k8s_master_count}"
  inventory_hostname = "k8s_master_${count.index}"
  groups = ["k8s_masters", "etcd", "kubernetes"]
  vars = {
    ansible_host = "${element(digitalocean_droplet.k8s_masters.*.ipv4_address, count.index)}"
  }
}

resource "ansible_host" "ansible_k8s_nodes" {
  count = "${local.k8s_worker_count}"
  inventory_hostname = "k8s_worker_${count.index}"
  groups = ["k8s_nodes", "kubernetes"]
  vars = {
    ansible_host = "${element(digitalocean_droplet.k8s_workers.*.ipv4_address, count.index)}"
  }
}
