#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    # Install Docker prerequisites
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker repository for Ubuntu
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update package index again
    sudo apt update

    # Install Docker
    sudo apt install -y docker-ce

    # Add current user to the docker group to run Docker commands without sudo
    sudo usermod -aG docker $USER

    echo "Docker has been installed successfully."
else
    echo "Docker is already installed."
fi

# install and run rancher on container
sudo docker run -d --restart=unless-stopped --privileged -p 80:80 -p 443:443 rancher/rancher

