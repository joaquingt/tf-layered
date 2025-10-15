# Quick Setup Guide

## Prerequisites Checklist

- [ ] Google Cloud CLI installed (`gcloud` command available)
- [ ] Terraform installed (>= 1.0)
- [ ] GCP Organization or Folder admin permissions
- [ ] Billing account access (or set `skip_billing = true` for testing)

## Step-by-Step Setup

### 1. Environment Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your values:
# - GOOGLE_APPLICATION_CREDENTIALS or GOOGLE_CREDENTIALS
# - GOOGLE_PROJECT (your default project)
# - GOOGLE_REGION (e.g., us-central1)
```

### 2. Load Environment

```bash
# Setup and authenticate
source scripts/setup-env.sh
```

### 3. Configure Deployment

```bash
# Navigate to development environment
cd l3/envs/dev/vms/

# Copy configuration template
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with:
# - project_name: "Your Project Name"
# - project_id: "unique-project-id-123"
# - org_id: "123456789012" (your org ID)
# - billing_account: "ABCDEF-123456-ABCDEF" (optional)
# - ssh_keys: "username:ssh-rsa AAAAB... username@host"
```

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply
```

### 5. Access Your VM

```bash
# Get connection command
terraform output ssh_command

# Copy and run the displayed command
```

## Quick Commands

Use the included Makefile for easier operations:

```bash
# Setup environment
make setup

# Deploy development environment
make dev-deploy

# Get SSH command
make ssh-vm

# Destroy infrastructure
make destroy
```

## What Gets Created

This deployment creates:

1. **New GCP Project** with your specified ID
2. **VPC Network** with subnet (10.0.0.0/24)
3. **Firewall Rules** for SSH access
4. **Free Tier VM** (e2-micro, 10GB disk)
5. **Service Account** with appropriate permissions
6. **Required APIs** enabled automatically

## Free Tier Compliant

The VM is configured to stay within GCP's Always Free tier:
- e2-micro instance type
- Standard persistent disk (≤30GB)
- Located in free tier eligible regions
- Standard networking (no premium features)

## Security Features

- No hardcoded secrets (all via environment variables)
- SSH access configurable by IP range
- Minimal IAM permissions
- Private Google access enabled
- Network security properly configured

## Troubleshooting

### Common Issues:

1. **Authentication Error**: Verify `GOOGLE_APPLICATION_CREDENTIALS` path
2. **Project Creation Fails**: Check org/folder permissions and billing
3. **SSH Access Issues**: Verify firewall rules and SSH key format
4. **API Errors**: Ensure required APIs are enabled

### Get Help:

```bash
# Check authentication
gcloud auth list

# Verify project access  
gcloud projects list

# Check Terraform state
terraform show

# View detailed logs
export TF_LOG=DEBUG
terraform apply
```