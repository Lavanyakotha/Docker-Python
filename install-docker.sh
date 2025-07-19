#!/bin/bash
# Install Docker and run hello-world
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
