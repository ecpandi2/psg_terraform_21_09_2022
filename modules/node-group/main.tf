#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#
resource "aws_iam_role" "node-group-iam-role" {
  name = var.node_group_aws_iam_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = var.policy_arn[0]
  role       = aws_iam_role.node-group-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = var.policy_arn[1]
  role       = aws_iam_role.node-group-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.policy_arn[2]
  role       = aws_iam_role.node-group-iam-role.name
}

resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node-group-iam-role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.eks_nodegroup_instance_types
  ami_type        = var.ami_type

  scaling_config {
    desired_size = var.eks_nodegroup_desired_size
    max_size     = var.eks_nodegroup_max_size
    min_size     = var.eks_nodegroup_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}
