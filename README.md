# terraform-cidrsubnets-ratios
Terraform data module which divides a network CIDR block into dense subnets of variable size based on a ratio of arbitrary terms.

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_maximum_subnet_mask_bits"></a> [maximum\_subnet\_mask\_bits](#input\_maximum\_subnet\_mask\_bits) | Some cloud providers will not provision subnets below a certain size <br>        limit. For example, AWS does not allow subnets below /28 in size. <br>        Enforcing this restriction can have unexpected results when attempting <br>        to subnet a very small base CIDR with an aggressive type ratio, where <br>        that ratio may be impossible to honor. Those cases often result in <br>        errors if there is not enough "left over" address space. | `number` | `32` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | The base CIDR block of the network which is to subnetted. | `string` | n/a | yes |
| <a name="input_subdivisions"></a> [subdivisions](#input\_subdivisions) | For each type of subnet, create this amount of equally dense subnets.<br>        This is useful for allocating subnets among multiple fault domains,<br>        such as availability zones or datacenter pods. | `number` | `1` | no |
| <a name="input_subnet_types_ratio"></a> [subnet\_types\_ratio](#input\_subnet\_types\_ratio) | Given the network\_cidr block and the amount of subdivisions requested, <br>        use this ratio to determine the density of subnet groups relative to <br>        network\_cidr density. The way a ratio is expressed breaks subnets into <br>        "types". A ratio of the form 1:1 breaks subnets into two equally dense <br>        types, while 5:3:2 breaks subnets into three unequally dense types. | `string` | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnets of the input network\_cidr block, where elements defined in the <br>        same order subnet\_types\_ratio was defined, and then divided into equal <br>        groups according to subdivisions. |
