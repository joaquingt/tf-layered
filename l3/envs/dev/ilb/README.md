# Internal Load Balancer Example

This example demonstrates how to deploy an Internal Load Balancer (ILB) in Google Cloud Platform using the layered Terraform architecture.

## Architecture

The deployment creates:

1. **New GCP Project** with required APIs enabled
2. **VPC Network** with subnet and firewall rules
3. **Backend VMs** (configurable count) distributed across zones
4. **Internal Load Balancer** with health checks
5. **Test Client VM** for validation and monitoring

## Components Created

### Load Balancer Infrastructure
- **Health Check**: HTTP/HTTPS/TCP health monitoring
- **Instance Groups**: Organized by zone for high availability
- **Backend Service**: Load balancing logic and configuration
- **Forwarding Rule**: Traffic distribution entry point
- **Static Internal IP**: Optional dedicated IP address

### Backend VMs
- Multiple VMs distributed across zones
- Nginx web server with unique identification
- Health check endpoint (`/health`)
- Internal-only networking (no external IPs)

### Test Client VM
- External IP for SSH access
- Pre-installed testing tools
- Load balancer monitoring scripts
- Continuous connectivity validation

## Quick Start

### 1. Configure Environment
```bash
# Ensure environment is set up
source scripts/setup-env.sh

# Navigate to ILB example
cd l3/envs/dev/ilb/

# Copy and edit configuration
cp terraform.tfvars.example terraform.tfvars
# Edit with your project details
```

### 2. Deploy Infrastructure
```bash
# Initialize and deploy
terraform init
terraform plan
terraform apply

# Or use make commands
make dev-setup-ilb
make dev-deploy-ilb
```

### 3. Test Load Balancer
```bash
# Get connection info
terraform output test_vm_info

# SSH to test client
gcloud compute ssh test-client-vm --zone=us-central1-a --project=YOUR-PROJECT

# Run tests on the test VM
./test-lb.sh          # Comprehensive test
./quick-test.sh       # Quick 5-request test  
./monitor-lb.sh       # Continuous monitoring
```

## Configuration Options

### Basic Configuration
```hcl
# terraform.tfvars
project_name = "My ILB Project"
project_id   = "my-ilb-project-123"
org_id       = "123456789012"

# Backend VMs
backend_vm_count = 3
zones = ["us-central1-a", "us-central1-b", "us-central1-c"]

# Load Balancer
lb_protocol = "HTTP"
backend_port = 80
create_static_ip = true
```

### Advanced Configuration
```hcl
# Session affinity
session_affinity = "CLIENT_IP"

# Health check customization
health_check_path = "/health"
timeout_sec = 60

# Performance tuning
max_connections_per_instance = 2000
allow_global_access = true

# Testing
create_test_vm = true
```

## Load Balancer Testing

### Automatic Tests
The test client VM includes several testing scripts:

1. **test-lb.sh**: Comprehensive load balancer validation
   - Connectivity test
   - Health check validation
   - Load distribution verification
   - Continuous monitoring mode

2. **quick-test.sh**: Fast validation (5 requests)

3. **monitor-lb.sh**: Continuous monitoring with logging

### Manual Testing
```bash
# Basic connectivity
curl http://LOAD_BALANCER_IP:80

# Health check
curl http://LOAD_BALANCER_IP:80/health

# Load distribution test
for i in {1..10}; do curl -s http://LOAD_BALANCER_IP:80 | grep "Server"; done
```

## Monitoring and Observability

### Load Balancer Metrics
```bash
# View backend health
gcloud compute backend-services get-health BACKEND_SERVICE_NAME \
  --region=us-central1 --project=YOUR_PROJECT

# Check forwarding rule
gcloud compute forwarding-rules describe FORWARDING_RULE_NAME \
  --region=us-central1 --project=YOUR_PROJECT
```

### VM Monitoring
```bash
# Check backend VM status
gcloud compute instances list --project=YOUR_PROJECT

# View VM logs
gcloud compute ssh backend-vm-1 --zone=us-central1-a --project=YOUR_PROJECT
sudo journalctl -u nginx -f
```

## High Availability

The architecture provides high availability through:

- **Multi-zone deployment**: Backend VMs distributed across zones
- **Health checks**: Automatic unhealthy instance removal
- **Session affinity options**: Maintain user sessions as needed
- **Connection draining**: Graceful instance replacement

## Security Features

- **Internal-only load balancer**: No external internet exposure
- **Private backend VMs**: No external IP addresses
- **Network isolation**: VPC-contained traffic
- **SSH access control**: Configurable source IP ranges
- **Health check validation**: Automatic security monitoring

## Troubleshooting

### Common Issues

1. **Backend VMs not healthy**
   ```bash
   # Check VM status
   gcloud compute instances list
   
   # SSH to backend VM
   gcloud compute ssh backend-vm-1 --zone=us-central1-a
   sudo systemctl status nginx
   curl localhost/health
   ```

2. **Load balancer not reachable**
   ```bash
   # Verify forwarding rule
   terraform output load_balancer_info
   
   # Check firewall rules
   gcloud compute firewall-rules list --project=YOUR_PROJECT
   ```

3. **Health checks failing**
   ```bash
   # Review health check configuration
   gcloud compute health-checks describe HEALTH_CHECK_NAME --project=YOUR_PROJECT
   
   # Test health endpoint manually
   curl -v http://BACKEND_VM_IP/health
   ```

### Useful Commands

```bash
# Infrastructure status
make status-ilb

# All outputs
make outputs-ilb

# Test commands
make test-lb

# Destroy infrastructure
make destroy-ilb
```

## Cost Optimization

This deployment is designed to be cost-effective:

- **Free tier VMs**: e2-micro instances where possible
- **Standard networking**: No premium tier charges
- **Minimal resources**: Only necessary components created
- **Regional load balancer**: Lower cost than global

## Cleanup

```bash
# Destroy all resources
terraform destroy

# Or use make command
make destroy-ilb

# Verify cleanup
gcloud compute instances list --project=YOUR_PROJECT
gcloud compute forwarding-rules list --project=YOUR_PROJECT
```

## Next Steps

- Explore session affinity options
- Implement SSL/TLS termination
- Add Cloud Monitoring integration
- Configure automated scaling
- Integrate with CI/CD pipelines

## Support

For issues or questions:
1. Check Terraform output messages
2. Review GCP Console load balancer section
3. Verify firewall and network configuration
4. Test individual components (VMs, health checks)