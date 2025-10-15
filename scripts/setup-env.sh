#!/bin/bash
# Environment setup script for Terraform GCP layers
# Usage: source scripts/setup-env.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up Terraform GCP Layers environment...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    cp .env.example .env
    echo -e "${RED}Please edit .env file with your actual values before proceeding!${NC}"
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    echo -e "${GREEN}Loading environment variables from .env...${NC}"
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}No .env file found!${NC}"
    exit 1
fi

# Verify required variables
required_vars=("GOOGLE_PROJECT")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo -e "${RED}Missing required environment variables:${NC}"
    printf '%s\n' "${missing_vars[@]}"
    echo -e "${RED}Please set these variables in your .env file${NC}"
    exit 1
fi

# Check Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Google Cloud CLI (gcloud) is not installed!${NC}"
    echo "Please install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Terraform is not installed!${NC}"
    echo "Please install it from: https://www.terraform.io/downloads"
    exit 1
fi

echo -e "${GREEN}✓ Environment setup complete!${NC}"
echo -e "${YELLOW}Current configuration:${NC}"
echo "  Google Project: ${GOOGLE_PROJECT}"
echo "  Google Region: ${GOOGLE_REGION}"

# Authenticate if credentials file is provided
if [ -n "$GOOGLE_APPLICATION_CREDENTIALS" ] && [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo -e "${GREEN}✓ Google Cloud credentials file found${NC}"
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
else
    echo -e "${YELLOW}No service account key file specified. Using default credentials.${NC}"
    echo "Run 'gcloud auth application-default login' if needed."
fi

echo -e "${GREEN}Ready to deploy! Navigate to l3/envs/dev/vms/ and run:${NC}"
echo "  terraform init"
echo "  terraform plan"
echo "  terraform apply"