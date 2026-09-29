module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.31"

  # Public and private API endpoint access allow karta hai taaki local machine & nodes dono connect ho sakein
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Admin access grant karein current IAM user ko taaki authentication error na aaye
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    stable_nodes = {
      name         = "${var.project_name}-ng"
      
      # t3.small ya t3.medium EKS bootstrap ko fail hone se rokta hai
      instance_types = ["t3.small"] 

      min_size     = 1
      max_size     = 2
      desired_size = 1   # Start me 1 node rakhein taaki resource limit exceed na ho

      # Node ke liye standard Amazon Linux 2023 / AL2 AMI
      ami_type     = "AL2_x86_64"
      capacity_type = "ON_DEMAND"

      # Node ko public subnet ke bajaye private me run karein NAT gateway ke through
      subnet_ids = module.vpc.private_subnets

      # AWS Managed Node Group IAM policies auto-attach
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
    }
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}