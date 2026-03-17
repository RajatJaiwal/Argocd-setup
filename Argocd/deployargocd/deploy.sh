#!/bin/bash

LOG_FILE="pipeline.log"

echo "🚀 Your pipeline is started..."
echo "📁 Logs will be stored in: $LOG_FILE"

# ================= STAGE 1 =================
echo ""
echo "========== STAGE 1: Cluster Setup =========="

if [ -f "./deploycluster.sh" ]; then
    echo "▶️ Running deploycluster.sh..."
    
    ./deploycluster.sh | tee -a $LOG_FILE

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "✅ Cluster is ready"
    else
        echo "❌ Cluster setup failed"
        exit 1
    fi
else
    echo "❌ deploycluster.sh not found"
    exit 1
fi

# ================= STAGE 2 =================
echo ""
echo "========== STAGE 2: ArgoCD Setup =========="

echo "⏳ Setting up ArgoCD..."

if [ -f "./setupargocd.sh" ]; then
    echo "▶️ Running setupargocd.sh..."
    
    ./setupargocd.sh | tee -a $LOG_FILE

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "🎉 ArgoCD setup is completed"
    else
        echo "❌ ArgoCD setup failed"
        exit 1
    fi
else
    echo "❌ setupargocd.sh not found"
    exit 1
fi

echo ""
echo "🎉🎉 Pipeline completed successfully 🎉🎉"
