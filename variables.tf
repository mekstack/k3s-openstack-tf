variable "name" {
  type        = string
  description = "Name for the created resources"
  default     = "k3s-mekstack"
}

variable "master_node_count" {
  type        = number
  description = "Number of nodes, must be an odd number"

  validation {
    condition     = var.master_node_count % 2 == 1
    error_message = "The node count must be an odd number."
  }
}

variable "key_pair" {
  type        = string
  description = "Name of the keypair to pass to instances"
}

variable "image_id" {
  type = string
}

variable "public_network_name" {
  type        = string
  description = "Public network name"
}

variable "flavor_name" {
  type = string
}

variable "kubeapi_lb" {
  type        = bool
  description = "Whether to deploy loadbalancer for kubernetes api"
  default     = true
}

variable "add_dns_record" {
  type        = bool
  description = "Whether to deploy designate DNS zone and record that will point to Kube API loadbalancer fip"
  default     = true
}

variable "kubeapi_lb_dns_fqdn" {
  type        = string
  description = "DNS zone that will point to Kube API loadbalancer fip. Must end with a dot"
  default     = ""
}
