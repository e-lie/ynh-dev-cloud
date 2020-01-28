## Ansible mirroring hosts section
# Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# Copy binary to ~/.terraform.d/plugins/

resource "ansible_host" "ansible_ynh_vps" {
  count = "${local.vps_count}"
  inventory_hostname = "ansible_ynh_${count.index}"
  groups = ["yunohost", "scaleway"]
  vars = {
    ansible_host = "${element(scaleway_instance_ip.ynh_vps_ips.*.address, count.index)}"
  }
}


