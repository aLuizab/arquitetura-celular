variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cell_config" {
  description = "Configuration for each cell"
  type = map(object({
    vpc_cidr             = string
    public_subnet_cidrs  = list(string)
    private_subnet_cidrs = list(string)
    availability_zones   = list(string)
    eks_version          = string
    node_instance_type   = string
    node_desired_size    = number
    node_max_size        = number
    node_min_size        = number
  }))
  default = {
    cell1 = {
      vpc_cidr             = "10.1.0.0/16"
      public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
      private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
      availability_zones   = ["us-east-2a", "us-east-2b"]
      eks_version          = "1.28"
      node_instance_type   = "t3.medium"
      node_desired_size    = 1
      node_max_size        = 2
      node_min_size        = 1
    },
    cell2 = {
      vpc_cidr            = "10.2.0.0/16"
      public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
      private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]
      availability_zones  = ["us-east-2a", "us-east-2b"]
      eks_version         = "1.28"
      node_instance_type  = "t3.medium"
      node_desired_size   = 1
      node_max_size       = 2
      node_min_size       = 1
    }
  }
}