#!/bin/bash

# ===============================
# Update system
# ===============================
sudo apt update -y

# ===============================
# Basic packages
# ===============================
sudo apt install -y \
  curl \
  unzip \
  git \
  fontconfig \
  openjdk-21-jre

# ===============================
# Jenkins (FIRST)
# ===============================
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# ===============================
# Docker (AFTER Jenkins)
# ===============================
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock

# ===============================
# Terraform
# ===============================
wget -O- https://apt.releases.hashicorp.com/gpg \
 | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee \
/etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt install terraform -y

# ===============================
# AWS CLI v2
# ===============================
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install

# ===============================
# kubectl
# ===============================
curl -LO https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# ===============================
# Helm
# ===============================
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ===============================
# eksctl
# ===============================
curl -LO https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz
tar -xzf eksctl_Linux_amd64.tar.gz
sudo mv eksctl /usr/local/bin/

# ===============================
# SonarQube
# ===============================
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# ===============================
# Verify
# ===============================
jenkins --version
docker --version
terraform -version
aws --version
kubectl version --client
helm version
eksctl version
java -version
git --version
