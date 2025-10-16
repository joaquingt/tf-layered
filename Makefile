.PHONY: help setup init plan apply destroy clean validate fmt lint check

# Default target
help: ## Show this help message
	@echo "Terraform GCP Layered Architecture"
	@echo "Usage: make <target>"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Environment setup
setup: ## Setup environment and copy configuration files
	@echo "Setting up environment..."
	@if [ ! -f .env ]; then cp .env.example .env && echo "Created .env file - please edit it with your values"; fi
	@chmod +x scripts/setup-env.sh
	@echo "Run 'source scripts/setup-env.sh' to load environment variables"

# L3 Development Environment Operations
DEV_VM_DIR := l3/envs/dev/vms
DEV_ILB_DIR := l3/envs/dev/ilb

init: ## Initialize Terraform in VM development environment
	@cd $(DEV_VM_DIR) && terraform init

init-ilb: ## Initialize Terraform in ILB development environment
	@cd $(DEV_ILB_DIR) && terraform init

validate: ## Validate Terraform configuration (VMs)
	@cd $(DEV_VM_DIR) && terraform validate

validate-ilb: ## Validate Terraform configuration (ILB)
	@cd $(DEV_ILB_DIR) && terraform validate

fmt: ## Format Terraform files
	@terraform fmt -recursive .

plan: ## Create Terraform execution plan (VMs)
	@cd $(DEV_VM_DIR) && terraform plan

plan-ilb: ## Create Terraform execution plan (ILB)
	@cd $(DEV_ILB_DIR) && terraform plan

apply: ## Apply Terraform configuration (VMs)
	@cd $(DEV_VM_DIR) && terraform apply

apply-ilb: ## Apply Terraform configuration (ILB)
	@cd $(DEV_ILB_DIR) && terraform apply

destroy: ## Destroy Terraform infrastructure (VMs)
	@cd $(DEV_VM_DIR) && terraform destroy

destroy-ilb: ## Destroy Terraform infrastructure (ILB)
	@cd $(DEV_ILB_DIR) && terraform destroy

# Development helpers
dev-setup: setup ## Setup VM development environment with sample configs
	@cd $(DEV_VM_DIR) && if [ ! -f terraform.tfvars ]; then cp terraform.tfvars.example terraform.tfvars && echo "Created terraform.tfvars - please edit it"; fi

dev-setup-ilb: setup ## Setup ILB development environment with sample configs
	@cd $(DEV_ILB_DIR) && if [ ! -f terraform.tfvars ]; then cp terraform.tfvars.example terraform.tfvars && echo "Created terraform.tfvars - please edit it"; fi

dev-deploy: init validate plan apply ## Full VM development deployment

dev-deploy-ilb: init-ilb validate-ilb plan-ilb apply-ilb ## Full ILB development deployment

# Maintenance
clean: ## Clean Terraform temporary files
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.tfstate*" -delete 2>/dev/null || true
	@find . -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@echo "Cleaned Terraform temporary files"

# Linting and validation
lint: fmt validate ## Run all linting and validation

check: ## Check all modules for issues
	@echo "Checking L1 modules..."
	@for dir in l1/*/; do echo "Checking $$dir"; cd "$$dir" && terraform validate && cd ../..; done
	@echo "Checking L2 modules..."  
	@for dir in l2/*/; do echo "Checking $$dir"; cd "$$dir" && terraform validate && cd ../..; done
	@echo "Checking L3 examples..."
	@cd $(DEV_VM_DIR) && terraform validate
	@cd $(DEV_ILB_DIR) && terraform validate

# Security
security-scan: ## Run basic security checks
	@echo "Running security checks..."
	@grep -r "AKIA\|password\|secret" --include="*.tf" --include="*.tfvars.example" . || echo "No hardcoded secrets found"
	@echo "Checking for sensitive outputs..."
	@grep -r "sensitive.*=.*false" --include="*.tf" . || echo "No insecure sensitive outputs found"

# Documentation
docs: ## Generate module documentation
	@echo "Terraform modules documentation available in README.md"
	@echo "Layer structure documented at root level"

# Quick commands
quick-dev: dev-setup dev-deploy ## Quick VM development environment setup and deployment

quick-dev-ilb: dev-setup-ilb dev-deploy-ilb ## Quick ILB development environment setup and deployment

ssh-vm: ## Get SSH command for the development VM
	@cd $(DEV_VM_DIR) && terraform output -raw ssh_command

ssh-test-vm: ## Get SSH command for the ILB test VM
	@cd $(DEV_ILB_DIR) && terraform output test_vm_info

status: ## Show current VM infrastructure status
	@cd $(DEV_VM_DIR) && terraform show

status-ilb: ## Show current ILB infrastructure status
	@cd $(DEV_ILB_DIR) && terraform show

outputs: ## Show all outputs from VM development environment
	@cd $(DEV_VM_DIR) && terraform output

outputs-ilb: ## Show all outputs from ILB development environment
	@cd $(DEV_ILB_DIR) && terraform output

test-lb: ## Show load balancer test commands
	@cd $(DEV_ILB_DIR) && terraform output load_balancer_test_commands