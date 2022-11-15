locals {
    network_mask_bits = split("/", var.network_cidr)[1]

    ratio_terms = split(":", var.subnet_types_ratio)

    # Get the amount of addresses for each ratio term, divide by group count 
    # while sorting into nested lists, and convert to CIDR mask newbits. Don't 
    # let newbits drive subnet CIDRs beyond their defined minimum size limit.
    newbits = [
        for type in [
            for term in local.ratio_terms : pow(
                2,
                32 - local.network_mask_bits
            ) / sum(local.ratio_terms) * term
        ] : [
            for group in range(var.subdivisions) : ceil(
                32 - local.network_mask_bits - max(
                    32 - var.maximum_subnet_mask_bits,
                    log(type / var.subdivisions, 2)
                )
            )
        ]
    ]

    subnets = contains(
        flatten(local.newbits),
        0
    ) ? [var.network_cidr] : cidrsubnets(
        var.network_cidr, 
        flatten(local.newbits)...
    )
}
