# IAM policy to be used to create EKS cluster.
resource "aws_iam_role" "eks-iam-role" {
  name               = "${var.aws_iam_role_name_eks}-${var.aws_env}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
# }
POLICY
}
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = var.amazon_eks_cluster_policy_arn
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = var.amazon_eks_vpc_resource_controller_arn
  role       = aws_iam_role.eks-iam-role.name
}
