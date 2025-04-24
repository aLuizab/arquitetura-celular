#### AI-assisted development

# AWS Cell-Based Infrastructure with Terraform

## Project Overview

This Terraform project implements a cell-based architecture on AWS, where each "cell" is an independent unit containing a complete set of infrastructure components. The architecture is designed for high availability across multiple Availability Zones (AZs).

### Key Features

- **Cell-based design**: Two independent cells (cell1 and cell2) in different AZs
- **Each cell contains**:
  - VPC with public and private subnets
  - NAT gateways for private subnet internet access
  - EKS cluster with managed node group
  - Application Load Balancer (ALB)
  - EC2 instance in public subnet
- **Infrastructure as Code**: Fully automated provisioning with Terraform
- **Modular design**: Easy to extend or modify components

## Prerequisites

Before using this project, ensure you have:

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (v1.3.0 or later)
3. **AWS CLI** installed and configured
4. **kubectl** installed (for interacting with EKS clusters)
5. **SSH key pair** in `~/.ssh/id_rsa.pub` (or modify the key path in compute.tf)

## Project Structure

```
terraform-aws-cell-architecture/
├── main.tf                 # Root module configuration
├── variables.tf            # Global variables
├── outputs.tf              # Global outputs
├── terraform.tfvars        # Variable definitions
├── providers.tf            # Provider configuration
├── modules/
│   ├── cell/               # Cell module (reusable unit)
│   │   ├── main.tf         # Cell resources
│   │   ├── variables.tf    # Cell inputs
│   │   ├── outputs.tf      # Cell outputs
│   │   ├── vpc.tf          # VPC configuration
│   │   ├── eks.tf          # EKS configuration
│   │   ├── networking.tf   # Networking components
│   │   └── compute.tf      # EC2 instances
└── README.md               # This file
```

## Getting Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/aLuizab/arquitetura-celular.git
cd arquitetura-celular
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Review and Customize Configuration

Edit `terraform.tfvars` to customize your deployment:

```hcl
aws_region = "us-west-2"
environment = "dev"

cell_config = {
  cell1 = {
    vpc_cidr            = "10.1.0.0/16"
    public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
    private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
    availability_zones  = ["us-west-2a", "us-west-2b"]
    eks_version         = "1.28"
    node_instance_type  = "t3.medium"
    node_desired_size   = 1
    node_max_size       = 2
    node_min_size       = 1
  },
  cell2 = {
    vpc_cidr            = "10.2.0.0/16"
    public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
    private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]
    availability_zones  = ["us-west-2a", "us-west-2b"]
    eks_version         = "1.28"
    node_instance_type  = "t3.medium"
    node_desired_size   = 1
    node_max_size       = 2
    node_min_size       = 1
  }
}
```

### Step 4: Plan and Apply Infrastructure

```bash
terraform plan
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## Accessing the Deployed Resources

### EKS Clusters

To configure kubectl for each cluster:

```bash
# For cell1
aws eks --region us-west-2 update-kubeconfig --name dev-cell1-cluster

# For cell2
aws eks --region us-west-2 update-kubeconfig --name dev-cell2-cluster
```

Verify cluster access:

```bash
kubectl get nodes
```

### EC2 Instances

SSH into the EC2 instances (replace with actual IPs from outputs):

```bash
ssh -i ~/.ssh/id_rsa ec2-user@$(terraform output -raw ec2_public_ip_cell1)
ssh -i ~/.ssh/id_rsa ec2-user@$(terraform output -raw ec2_public_ip_cell2)
```

### Application Load Balancers

Access the ALBs via their DNS names:

```bash
echo "Cell1 ALB: $(terraform output -raw alb_dns_name_cell1)"
echo "Cell2 ALB: $(terraform output -raw alb_dns_name_cell2)"
```

## Managing the Infrastructure

### View Outputs

```bash
terraform output
```

### Modify Infrastructure

1. Update the configuration files
2. Review changes:
   ```bash
   terraform plan
   ```
3. Apply changes:
   ```bash
   terraform apply
   ```

### Destroy Infrastructure

To tear down all resources:

```bash
terraform destroy
```

## Customization Guide

### Adding More Cells

1. Add a new entry in the `cell_config` map in `terraform.tfvars`
2. Ensure CIDR ranges don't overlap with existing cells
3. Run `terraform apply`

### Modifying EKS Configuration

Edit the `eks.tf` file in the cell module to:
- Change node group configurations
- Add additional node groups
- Modify cluster settings

### Changing Networking

Edit the `vpc.tf` and `networking.tf` files to:
- Adjust subnet CIDR ranges
- Modify route tables
- Change NAT gateway configuration

## Best Practices

1. **State Management**: Use remote state with S3 backend for team collaboration
2. **Variables**: Keep sensitive values in separate variable files or use AWS Secrets Manager
3. **Tagging**: Consistently tag resources for cost tracking and management
4. **Modules**: Break down complex components into smaller modules as needed
5. **Version Control**: Use Git to track changes to your infrastructure code

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure your AWS CLI has sufficient permissions
2. **Resource Limits**: Check for AWS service limits in your account
3. **Timeout Errors**: Increase timeout values in resource definitions if needed
4. **State Locking**: If Terraform hangs, check for state locks in your backend

### Debugging

Enable verbose logging:

```bash
TF_LOG=DEBUG terraform apply
```

## Support

For issues or questions, please open an issue in the GitHub repository.

---

This README provides comprehensive documentation for setting up, using, and maintaining the cell-based AWS infrastructure with Terraform. The modular design allows for easy customization while maintaining consistency across deployment units.