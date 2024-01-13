resource "openstack_networking_floatingip_v2" "kubeapi" {
  pool = var.public_network_name
}

resource "openstack_lb_loadbalancer_v2" "lb" {
  name                  = "${var.name}-kubeapi"
  vip_subnet_id         = var.subnet_id
  loadbalancer_provider = "ovn"
}

resource "openstack_networking_floatingip_associate_v2" "kubeapi" {
  floating_ip = openstack_networking_floatingip_v2.kubeapi.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id
}

// ===================== Kube API Loadbalancer ======================

resource "openstack_lb_listener_v2" "kubeapi" {
  name            = "${var.name}-kubeapi"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  protocol        = "TCP"
  protocol_port   = 6443
}

resource "openstack_lb_pool_v2" "kubeapi" {
  name        = "${var.name}-kubeapi"
  listener_id = openstack_lb_listener_v2.kubeapi.id
  protocol    = "TCP"
  lb_method   = "SOURCE_IP_PORT"
}

resource "openstack_lb_members_v2" "kubeapi" {
  pool_id = openstack_lb_pool_v2.kubeapi.id

  dynamic "member" {
    for_each = toset(var.node_ips)

    content {
      address       = member.value
      protocol_port = 6443
    }
  }
}

resource "openstack_lb_monitor_v2" "kubeapi" {
  pool_id     = openstack_lb_pool_v2.kubeapi.id
  type        = "TCP"
  delay       = 2
  timeout     = 2
  max_retries = 2
}

// ===================== SSH Port Forwarding ======================

resource "openstack_lb_listener_v2" "ssh_port_forward" {
  for_each = toset(var.node_ips)

  name            = "SSH Port Forwarding"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  protocol        = "TCP"
  protocol_port   = 2201 + index(var.node_ips, each.key)
}

resource "openstack_lb_pool_v2" "ssh_port_forward" {
  for_each = toset(var.node_ips)

  name        = "SSH Port Forwarding"
  listener_id = openstack_lb_listener_v2.ssh_port_forward[each.key].id
  protocol    = "TCP"
  lb_method   = "SOURCE_IP_PORT"
}

resource "openstack_lb_member_v2" "ssh_port_forward" {
  for_each = toset(var.node_ips)

  name          = "SSH Port Forwarding"
  pool_id       = openstack_lb_pool_v2.ssh_port_forward[each.key].id
  address       = each.value
  protocol_port = 22
}
