#!/bin/bash
# Startup script for test client VM
# This script installs tools to test the internal load balancer

set -e

# Variables from template
LB_IP="${lb_ip}"
PORT="${port}"

# Update system
apt-get update

# Install testing tools
apt-get install -y curl wget htop jq

# Create test scripts
cat > /home/ubuntu/test-lb.sh << 'EOF'
#!/bin/bash
# Script to test the internal load balancer

LB_IP="${lb_ip}"
PORT="${port}"

echo "Testing Internal Load Balancer at $${LB_IP}:$${PORT}"
echo "=================================================="

# Test basic connectivity
echo "1. Basic connectivity test..."
if curl -s -f -m 10 "http://$${LB_IP}:$${PORT}" > /dev/null; then
    echo "✓ Load balancer is reachable"
else
    echo "✗ Load balancer is not reachable"
    exit 1
fi

# Test health check endpoint
echo -e "\n2. Health check test..."
if curl -s -f -m 10 "http://$${LB_IP}:$${PORT}/health" | jq . > /dev/null 2>&1; then
    echo "✓ Health check endpoint is working"
    curl -s "http://$${LB_IP}:$${PORT}/health" | jq .
else
    echo "✗ Health check endpoint failed"
fi

# Test load balancing by making multiple requests
echo -e "\n3. Load balancing test (10 requests)..."
for i in {1..10}; do
    response=$(curl -s -m 5 "http://$${LB_IP}:$${PORT}" | grep -o "Server [0-9]*" | head -1)
    echo "Request $i: $response"
    sleep 1
done

echo -e "\n4. Continuous test (press Ctrl+C to stop)..."
echo "Making requests every 2 seconds..."
while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    response=$(curl -s -m 5 "http://$${LB_IP}:$${PORT}" | grep -o "Server [0-9]*" | head -1)
    echo "[$timestamp] $response"
    sleep 2
done
EOF

# Make the test script executable
chmod +x /home/ubuntu/test-lb.sh
chown ubuntu:ubuntu /home/ubuntu/test-lb.sh

# Create a quick test command
cat > /home/ubuntu/quick-test.sh << 'EOF'
#!/bin/bash
LB_IP="${lb_ip}"
PORT="${port}"
echo "Quick Load Balancer Test"
echo "======================="
echo "Load Balancer IP: $LB_IP"
echo "Port: $PORT"
echo ""
echo "Making 5 test requests..."
for i in {1..5}; do
    response=$(curl -s -m 5 "http://$${LB_IP}:$${PORT}" | grep -o "Server [0-9]*" | head -1)
    echo "Request $i: $response"
done
EOF

chmod +x /home/ubuntu/quick-test.sh
chown ubuntu:ubuntu /home/ubuntu/quick-test.sh

# Create monitoring script
cat > /home/ubuntu/monitor-lb.sh << 'EOF'
#!/bin/bash
# Continuous monitoring of the load balancer

LB_IP="${lb_ip}"
PORT="${port}"

echo "Monitoring Load Balancer at $${LB_IP}:$${PORT}"
echo "=============================================="

# Create log file
LOG_FILE="/home/ubuntu/lb-monitor.log"
touch $LOG_FILE

while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Test connectivity and response time
    start_time=$(date +%s.%N)
    response=$(curl -s -w "%{http_code}" -m 10 "http://$${LB_IP}:$${PORT}" -o /tmp/lb_response)
    end_time=$(date +%s.%N)
    response_time=$(echo "$end_time - $start_time" | bc)
    
    if [ "$response" = "200" ]; then
        server=$(grep -o "Server [0-9]*" /tmp/lb_response | head -1)
        echo "[$timestamp] ✓ $server (${response_time}s)" | tee -a $LOG_FILE
    else
        echo "[$timestamp] ✗ HTTP $response (${response_time}s)" | tee -a $LOG_FILE
    fi
    
    sleep 5
done
EOF

chmod +x /home/ubuntu/monitor-lb.sh
chown ubuntu:ubuntu /home/ubuntu/monitor-lb.sh

# Install additional networking tools
apt-get install -y netcat-openbsd telnet dnsutils

# Create welcome message
cat > /etc/motd << 'EOF'
===============================================
   Internal Load Balancer Test Client VM
===============================================

Available test scripts:
  ./test-lb.sh      - Comprehensive load balancer test
  ./quick-test.sh   - Quick 5-request test
  ./monitor-lb.sh   - Continuous monitoring

Load Balancer Details:
  IP Address: ${lb_ip}
  Port: ${port}

Example commands:
  curl http://${lb_ip}:${port}
  curl http://${lb_ip}:${port}/health

===============================================
EOF

# Log completion
echo "Test client setup complete at $(date)" >> /var/log/startup.log

# Run a quick test to verify connectivity
echo "Running initial connectivity test..."
sleep 30  # Wait for load balancer to be ready
if curl -s -f -m 10 "http://$${LB_IP}:$${PORT}" > /dev/null; then
    echo "✓ Load balancer connectivity verified" >> /var/log/startup.log
else
    echo "✗ Load balancer connectivity test failed" >> /var/log/startup.log
fi