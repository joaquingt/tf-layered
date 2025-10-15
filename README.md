# Terraform GCP Layered Architecture

A production-ready, layered Terraform architecture for Google Cloud Platform that follows best practices for modularity, reusability, and security.

## 🏗️ Architecture Overview

This repository implements a 3-layer architecture:

- **Layer 1 (L1)**: Primitive wrappers around individual GCP resources
- **Layer 2 (L2)**: Opinionated compositions with validation and defaults  
- **Layer 3 (L3)**: Consumer examples and production deployments

## 🔒 Security First

All secrets and sensitive data are handled through environment variables - never hardcoded in Terraform files.

## 📁 Project Structure

```
terraform-layers/
├── l1/                          # Layer 1: Primitives
│   ├── compute_instance/        # VM instances
│   ├── disk/                    # Persistent disks  
│   ├── firewall_rule/           # Firewall rules
│   ├── iam_binding/             # IAM bindings
│   ├── ip/                      # Static IP addresses
│   ├── project/                 # GCP projects
│   ├── project_services/        # API enablement
│   ├── service_account/         # Service accounts
│   ├── subnet/                  # VPC subnets
│   └── vpc/                     # VPC networks
├── l2/                          # Layer 2: Compositions  
│   ├── iam_project_roles/       # Project IAM management
│   ├── project_bootstrap/       # Project creation & setup
│   ├── vm_free_tier/            # Free tier VM deployment
│   └── vpc_basic/               # Basic VPC with subnets
├── l3/                          # Layer 3: Consumers
│   └── envs/dev/vms/            # Development VM deployment
├── scripts/                     # Helper scripts
└── .env.example                 # Environment template
```

## 🚀 Quick Start

### Prerequisites

- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- GCP Project with billing enabled
- Organization or Folder admin permissions

### 1. Environment Setup

```bash
# Clone and navigate to the repository
cd terraform-layers

# Copy and configure environment variables
cp .env.example .env
# Edit .env with your actual values

# Setup environment (handles authentication)
source scripts/setup-env.sh
```

### 2. Deploy Development Environment

```bash
# Navigate to the consumer example
cd l3/envs/dev/vms/

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy
terraform init
terraform plan
terraform apply
```

### 3. Access Your VM

```bash
# Get SSH command from output
terraform output ssh_command

# Or connect directly
gcloud compute ssh your-vm-name --zone=us-central1-a --project=your-project-id
```

## 🔧 Environment Variables

The system uses environment variables for all sensitive data:

### Required Environment Variables

```bash
# Authentication
GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
# OR
GOOGLE_CREDENTIALS='{"type": "service_account", ...}'

# Default project/region
GOOGLE_PROJECT="your-default-project"
GOOGLE_REGION="us-central1"
```

### Terraform Variables via Environment

```bash
TF_VAR_project_id="your-new-project-id"
TF_VAR_org_id="123456789012"
TF_VAR_billing_account="01234A-567890-ABCDEF"
```

## 📚 Layer Details

### Layer 1 (L1): Primitives

Thin wrappers around single GCP resources with minimal business logic:

- **project**: Google Cloud Project creation
- **project_services**: API enablement  
- **vpc**: VPC network management
- **subnet**: Subnet configuration
- **firewall_rule**: Security rules
- **compute_instance**: VM instances
- **service_account**: Identity management
- **iam_binding**: Permission assignment
- **disk**: Persistent storage
- **ip**: Static IP addresses

Each L1 module exposes only essential inputs/outputs with proper validation.

### Layer 2 (L2): Compositions

Opinionated combinations of L1 modules with business logic:

#### `project_bootstrap`
- Creates new GCP project
- Enables required APIs
- Creates default service account
- Applies basic IAM bindings
- Supports billing toggle for testing

#### `vpc_basic` 
- Creates VPC with subnet
- Configures private Google access
- Sets up basic firewall rules (SSH, HTTP/HTTPS)
- Includes security best practices

#### `vm_free_tier`
- Deploys VM constrained to GCP Free Tier
- e2-micro instance type
- 10-30GB standard persistent disk
- Automatic tagging and labeling

