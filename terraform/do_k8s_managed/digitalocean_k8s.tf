variable "do_api_token" {}
variable "do_sshkey_id" {}

provider "digitalocean" {
    token = "${var.do_api_token}"
}

resource "digitalocean_kubernetes_cluster" "foo" {
  name    = "foo"
  region  = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.16.2-do.2"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

# output "name" {
#   value = "value"
#   digitalocean_kubernetes_cluster.foo.kube_config[0].token
# }

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.foo.kube_config[0]
}