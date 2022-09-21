variable "vpc_cidr_map" {
  type = map(string)

  default = {
    dev = "10.0.0.0/16"
    #tst = "10.122.149.0/24"
    ## dem = "10.122.150.0/24"
    #  stg = "10.122.154.0/23"
    #   pro = "10.122.156.0/22"
  }
  description = "VPC CIDR range defined for all different aws accounts"
}

variable "vpc_id_map" {
  type = map(string)
  default = {
    dev = "vpc-0b36d67d943a161e8" // Dev VPC: vpc-psg-psd-horizon-dev-2_euw1
    # tst = "vpc-09d9d8f225d00fd2c"
    # dem = "vpc-04c7935a147abe1f1"
    # stg = "vpc-079fc505af96f609b"
    #  pro = "vpc-0159af280590676e0"
  }
  description = "VPC id defined for all different aws accounts"
}

variable "amazon_eks_cluster_policy_arn" {
  type = map(string)
  default = {
    dev = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    # tst = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    # dem = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    # stg = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    # pro = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }
  description = "In built Cluster policy to be used with eks cluster IAM role"
}

variable "amazon_eks_vpc_resource_controller_arn" {
  type = map(string)
  default = {
    dev = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    # tst = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    # dem = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    # stg = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    # pro = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  }
  description = "In built AmazonEKSVPCResourceController policy to be used with eks cluster IAM role"
}

variable "public_subnets_map" {
  type = map(list(string))

  default = {
    dev = ["subnet-05ebba782aafd8c37", "subnet-07b442a4abf7d3d0a", "subnet-0bd92a7492cdc3556"]
    # tst = ["subnet-034a21c0e1ba3333d", "subnet-05d343c077166576d", "subnet-07e12869dcb7337a6"]
    # stg = ["subnet-050552df4a10b6cc2", "subnet-04b905afda4bc52c0", "subnet-098d0359d145a2b61"]
    # dem = ["subnet-0be7343d976b8214d", "subnet-0e48b317c06ffbd3d", "subnet-0ed521cb0a07d621b"]
    # pro = ["subnet-0441495ac48152574a", "subnet-00475205bfa111591"]
  }
  description = "List of public subnets for selected vpc id defiend above"
}

variable "private_subnets_map" {
  type = map(list(string))

  default = {
    dev = ["subnet-0bcb8dfe6631ebbef","subnet-0c0bbae80ecef588d","subnet-09de066809892fdb3"]
    # tst = ["subnet-05539590bc2d5ec27", "subnet-040e49c11eca8d1f7", "subnet-0e7725bd8c00af84b"]
    # stg = ["subnet-08e9c0a61d9e626a9", "subnet-0ba060fd0dea1c24c", "subnet-0e05f7e059256b459"]
    # dem = ["subnet-0685fc3892160c47b", "subnet-0aeaccd8aa14f7c19", "subnet-0e3d91e0ccacd56bb"]
    # pro = ["subnet-0a3795fd0d69634bd", "subnet-09e7b5db5ef578d53"]
  }
  description = "List of private subnets for selected vpc id defiend above"
}

variable "public_private_map" {
  type = map(list(string))

  default = {
    dev = ["subnet-05ebba782aafd8c37", "subnet-07b442a4abf7d3d0a", "subnet-0bd92a7492cdc3556","subnet-0bcb8dfe6631ebbef", "subnet-0c0bbae80ecef588d","subnet-09de066809892fdb3" ]
    #   tst = ["subnet-034a21c0e1ba3333d", "subnet-05d343c077166576d", "subnet-07e12869dcb7337a6"]
    #   stg = ["subnet-050552df4a10b6cc2", "subnet-04b905afda4bc52c0", "subnet-098d0359d145a2b61"]
    #   dem = ["subnet-0be7343d976b8214d", "subnet-0e48b317c06ffbd3d", "subnet-0ed521cb0a07d621b"]
    #   pro = ["subnet-0441495ac48152574a", "subnet-00475205bfa111591"]
  }
}

variable "policy_arn" {
  type = map(list(string))

  default = {
    dev = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    # tst = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    # stg = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    # dem = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    # pro = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  }
  description = "in built amazon worker node policy to be used with node group IAM role"
}

variable "eks_nodegroup_instance_types" {
  type = map(list(string))

  default = {
    dev = ["t3.medium"]
    # tst = ["t3.large"]
    # stg = ["t3.large"]
    # dem = ["t3.large"]
    # pro = ["t3.large"]
  }
  description = "instace type for eks node group"
}
variable "eks_nodegroup_desired_size" {
  type = map(number)

  default = {
    dev = 2
    # tst = 4
    # stg = 4
    # dem = 4
    # pro = 4
  }
  description = "desired nodes required for eks node group"
}
variable "eks_nodegroup_min_size" {
  type = map(number)

  default = {
    dev = 2
    # tst = 4
    # stg = 4
    # dem = 4
    # pro = 4
  }
  description = "min nodes required for eks node group"
}
variable "eks_nodegroup_max_size" {
  type = map(number)

  default = {
    dev = 2
    # tst = 4
    # stg = 4
    # dem = 4
    # pro = 4
  }
  description = "max nodes required for eks node group"
}


variable "cluster_name" {
  type = map(string)
  default = {
    dev = "tfs-eks-cluster"
    # tst = "tfs-eks-cluster"
    # stg = "tfs-eks-cluster"
    # dem = "tfs-eks-cluster"
    # pro = "tfs-eks-cluster"
  }
  description = "Name of the EKS cluster"
}

variable "aws_env" {
  type = map(string)
  default = {
    dev = "dev"
    # tst = "test"
    # stg = "stage"
    # dem = "demo"
    # pro = "prod"
  }
  description = "Name of the aws environments"
}

variable "cluster_log_retention_period" {
  type = map(number)

  default = {
    dev = 7
    # tst = 7
    # stg = 7
    # dem = 30
    # pro = 30
  }
  description = "Cloud watch log retention period"
}

variable "kubernetes_version" {
  type = map(string)
  default = {
    dev = "1.23"
    # tst = "1.23"
    # stg = "1.23"
    # dem = "1.23"
    # pro = "1.23"
  }
  description = "AWS EKS version"
}
variable "enabled_cluster_log_types" {
  type = map(list(string))

  default = {
    dev = ["audit"]
    # tst = ["audit"]
    # stg = ["audit"]
    # dem = ["audit"]
    # pro = ["audit"]
  }
  description = "Log type to be enabled for cloudwatch"
}
