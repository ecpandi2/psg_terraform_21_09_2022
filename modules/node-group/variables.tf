variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}
variable "policy_arn" {
  type        = list(any)
  description = "in built amazon worker node policy to be used with node group IAM role"
}
variable "eks_nodegroup_instance_types" {
  type        = list(any)
  description = "instace type for eks node group"

}
variable "node_group_aws_iam_role" {
  default     = "eks-nodegroup-iam-role"
  type        = string
  description = "node group IAM role name"
}

variable "eks_nodegroup_desired_size" {
  type        = string
  description = "desired node count"
}
variable "eks_nodegroup_max_size" {
  type        = string
  description = "max node count"
}
variable "eks_nodegroup_min_size" {
  type        = string
  description = "min node count"
}

variable "node_group_name" {
  type        = string
  default     = "eks-node-group"
  description = "Node group name"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "list of private subnets"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "Ami type for worker nodes"
}

