
output "vpc_cidr_map" {
  value = var.vpc_cidr_map
}

output "vpc_id_map" {
  value = var.vpc_id_map
}

output "amazon_eks_cluster_policy_arn" {
  value = var.amazon_eks_cluster_policy_arn
}

output "amazon_eks_vpc_resource_controller_arn" {
  value = var.amazon_eks_vpc_resource_controller_arn
}

output "public_subnets_map" {
  value = var.public_subnets_map
}

output "private_subnets_map" {
  value = var.private_subnets_map
}

output "policy_arn" {
  value = var.policy_arn
}


output "eks_nodegroup_instance_types" {
  value = var.eks_nodegroup_instance_types
}

output "eks_nodegroup_desired_size" {
  value = var.eks_nodegroup_desired_size
}

output "eks_nodegroup_min_size" {
  value = var.eks_nodegroup_min_size
}

output "eks_nodegroup_max_size" {
  value = var.eks_nodegroup_max_size
}



output "cluster_name" {
  value = var.cluster_name
}


output "cluster_log_retention_period" {
  value = var.cluster_log_retention_period
}


output "kubernetes_version" {
  value = var.kubernetes_version
}

output "enabled_cluster_log_types" {
  value = var.enabled_cluster_log_types
}

output "aws_env" {
  value = var.aws_env
}

output "public_private_map" {
  value = var.public_private_map
}