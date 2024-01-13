output "kubeapi_lb_fip" {
  value = openstack_networking_floatingip_v2.kubeapi.address
}

output "kubeapi_a_record_name" {
  value = openstack_dns_recordset_v2.kubeapi[0].name
}
