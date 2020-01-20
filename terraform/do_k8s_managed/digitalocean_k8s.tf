variable "do_api_token" {}
variable "do_sshkey_id" {}

provider "digitalocean" {
    token = "${var.do_api_token}"
}

resource "digitalocean_kubernetes_cluster" "foo" { # }"tp_cluster" {
  name    = "k8s-tp-cluster"
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

resource "local_file" "kubeconfigdo" {
  content  = digitalocean_kubernetes_cluster.foo.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig_do"
}

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.foo.kube_config[0].raw_config
}