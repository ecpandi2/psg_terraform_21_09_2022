# EKS cluster OIDC provider URL
output "aws_iam_oidc_connect_provider_extract_from_arn" {
  description = "List of IDs of VPC private subnets"
  value       = aws_iam_openid_connect_provider.default.arn
}

# EKS cluster OIDC provider
output "aws_iam_openid_connect_provider" {
  description = "List of IDs of VPC private subnets"
  value       = aws_iam_openid_connect_provider.default
}
output "ebs_csi_iam_policy" {
  value = data.http.ebs_csi_iam_policy.body
}

output "ebs_csi_iam_role_arn" {
  description = "EBS CSI IAM Role ARN"
  value = aws_iam_role.ebs_csi_iam_role.arn
}

# EBS CSI Helm Release Outputs
output "ebs_csi_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.ebs_csi_driver.metadata
}

output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.body
}

output "lbc_iam_policy_arn" {
  value = aws_iam_policy.lbc_iam_policy.arn 
}

output "lbc_iam_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"
  value = aws_iam_role.lbc_iam_role.arn
}

# Helm Release Outputs
output "lbc_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.loadbalancer_controller.metadata
}

output "externaldns_iam_policy_arn" {
  value = aws_iam_policy.externaldns_iam_policy.arn 
} 

output "externaldns_iam_role_arn" {
  description = "External DNS IAM Role ARN"
  value = aws_iam_role.externaldns_iam_role.arn
}

# Helm Release Outputs
output "externaldns_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.external_dns.metadata
}

output "cluster_autoscaler_iam_role_arn" {
  description = "Cluster Autoscaler IAM Role ARN"
  value = aws_iam_role.cluster_autoscaler_iam_role.arn
}

# Helm Release Outputs
output "cluster_autoscaler_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.cluster_autoscaler_release.metadata
}

# Helm Release Outputs
output "metrics_server_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.metrics_server_release.metadata
}