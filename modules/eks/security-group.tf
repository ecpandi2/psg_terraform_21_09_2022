# Security group resource creation for EKS cluster. It inclused Inbound(Ingress) and Outbound(Egres) rules.
resource "aws_security_group" "eks-cluster-sg" {
  name        = "${var.aws_security_group_eks}-${var.aws_env}"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id
  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_to_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = tolist([var.vpc_cidr_block])
  }
  tags = {
    Name = "eks cluster ${var.aws_env}"
  }
}
