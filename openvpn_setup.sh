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

# Install OpenVPN Server
sudo apt install openvpn easy-rsa -y

# Copy Easy-RSA files to OpenVPN directory
sudo mkdir -p /etc/openvpn/easy-rsa
sudo cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

# Move to the Easy-RSA directory
cd /etc/openvpn/easy-rsa

# Initialize the PKI
./easyrsa init-pki

# Build the certificate authority
./easyrsa build-ca nopass

# Generate the server key
./easyrsa gen-req server nopass

# Sign the server key
./easyrsa sign server server

# Generate Diffie-Hellman parameters
./easyrsa gen-dh

# Create a shared secret
openvpn --genkey --secret /etc/openvpn/ta.key

# Copy generated files to OpenVPN directory
sudo cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem /etc/openvpn/

# Create the server configuration file
echo "port 1194" | sudo tee /etc/openvpn/server.conf
echo "proto udp" | sudo tee -a /etc/openvpn/server.conf
echo "dev tun" | sudo tee -a /etc/openvpn/server.conf
echo "ca ca.crt" | sudo tee -a /etc/openvpn/server.conf
echo "cert server.crt" | sudo tee -a /etc/openvpn/server.conf
echo "key server.key" | sudo tee -a /etc/openvpn/server.conf
echo "dh dh.pem" | sudo tee -a /etc/openvpn/server.conf
echo "server 10.8.0.0 255.255.255.0" | sudo tee -a /etc/openvpn/server.conf
echo "push \"redirect-gateway def1 bypass-dhcp\"" | sudo tee -a /etc/openvpn/server.conf
echo "push \"dhcp-option DNS $(hostname -I | cut -d' ' -f1)\"" | sudo tee -a /etc/openvpn/server.conf
echo "client-to-client" | sudo tee -a /etc/openvpn/server.conf
echo "keepalive 10 120" | sudo tee -a /etc/openvpn/server.conf
echo "tls-auth ta.key 0" | sudo tee -a /etc/openvpn/server.conf
echo "comp-lzo" | sudo tee -a /etc/openvpn/server.conf
echo "user nobody" | sudo tee -a /etc/openvpn/server.conf
echo "group nogroup" | sudo tee -a /etc/openvpn/server.conf
echo "persist-key" | sudo tee -a /etc/openvpn/server.conf
echo "persist-tun" | sudo tee -a /etc/openvpn/server.conf
echo "status /var/log/openvpn-status.log" | sudo tee -a /etc/openvpn/server.conf
echo "verb 3" | sudo tee -a /etc/openvpn/server.conf

# Enable IP forwarding
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p

# Start the OpenVPN service
sudo systemctl start openvpn@server

# Enable OpenVPN to start on boot
sudo systemctl enable openvpn@server

# Display the OpenVPN service status
sudo systemctl status openvpn@server

echo "OpenVPN Server is now installed and configured."

# Create the OpenVPN client configuration file
echo "client" | sudo tee /etc/openvpn/kaliNetwork.ovpn
echo "dev tun" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "proto udp" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "remote your_openvpn_server_ip 1194" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "resolv-retry infinite" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "nobind" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "user nobody" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "group nogroup" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "persist-key" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "persist-tun" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "remote-cert-tls server" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "tls-auth ta.key 1" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "comp-lzo" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "ca ca.crt" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "cert client.crt" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
echo "key client.key" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn

# Transfer the user's public key to the client's configuration
sudo cat "$ssh_public_key_file" | sudo tee -a /etc/openvpn/kaliNetwork.ovpn
sudo cp /etc/openvpn/kaliNetwork.ovpn /home/$username/kaliNetwork.ovpn

echo "OpenVPN Client configuration file 'kaliNetwork.ovpn' is now created."
echo "OpenVPN Config File is located at /home/$username/kaliNetwork.ovpn"
