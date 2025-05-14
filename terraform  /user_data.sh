#!/bin/bash

# Logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting EC2 initialization script..."

# Update and install dependencies
apt update -y
apt install -y git curl unzip tar gcc g++ make awscli

# Install NVM (Node Version Manager)
su - ubuntu -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash'

# Load NVM and install Node.js
su - ubuntu -c 'export NVM_DIR="$HOME/.nvm" && source $NVM_DIR/nvm.sh && nvm install --lts && nvm alias default node'

# Install PM2
su - ubuntu -c 'export NVM_DIR="$HOME/.nvm" && source $NVM_DIR/nvm.sh && npm install -g pm2'

# Create logs directory
su - ubuntu -c 'mkdir -p ~/logs'

echo "EC2 initialization complete!"
