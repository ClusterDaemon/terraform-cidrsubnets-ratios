output "subnets" {
    description = <<EOT
        Subnets of the input network_cidr block, where elements defined in the 
        same order subnet_types_ratio was defined, and then divided into equal 
        groups according to subdivisions.
    EOT
    value = chunklist(local.subnets, var.subdivisions)
}
