terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.cell["cell1"].eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.cell["cell1"].eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.cell["cell1"].eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.cell["cell1"].eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cell["cell1"].eks_cluster_id
}