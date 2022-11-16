output "subnets" {
  description = <<EOT
        Subnets of the input network_cidr block, where elements are defined in 
        the same order subnet_types_ratio was defined, and then divided via 
        nested lists into equal groups according to subdivisions.
    EOT
  value       = chunklist(local.subnets, var.subdivisions)
}
