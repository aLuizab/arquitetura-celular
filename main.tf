module "cell" {
  for_each = var.cell_config
  source   = "./modules/cell"

  cell_name             = each.key
  vpc_cidr              = each.value.vpc_cidr
  public_subnet_cidrs   = each.value.public_subnet_cidrs
  private_subnet_cidrs  = each.value.private_subnet_cidrs
  availability_zones    = each.value.availability_zones
  environment           = var.environment
  eks_version           = each.value.eks_version
  node_instance_type    = each.value.node_instance_type
  node_desired_size     = each.value.node_desired_size
  node_max_size         = each.value.node_max_size
  node_min_size         = each.value.node_min_size
}