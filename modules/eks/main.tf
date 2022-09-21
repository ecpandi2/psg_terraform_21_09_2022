# locals {

#     aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", var.enable_irsa ? concat(aws_iam_openid_connect_provider.default[*].arn, [""])[0] : null), 1)

# }

# Module calling for EKS Node group
module "eks-node-group" {
  source                        = "../node-group"
  cluster_name                  = var.cluster_name
  policy_arn                    = var.policy_arn 
  eks_nodegroup_instance_types  = var.eks_nodegroup_instance_types
  node_group_aws_iam_role       = "${var.node_group_aws_iam_role}-${var.aws_env}"
  private_subnet_ids            = var.private_subnet_ids
  eks_nodegroup_desired_size    = var.eks_nodegroup_desired_size
  eks_nodegroup_max_size        = var.eks_nodegroup_max_size
  eks_nodegroup_min_size        = var.eks_nodegroup_min_size
  
  depends_on=[aws_eks_cluster.tfs-eks]
}

# EKS cluster Creation resource
resource "aws_eks_cluster" "tfs-eks" {
  name                            = var.cluster_name
  role_arn                        = aws_iam_role.eks-iam-role.arn
  version                         = var.kubernetes_version
  tags                            = var.tags
  enabled_cluster_log_types       = var.enabled_cluster_log_types

  
  vpc_config {
    security_group_ids            = [aws_security_group.eks-cluster-sg.id]
    subnet_ids                    =  var.private_public_subnets
           }
  depends_on = [ 
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# EKS namespace creation resource
# resource "kubernetes_namespace" "eks_new" {
#   metadata {
#     annotations = {
#       name = var.eks_namespace
#     }
#     name = var.eks_namespace
#   }
# }

# Cloud watch log group creation resource for EKS cluster
resource "aws_cloudwatch_log_group" "default" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cluster_log_retention_period
  tags              = var.tags
}

/*
Get information about the TLS certificates securing a host.
Use this data source to get information, such as SHA1 fingerprint or serial number, 
about the TLS certificates that protects a URL
*/
data "tls_certificate" "cluster" {
  url   = join("", aws_eks_cluster.tfs-eks.*.identity.0.oidc.0.issuer)
}

# Creation of OIDC provider resource
resource "aws_iam_openid_connect_provider" "default" {
  url   = join("", aws_eks_cluster.tfs-eks.*.identity.0.oidc.0.issuer)
  tags  = var.tags

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [join("", data.tls_certificate.cluster.*.certificates.0.sha1_fingerprint)]
}

#
