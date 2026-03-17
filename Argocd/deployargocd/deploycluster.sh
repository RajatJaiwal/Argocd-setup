#!/bin/bash

set -e  # Exit on error

echo "🚀 Updating system..."
sudo apt update -y

echo "📦 Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "✅ kubectl installed:"
kubectl version --client

echo "☸️ Installing K3s..."
curl -sfL https://get.k3s.io | sh -

echo "⏳ Waiting for K3s to be ready..."
sleep 10

echo "🔍 Checking K3s service..."
sudo systemctl status k3s --no-pager

echo "📁 Setting up kubeconfig..."
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config

echo "📡 Verifying cluster..."
kubectl get nodes
kubectl get pods -A

echo "🎉 Setup complete! K3s cluster is ready."
