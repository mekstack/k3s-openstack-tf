resource "openstack_dns_zone_v2" "dns_zone" {
  count = var.add_dns_record ? 1 : 0

  name        = var.kubeapi_lb_dns_fqdn
  description = "${var.name} zone"
  ttl         = 3000
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "kubeapi" {
  count = var.add_dns_record ? 1 : 0

  zone_id     = openstack_dns_zone_v2.dns_zone[0].id
  name        = var.kubeapi_lb_dns_fqdn
  description = "${var.name} Kube API Loadbalancer"
  ttl         = 3000
  type        = "A"
  records     = [openstack_networking_floatingip_v2.kubeapi.address]
}
