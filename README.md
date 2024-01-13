# K3s-OpenStack terraform module

This module deploys a K3s cluster (1 or more nodes) on OpenStack cloud.
LBaaS provider is OVN.

# Examples

To import this module you can use the following

```tf
module "k3s" {
  source = "github.com/mekstack/k3s-openstack-tf/"

  name                = "k3s-prod"
  key_pair            = "admins"
  master_node_count   = 3
  image_id            = data.openstack_images_image_v2.ubuntu.id
  public_network_name = "public"
  flavor_name         = "m2s.large"
  kubeapi_lb          = true
  add_dns_record      = true
  kubeapi_lb_dns_fqdn = "kube3.local."
}
```
