#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <ssh_public_key_file>"
    exit 1
fi

# Extract username and SSH key file from parameters
username="$1"
ssh_public_key_file="$2"

# Update package lists
sudo apt update

# Install OpenSSH Server
sudo apt install openssh-server -y

# Backup the SSH configuration file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup

# Configure SSH to allow key-based authentication only for the specified user
echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "AllowUsers $username" | sudo tee -a /etc/ssh/sshd_config

# Ensure SSH directory exists for the specified user
sudo mkdir -p /home/$username/.ssh

# Copy the provided SSH public key to the user's authorized_keys file
sudo cat "$ssh_public_key_file" | sudo tee -a /home/$username/.ssh/authorized_keys

# Set appropriate permissions for the user's .ssh directory and authorized_keys file
sudo chown -R $username:$username /home/$username/.ssh
sudo chmod 700 /home/$username/.ssh
sudo chmod 600 /home/$username/.ssh/authorized_keys

# Restart the SSH service
sudo systemctl restart ssh

# Enable SSH to start on boot
sudo systemctl enable ssh

# Display the SSH service status
sudo systemctl status ssh

echo "OpenSSH Server is now installed and configured for user $username with key-based authentication."
