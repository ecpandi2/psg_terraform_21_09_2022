
locals {
  name                                   = local.env
  cluster_name                           = module.config.cluster_name[local.stage]
  amazon_eks_cluster_policy_arn          = module.config.amazon_eks_cluster_policy_arn[local.stage]
  amazon_eks_vpc_resource_controller_arn = module.config.amazon_eks_vpc_resource_controller_arn[local.stage]
  kubernetes_version                     = module.config.kubernetes_version[local.stage]
  eks_nodegroup_instance_types           = module.config.eks_nodegroup_instance_types[local.stage]
  eks_nodegroup_desired_size             = module.config.eks_nodegroup_desired_size[local.stage]
  eks_nodegroup_min_size                 = module.config.eks_nodegroup_min_size[local.stage]
  eks_nodegroup_max_size                 = module.config.eks_nodegroup_max_size[local.stage]
  policy_arn                             = module.config.policy_arn[local.stage]
  cloudwatch_log_group_name              = "/aws/eks/${module.config.cluster_name[local.stage]}/cluster"
  cluster_log_retention_period           = module.config.cluster_log_retention_period[local.stage]
  enabled_cluster_log_types              = module.config.enabled_cluster_log_types[local.stage]
  tags                                   = merge(var.tags, tomap({ "kubernetes.io/cluster/${local.name}-cluster" = "shared" }))
  vpc_id                                 = module.config.vpc_id_map[local.stage]
  vpc_cidr_block                         = module.config.vpc_cidr_map[local.stage]
  public_subnet_ids                      = module.config.public_subnets_map[local.stage]
  private_subnet_ids                     = module.config.private_subnets_map[local.stage]
  private_public_subnets                 = module.config.public_private_map[local.stage]
  aws_env                                = module.config.aws_env[local.stage]
  eks_namespace                          = "eks-new"

}

module "eks" {
  source                                 = "../../modules/eks"
  aws_env                                = local.aws_env
  #name                                   = local.name
  cluster_name                           = "${local.cluster_name}-${local.env}"
  kubernetes_version                     = local.kubernetes_version
  eks_nodegroup_instance_types           = local.eks_nodegroup_instance_types
  eks_nodegroup_desired_size             = local.eks_nodegroup_desired_size
  eks_nodegroup_min_size                 = local.eks_nodegroup_min_size
  eks_nodegroup_max_size                 = local.eks_nodegroup_max_size
  policy_arn                             = local.policy_arn
  amazon_eks_vpc_resource_controller_arn = local.amazon_eks_vpc_resource_controller_arn
  amazon_eks_cluster_policy_arn          = local.amazon_eks_cluster_policy_arn
  tags                                   = var.tags
  cloudwatch_log_group_name              = local.cloudwatch_log_group_name
  cluster_log_retention_period           = local.cluster_log_retention_period
  enabled_cluster_log_types              = local.enabled_cluster_log_types
  region                                 = local.region
  vpc_id                                 = local.vpc_id
  vpc_cidr_block                         = local.vpc_cidr_block
  public_subnet_ids                      = local.public_subnet_ids
  private_subnet_ids                     = local.private_subnet_ids
  private_public_subnets                 = local.private_public_subnets
  eks_namespace                          = local.eks_namespace
}