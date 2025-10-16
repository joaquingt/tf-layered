#!/bin/bash
# Startup script for backend web servers
# This script installs and configures nginx with a simple page

set -e

# Variables from template
SERVER_ID="${server_id}"
PORT="${port}"

# Update system
apt-get update

# Install nginx
apt-get install -y nginx

# Create a simple HTML page that identifies this server
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Backend Server $${SERVER_ID}</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            padding: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            margin: 20px auto;
            max-width: 600px;
        }
        .server-id { 
            font-size: 3em; 
            font-weight: bold; 
            color: #FFD700;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Internal Load Balancer Demo</h1>
        <div class="server-id">Server $${SERVER_ID}</div>
        <p>Hostname: $(hostname)</p>
        <p>Port: $${PORT}</p>
        <p>Time: $(date)</p>
        <p>This request was served by backend server $${SERVER_ID}</p>
    </div>
</body>
</html>
EOF

# Create health check endpoint
cat > /var/www/html/health << EOF
{
  "status": "healthy",
  "server_id": "$${SERVER_ID}",
  "timestamp": "$(date -Iseconds)",
  "hostname": "$(hostname)"
}
EOF

# Configure nginx to listen on specified port
if [ "$${PORT}" != "80" ]; then
    sed -i "s/listen 80/listen $${PORT}/" /etc/nginx/sites-available/default
    sed -i "s/listen \[::\]:80/listen \[::\]:$${PORT}/" /etc/nginx/sites-available/default
fi

# Add location for health check
sed -i '/location \/ {/a\\tlocation /health {\n\t\ttry_files $uri $uri/ =404;\n\t\tadd_header Content-Type application/json;\n\t}' /etc/nginx/sites-available/default

# Test nginx configuration
nginx -t

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Create a simple log rotation for access logs
cat > /etc/logrotate.d/nginx-custom << EOF
/var/log/nginx/access.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    create 644 www-data www-data
    postrotate
        systemctl reload nginx
    endscript
}
EOF

# Log that startup is complete
echo "Backend server $${SERVER_ID} startup complete at $(date)" >> /var/log/startup.log

# Test the web server
sleep 5
curl -f http://localhost:$${PORT}/health || echo "Health check failed" >> /var/log/startup.log

echo "Backend server $${SERVER_ID} is ready to serve traffic on port $${PORT}"