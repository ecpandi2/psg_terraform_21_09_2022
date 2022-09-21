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

# Data source creation for newly created EKS cluster
# data "aws_eks_cluster" "data-eks" {
#   name = var.cluster_name
#   depends_on = [
#     aws_eks_cluster.tfs-eks
#   ]
# }

# # Data source creation for newly created EKS cluster auth
# data "aws_eks_cluster_auth" "aws_iam_authenticator" {
#   name = data.aws_eks_cluster.data-eks.name
#    depends_on = [
#     aws_eks_cluster.tfs-eks
#   ]
# }

# provider "kubernetes" {
#   # if you use default value of "manage_aws_auth = true" then you need to configure the kubernetes provider as per the doc: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v12.1.0/README.md#conditional-creation, https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
#   host                   =  data.aws_eks_cluster.data-eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.data-eks.certificate_authority[0].data)
#   token                  = element(concat(data.aws_eks_cluster_auth.aws_iam_authenticator[*].token, tolist([""])), 0)
# #  load_config_file       = false # set to false unless you want to import local kubeconfig to terraform
#  exec {
#       api_version = "client.authentication.k8s.io/v1"
#       args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.data-eks.name]
#       command     = "aws"
#     }
# }

# provider "helm" {

#    kubernetes {
#        # if you use default value of "manage_aws_auth = true" then you need to configure the kubernetes provider as per the doc: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v12.1.0/README.md#conditional-creation, https://github.com/terraform-aws-modules/terraform-aws-eks/issues/91
#   # if you use default value of "manage_aws_auth = true" then you need to configure the kubernetes provider as per the doc: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v12.1.0/README.md#conditional-creation, https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
#   host                   =  data.aws_eks_cluster.data-eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.data-eks.certificate_authority[0].data)
#   token                  = element(concat(data.aws_eks_cluster_auth.aws_iam_authenticator[*].token, tolist([""])), 0)
# #  load_config_file       = false # set to false unless you want to import local kubeconfig to terraform

#  exec {
#       api_version = "client.authentication.k8s.io/v1"
#       args        = ["eks", "get-token", "--cluster-name",data.aws_eks_cluster.data-eks.name]
#       command     = "aws"

#     }
#    }
# }

/*
The http data source makes an HTTP GET request to the given URL and exports information about the response. 
*/
# data "http" "lbc_iam_policy" {

#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
#   # Optional request headers

#   request_headers = {

#     Accept = "application/json"
#   }
# }

# Resource: Create AWS Load Balancer Controller IAM Policy 
# resource "aws_iam_policy" "lbc_iam_policy" {
#   name        = "AWSLoadBalancerControllerIAMPolicy"
#   path        = "/"
#   description = "AWS Load Balancer Controller IAM Policy"
#   policy = data.http.lbc_iam_policy.body
# }

# IAM assume role resource to be used to create Ingress Load Balancer 
# resource "aws_iam_role" "lbc_iam_role" {
#   name = "eks-lbc-iam-role"

#   # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = var.enable_irsa ? concat(aws_iam_openid_connect_provider.default[*].arn, [""])[0] : null
#         }
#         Condition = {
#           StringEquals = {
#             "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud": "sts.amazonaws.com",            
#             "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }        
#       },
#     ]
#   })

#   tags = {
#     tag-key = "AWSLoadBalancerControllerIAMPolicy"
#   }
# }

# Associate Load Balanacer Controller IAM Policy to  IAM Role
# resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.lbc_iam_policy.arn 
#   role       = aws_iam_role.lbc_iam_role.name
# }

# Install AWS Load Balancer Controller using HELM

# Resource: Helm Release 
# resource "helm_release" "loadbalancer_controller" {
#   depends_on = [aws_iam_role.lbc_iam_role]            
#   name       = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"

#   namespace = "kube-system"     


#   set {
#     name = "image.repository"
#     value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller" 
#     # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
#   }       

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.lbc_iam_role.arn}"
#   }

#   set {
#     name  = "vpcId"
#     value = "${var.vpc_id}"
#   }  

#   set {
#     name  = "region"
#     value = "${var.region}"
#   }    

#   set {
#     name  = "clusterName"
#     value = "${var.cluster_name}"
#   }    
    
# }

# Resource: Kubernetes Ingress Class
# resource "kubernetes_ingress_class_v1" "ingress_class_default" {
#   depends_on = [helm_release.loadbalancer_controller]
#   metadata {
#     name = "my-aws-ingress-class"
#     annotations = {
#       "ingressclass.kubernetes.io/is-default-class" = "true"
#     }
#   }  
#   spec {
#     controller = "ingress.k8s.aws/alb"
#   }
# }