#### `iam_project_roles`
- Bulk IAM role management
- Validation for proper member formats
- Support for all identity types

### Layer 3 (L3): Consumers

Production-ready examples consuming only L2 modules:

#### `envs/dev/vms/`
Complete development environment deployment:
- New GCP project creation
- VPC infrastructure setup  
- Free tier VM deployment
- SSH access configuration
- Comprehensive outputs

## 🎯 Free Tier Compliance

The `vm_free_tier` module ensures GCP Free Tier compliance:

- **Instance**: e2-micro (free tier eligible)
- **Disk**: 30GB max standard persistent disk
- **Network**: Standard networking (no premium)
- **Region**: Free tier eligible regions

## 🔒 Security Best Practices

### Environment Variables
- All secrets via environment variables
- No hardcoded credentials
- Support for service account keys and JSON strings

### Resource Security
- Minimal IAM permissions
- Network security groups
- Private Google access enabled
- SSH source IP restrictions

### Validation
- Input validation at L2 level
- Resource naming conventions
- CIDR block validation
- Free tier constraint enforcement

## 🚀 Deployment Patterns

### Development
```bash
cd l3/envs/dev/vms/
terraform apply -var="skip_billing=true"
```

### Production
```bash
# Use separate tfvars file
terraform apply -var-file="production.tfvars"
```

### CI/CD
```bash
# Use environment variables
export TF_VAR_gcp_credentials_json="${GCP_SA_KEY}"
terraform apply -auto-approve
```

## 📖 Usage Examples

### Create Project with VPC and VM

```hcl
module "project_bootstrap" {
  source = "../../../l2/project_bootstrap"
  
  project_name = "My Dev Project"
  project_id   = "my-dev-project-123"
  org_id       = var.org_id
}

module "vpc_basic" {
  source = "../../../l2/vpc_basic"
  
  vpc_name   = "dev-vpc"
  project_id = module.project_bootstrap.project_id
}

module "vm_free_tier" {
  source = "../../../l2/vm_free_tier"
  
  instance_name = "dev-vm"
  project_id    = module.project_bootstrap.project_id
  network       = module.vpc_basic.vpc_self_link
  subnetwork    = module.vpc_basic.subnet_self_link
}
```

### Custom IAM Roles

```hcl
module "project_iam" {
  source = "../../../l2/iam_project_roles"
  
  project_id = var.project_id
  project_roles = {
    "roles/viewer" = [
      "user:developer@company.com",
      "group:developers@company.com"
    ]
    "roles/compute.admin" = [
      "serviceAccount:${module.vm.service_account_email}"
    ]
  }
}
```

## 🔧 Customization

### Adding New L1 Modules

1. Create module directory in `l1/`
2. Add `main.tf`, `variables.tf`, `outputs.tf`
3. Follow naming conventions
4. Add validation where appropriate

### Creating L2 Compositions

1. Create module directory in `l2/`
2. Consume only L1 modules
3. Add business logic and validation
4. Include comprehensive defaults
5. Add proper tagging/labeling

### L3 Consumer Patterns

1. Create environment-specific directories
2. Use only L2 modules
3. Include complete examples
4. Document deployment process

## 🤝 Contributing

1. Follow the layered architecture principles
2. L1 modules should be thin wrappers only
3. L2 modules add business logic and validation
4. L3 consumes L2 only
5. All secrets via environment variables
6. Include comprehensive validation
7. Add proper documentation

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

#### Authentication Errors
```bash
# Ensure credentials are set
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
# OR use default credentials
gcloud auth application-default login
```

#### Project Creation Fails
- Verify organization/folder permissions
- Check billing account association
- Ensure project ID uniqueness

#### VM Won't Start
- Check free tier limits
- Verify zone availability
- Review firewall rules

### Getting Help

1. Check error messages for validation failures
2. Verify environment variable configuration
3. Review GCP quotas and limits
4. Check IAM permissions

### Useful Commands

```bash
# Check current authentication
gcloud auth list

# Verify project access
gcloud projects list

# Check compute quotas
gcloud compute project-info describe --project=PROJECT_ID

# View Terraform state
terraform show

# Debug Terraform
export TF_LOG=DEBUG
terraform apply
```