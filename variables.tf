variable "network_cidr" {
  description = "CIDR block to be subnetted."
  type        = string

  validation {
    condition = regexall(
      "^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
      var.network_cidr
    ) != []
    error_message = "Value must be an IPv4 CIDR address, like 0.0.0.0/0"
  }
}

variable "subnet_types_ratio" {
  description = <<EOT
    Given the network_cidr block and the amount of subdivisions requested, 
    use this ratio to determine the density of subnet groups relative to 
    network_cidr density. The way a ratio is expressed breaks subnets into 
    "types". A ratio of the form 1:1 breaks subnets into two equally dense 
    types, while 5:3:2 breaks subnets into three unequally dense types.
    The default of 1 (or any single number) leaves all subnetting to 
    subdivisions.
    EOT
  type        = string
  default     = "1"

  validation {
    condition = regexall(
      "^[0-9]+([.0-9]+)?([:0-9]+)?([.0-9]+)?$",
      var.subnet_types_ratio
    ) != []
    error_message = <<EOT
      Value must be a single number or a colon-delimited ratio.
      EOT
  }
}

variable "subdivisions" {
  description = <<EOT
    For each type of subnet, create this amount of equally dense subnets.
    This is useful for allocating subnets among multiple fault domains,
    such as availability zones or datacenter pods.
    EOT
  type        = number
  default     = 1
}

variable "maximum_subnet_mask_bits" {
  description = <<EOT
    Some cloud providers will not provision subnets below a certain size 
    limit. For example, AWS does not allow subnets below /28 in size. 
    Enforcing this restriction can have unexpected results when attempting 
    to subnet a very small base CIDR with an aggressive type ratio, where 
    that ratio may be impossible to honor. Those cases often result in 
    errors if there is not enough "left over" address space.
    EOT
  type        = number
  default     = 32

  validation {
    condition     = var.maximum_subnet_mask_bits <= 32
    error_message = "Subnets cannot have masks beyond 32 bits in length."
  }
}
