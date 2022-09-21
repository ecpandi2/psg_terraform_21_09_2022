variable "aws_iam_role_name_eks" {
  default     = "eks-cluster-role"
  description = "Name of IAM policy for EKS cluster"
}

variable "amazon_eks_cluster_policy_arn" {
  description = "In built Cluster policy to be used with eks cluster IAM role"
}

variable "amazon_eks_vpc_resource_controller_arn" {
  description = "In built AmazonEKSVPCResourceController policy to be used with eks cluster IAM role"
}

variable "aws_security_group_eks" {
  description = "Name of the security group for eks cluster"
  default     = "eks-cluster-sg"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}
variable "kubernetes_version" {
  type        = string
  description = "kubernets verison"
}

variable "egress_from_port" {
  type        = number
  default     = 0
  description = "outbound rule for eks security group"
}
variable "egress_to_port" {
  type        = number
  default     = 0
  description = "outbound rule for eks security group"
}

variable "policy_arn" {
  type        = list(string)
  description = "in built amazon worker node policy to be used with node group IAM role"
}

variable "eks_nodegroup_instance_types" {
  type        = list(any)
  description = "instace type for eks node group"
}

variable "node_group_aws_iam_role" {
  default     = "eks-nodegroup-role"
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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}
variable "cloudwatch_log_group_name" {
  type        = string
  description = "Cloud watch logs group name"
}
variable "cluster_log_retention_period" {
  type        = number
  description = "Cloud watch logs retention period"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "region" {
  type        = string
  description = "aws region"
}
variable "enable_irsa" {
  type        = bool
  default     = true
  description = "enable_irsa true or false"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
}

variable "vpc_id" {
  type        = string
  description = "aws vpcid"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "public subnet ids"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "private subnet ids"
}

variable "private_public_subnets" {
  type        = list(string)
  description = "private and subnet ids"
}

variable "aws_env" {
  type        = string
  description = "aws environments"
}

variable "eks_namespace" {
  type = string
}

# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "SAP"
}

variable "storage_size" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "4Gi"
}