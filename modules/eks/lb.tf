
# Resource: Create AWS Load Balancer Controller IAM Policy 
resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy = data.http.lbc_iam_policy.body
}

resource "aws_iam_role" "lbc_iam_role" {
  name = "${local.name}-lbc-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = var.enable_irsa ? concat(aws_iam_openid_connect_provider.default[*].arn, [""])[0] : null
        }
        Condition = {
          StringEquals = {
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud": "sts.amazonaws.com",            
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }        
      },
    ]
  })

  tags = {
    tag-key = "AWSLoadBalancerControllerIAMPolicy"
  }
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn 
  role       = aws_iam_role.lbc_iam_role.name
}

# Install AWS Load Balancer Controller using HELM

# Resource: Helm Release 
resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role.lbc_iam_role]            
  name       = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"     

  # Value changes based on your Region (Below is for us-east-1)
  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller" 
    # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }       

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.lbc_iam_role.arn}"
  }

  set {
    name  = "vpcId"
    value = "${var.vpc_id}"
  }  

  set {
    name  = "region"
    value = "${var.region}"
  }    

  set {
    name  = "clusterName"
    value = "${var.cluster_name}"
  }    
    
}

# # # Resource: Kubernetes Ingress Class
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

# # Terraform Kubernetes Provider
# provider "kubernetes" {
#   host                   = element(concat(aws_eks_cluster.tfs-eks.*.endpoint, tolist([""])), 0)
#   cluster_ca_certificate = base64decode(element(concat(aws_eks_cluster.tfs-eks[*].certificate_authority[0].data, tolist([""])), 0))
#   token = data.aws_eks_cluster_auth.cluster.token
# }

# ## Additional Note
# # 1. You can mark a particular IngressClass as the default for your cluster. 
# # 2. Setting the ingressclass.kubernetes.io/is-default-class annotation to true on an IngressClass resource will ensure that new Ingresses without an ingressClassName field specified will be assigned this default IngressClass.  
# # 3. Reference: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/ingress_class/

# # Resource: Create External DNS IAM Policy 
# resource "aws_iam_policy" "externaldns_iam_policy" {
#   name        = "AllowExternalDNSUpdates"
#   path        = "/"
#   description = "External DNS IAM Policy"
#   policy = jsonencode({
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "route53:ChangeResourceRecordSets"
#       ],
#       "Resource": [
#         "arn:aws:route53:::hostedzone/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "route53:ListHostedZones",
#         "route53:ListResourceRecordSets"
#       ],
#       "Resource": [
#         "*"
#       ]
#     }
#   ]
# })
# }

# # Resource: Create IAM Role 
# resource "aws_iam_role" "externaldns_iam_role" {
#   name = "${local.name}-externaldns-iam-role"

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
#             "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:default:external-dns"
#           }
#         }        
#       },
#     ]
#   })

#   tags = {
#     tag-key = "AllowExternalDNSUpdates"
#   }
# }

# # Associate External DNS IAM Policy to IAM Role
# resource "aws_iam_role_policy_attachment" "externaldns_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.externaldns_iam_policy.arn 
#   role       = aws_iam_role.externaldns_iam_role.name
# }

# # Resource: Helm Release 
# resource "helm_release" "external_dns" {
#   depends_on = [aws_iam_role.externaldns_iam_role]            
#   name       = "external-dns"

#   repository = "https://kubernetes-sigs.github.io/external-dns/"
#   chart      = "external-dns"

#   namespace = "default"     

#   set {
#     name = "image.repository"
#     value = "k8s.gcr.io/external-dns/external-dns" 
#   }       

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "external-dns"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.externaldns_iam_role.arn}"
#   }

#   set {
#     name  = "provider" # Default is aws (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
#     value = "aws"
#   }    

#   set {
#     name  = "policy" # Default is "upsert-only" which means DNS records will not get deleted even equivalent Ingress resources are deleted (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
#     value = "sync"   # "sync" will ensure that when ingress resource is deleted, equivalent DNS record in Route53 will get deleted
#   }    
        
# }# Resource: IAM Policy for Cluster Autoscaler
# resource "aws_iam_policy" "cluster_autoscaler_iam_policy" {
#   name        = "${local.name}-AmazonEKSClusterAutoscalerPolicy"
#   path        = "/"
#   description = "EKS Cluster Autoscaler Policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "autoscaling:DescribeAutoScalingGroups",
#                 "autoscaling:DescribeAutoScalingInstances",
#                 "autoscaling:DescribeInstances",
#                 "autoscaling:DescribeLaunchConfigurations",
#                 "autoscaling:DescribeTags",
#                 "autoscaling:SetDesiredCapacity",
#                 "autoscaling:TerminateInstanceInAutoScalingGroup",
#                 "ec2:DescribeLaunchTemplateVersions",
#                 "ec2:DescribeInstanceTypes"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
# })
# }

# # Resource: IAM Role for Cluster Autoscaler
# ## Create IAM Role and associate it with Cluster Autoscaler IAM Policy
# resource "aws_iam_role" "cluster_autoscaler_iam_role" {
#   name = "${local.name}-cluster-autoscaler"

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
#             "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
#           }
#         }        
#       },
#     ]
#   })

#   tags = {
#     tag-key = "cluster-autoscaler"
#   }
# }


# # Associate IAM Policy to IAM Role
# resource "aws_iam_role_policy_attachment" "cluster_autoscaler_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.cluster_autoscaler_iam_policy.arn 
#   role       = aws_iam_role.cluster_autoscaler_iam_role.name
# }

# # Install Cluster Autoscaler using HELM

# # Resource: Helm Release 
# resource "helm_release" "cluster_autoscaler_release" {
#   depends_on = [aws_iam_role.cluster_autoscaler_iam_role ]            
#   name       = "ca"

#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"

#   namespace = "kube-system"   

#   set {
#     name  = "cloudProvider"
#     value = "aws"
#   }

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = element(concat(aws_eks_cluster.tfs-eks.*.id, tolist([""])), 0)
#   }

#   set {
#     name  = "awsRegion"
#     value = var.region
#   }

#   set {
#     name  = "rbac.serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler"
#   }

#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.cluster_autoscaler_iam_role.arn}"
#   }
#   # Additional Arguments (Optional) - To Test How to pass Extra Args for Cluster Autoscaler
#   #set {
#   #  name = "extraArgs.scan-interval"
#   #  value = "20s"
#   #}    
   
# }

# # Install Kubernetes Metrics Server using HELM
# # Resource: Helm Release 
# resource "helm_release" "metrics_server_release" {
#   name       = "metrics-server"
#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace = "kube-system"   
# }

# Datasource: AWS Load Balancer Controller IAM Policy get from aws-load-balancer-controller/ GIT Repo (latest)
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}