provider "aws" {
  region  = var.region
  profile = "sparsh"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = var.vpc_name
  cidr    = var.vpc_cidr
  azs     = ["${var.region}a", "${var.region}b"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.21.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnet_ids         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_size
      min_capacity     = var.min_size

      instance_type = var.instance_type
      subnets       = module.vpc.private_subnets
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "simple_time_service" {
  name       = var.helm_chart_name
  namespace  = var.helm_namespace
  chart      = "./helm/simple-time-service"
  
  set {
    name  = "image.repository"
    value = split(":", var.docker_image)[0]
  }

  set {
    name  = "image.tag"
    value = split(":", var.docker_image)[1]
  }
  
  values     = [file("./helm/simple-time-service/values.yaml")]
}

data "kubernetes_service" "simple_time_service" {
  metadata {
    name      = "simple-time-service"
    namespace = var.helm_namespace
  }

  depends_on = [helm_release.simple_time_service]
}
