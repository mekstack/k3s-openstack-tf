module "lb" {
  source = "./loadbalancer/"

  count = var.kubeapi_lb ? 1 : 0

  name                = var.name
  public_network_name = var.public_network_name

  subnet_id = openstack_networking_subnet_v2.subnet.id
  node_ips  = openstack_compute_instance_v2.instance[*].network[0].fixed_ip_v4

  add_dns_record      = var.add_dns_record
  kubeapi_lb_dns_fqdn = var.kubeapi_lb_dns_fqdn
}
