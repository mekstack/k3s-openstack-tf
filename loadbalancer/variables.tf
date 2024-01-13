variable "name" {
  type = string
}

variable "public_network_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "node_ips" {
  type = list(string)
}

variable "add_dns_record" {
  type = bool
}

variable "kubeapi_lb_dns_fqdn" {
  type = string
}
