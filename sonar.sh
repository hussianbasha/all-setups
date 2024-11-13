#!/bin/bash

# Ensure the script is run as root, since you need root privileges for installation
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Step 1: Install required packages and Java
cd /opt/

# Download and unzip SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip
unzip sonarqube-8.9.6.50800.zip

# Install Java 11 (for Amazon Linux 2)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "amazon" && "$VERSION_ID" == "2" ]]; then
        amazon-linux-extras install java-openjdk11 -y
    else
        # For other distros or Amazon Linux 1, install Amazon Corretto 11 (OpenJDK 11)
        yum install -y java-11-amazon-corretto
    fi
fi

# Step 2: Add sonar user and set permissions
useradd sonar

# Ensure the sonar user can access SonarQube
chown sonar:sonar /opt/sonarqube-8.9.6.50800 -R
chmod 755 /opt/sonarqube-8.9.6.50800 -R

# Step 3: Configure SonarQube to run as the 'sonar' user
# Create a systemd service (optional but recommended for ease of use)
echo "[Unit]
Description=SonarQube
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube-8.9.6.50800/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube-8.9.6.50800/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/sonar.service

# Step 4: Enable SonarQube to start on boot
systemctl enable sonar

# Step 5: Start SonarQube using systemd (no need to manually 'su' into the sonar user)
systemctl start sonar

# Step 6: Display success message
echo "SonarQube is now installed and running."
echo "You can access it at http://<your-server-ip>:9000"
echo "Default credentials: user=admin / password=admin"
