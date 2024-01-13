resource "openstack_compute_servergroup_v2" "servergroup" {
  name     = var.name
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "instance" {
  count = var.master_node_count

  name            = "${var.name}-${count.index + 1}"
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]
  user_data = templatefile("${path.module}/user-data.yaml.tftpl", {
    k3s_token = random_password.k3s_token.result
    timezone  = var.timezone
    args = join(" ", [
      (
        count.index == 0 ?
        "--cluster-init" :
        "--server https://10.0.0.11:6443"
      ),
      var.kubeapi_lb ? "--tls-san=${module.lb[0].kubeapi_lb_fip},${var.kubeapi_lb_dns_fqdn}" : "",
    ])
  })

  network {
    uuid        = openstack_networking_network_v2.network.id
    fixed_ip_v4 = "10.0.0.${count.index + 11}"
  }

  scheduler_hints {
    group = openstack_compute_servergroup_v2.servergroup.id
  }

  depends_on = [openstack_networking_subnet_v2.subnet]
}
