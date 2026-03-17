#!/bin/bash

set -e

echo "🚀 Creating ArgoCD namespace..."
kubectl create namespace argocd 2>/dev/null || echo "Namespace already exists"

echo "📦 Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true

echo "⏳ Waiting for ArgoCD server..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s

echo "📡 Checking pods..."
kubectl get pods -n argocd

echo "🌐 Exposing ArgoCD via NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}' 2>/dev/null || echo "Already patched"

echo "🔍 Fetching NodePort..."
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

echo "🔑 Retrieving admin password..."
ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "================= 🎉 ArgoCD READY ================="
echo "🌐 URL: http://${IP}:${NODE_PORT}"
echo "👤 Username: admin"
echo "🔑 Password: ${ARGO_PWD}"
echo "=================================================="
