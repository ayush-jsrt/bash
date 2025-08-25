#!/bin/bash
set -e

# Create a folder
mkdir actions-runner && cd actions-runner

echo dir actions-runner created

# Download the latest runner package
curl -o actions-runner-linux-x64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz

echo downloaded zip

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.328.0.tar.gz

echo unziped

read -p "Enter your GitHub runner token command: " token

echo OK!
# Create the runner and start the configuration experience
eval "$token"

echo connected to the github runner

sudo ./svc.sh install
sudo ./svc.sh start

echo service craeted and started