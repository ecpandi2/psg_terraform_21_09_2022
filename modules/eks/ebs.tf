# #  locals {
# #    name = "ebs"
# #  }
# resource "aws_iam_policy" "ebs_csi_iam_policy" {
#   name        = "${local.name}-AmazonEKS_EBS_CSI_Driver_Policy"
#   path        = "/"
#   description = "EBS CSI IAM Policy"
#   policy = data.http.ebs_csi_iam_policy.body
# }

# locals {
#     aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", var.enable_irsa ? concat(aws_iam_openid_connect_provider.default[*].arn, [""])[0] : null), 1)
# }

# # Resource: Create IAM Role and associate the EBS IAM Policy to it
# resource "aws_iam_role" "ebs_csi_iam_role" {
#   name = "${local.name}-ebs-csi-iam-role"

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
#            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#           }
#         }        

#       },
#     ]
#   })

#   tags = {
#     tag-key = "${local.name}-ebs-csi-iam-role"
#   }
# }

# # Associate EBS CSI IAM Policy to EBS CSI IAM Role
# resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn 
#   role       = aws_iam_role.ebs_csi_iam_role.name
# }

# # Install EBS CSI Driver using HELM
# # Resource: Helm Release 
# resource "helm_release" "ebs_csi_driver" {
#   depends_on = [
#     #aws_eks_node_group.eks_ng_1,
#     #aws_iam_openid_connect_provider.oidc_provider,
#     aws_iam_role.ebs_csi_iam_role
#   ]
#   name       = "aws-ebs-csi-driver"

#   repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
#   chart      = "aws-ebs-csi-driver"

#   namespace = "kube-system"     

#   set {
#     name = "image.repository"
#     value = "public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver" # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
#   }       

#   set {
#     name  = "controller.serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = "ebs-csi-controller-sa"
#   }

#   set {
#     name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.ebs_csi_iam_role.arn}"
#   }
    
# }

# data "http" "ebs_csi_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

#   # Optional request headers
#   request_headers = {
#     Accept = "application/json"
#   }
# }

# # Datasource: EKS Cluster Auth 
# data "aws_eks_cluster_auth" "cluster" {
#   name = element(concat(aws_eks_cluster.tfs-eks.*.id, tolist([""])), 0)
# }

# # HELM Provider
# provider "helm" {
#   kubernetes {
#     host                   = element(concat(aws_eks_cluster.tfs-eks.*.endpoint, tolist([""])), 0)
#     cluster_ca_certificate = base64decode(element(concat(aws_eks_cluster.tfs-eks[*].certificate_authority[0].data, tolist([""])), 0))
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }