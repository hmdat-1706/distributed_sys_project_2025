#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function run_cmd() {
    CMD="$1"
    echo -e "${YELLOW}>>> ${CMD}${NC}"
    sleep 3
    eval "$CMD"
}

clear
echo -e "${GREEN}+---------------------------------------------------+"
echo -e "| PROJECT DISTRIBUTED SYSTEM 2025-2026 NHOM XX      |"
echo -e "| TRAN HAI DANG                                     |"
echo -e "| NGUYEN LE NHAT DANG                               |"
echo -e "| HUYNH MINH DAT                                    |"
echo -e "+---------------------------------------------------+${NC}"
echo ""
echo "..."
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[1] Running: System Update & Install Dependencies"
run_cmd "sudo apt update"
run_cmd "sudo apt install -y ca-certificates curl jq docker.io"
run_cmd "sudo usermod -aG docker $USER"

echo "-----------------------------------------------------"
echo "[2] Running: Install Minikube & Kubectl"
# Install Minikube
run_cmd "curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
run_cmd "sudo install minikube-linux-amd64 /usr/local/bin/minikube"

# Install Kubectl
run_cmd "curl -LO \"https://dl.k8s.io/release/\$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\""
run_cmd "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl"

echo "Check version:"
run_cmd "minikube version"

echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[3] Running: Basic Minikube Lifecycle (Start/Stop/Delete)"
run_cmd "minikube start"
echo ""
echo "[Enter]"
read
run_cmd "minikube status"
echo ""
echo "[Enter]"
read
run_cmd "kubectl config current-context"
echo ""
echo "[Enter]"
read

echo "Check Pods"
run_cmd "kubectl get pods -n kube-system"
echo ""
echo "[Enter]"
read

echo "Check Nodes"
run_cmd "kubectl get nodes -o wide"
echo ""
echo "[Enter]"
read

echo "Check API Resources"
run_cmd "kubectl api-resources | head -n 10"
echo ""
echo "[Enter]"
read

echo "Pause/Unpause/Stop/Delete"
run_cmd "minikube pause"
run_cmd "minikube unpause"
run_cmd "minikube stop"
run_cmd "minikube delete"

echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[4] Running: Minikube Configuration"
run_cmd "minikube config set cpus 2"
run_cmd "minikube config set memory 2048"
run_cmd "minikube config set disk-size 10000"
run_cmd "minikube config set kubernetes-version v1.34.0"
run_cmd "minikube config set driver docker"
run_cmd "minikube config set container-runtime docker"

echo "Check Config"
run_cmd "minikube config view"

echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[5] Running: Project Profile Setup"
# Start
run_cmd "minikube start -p project"

echo "Check Runtimes"
run_cmd "docker info | grep -i runtimes"
echo ""
echo "[Enter]"
read

echo "Profile Info"
run_cmd "minikube profile project"
echo ""
echo "[Enter]"
read
run_cmd "minikube profile list"
echo ""
echo "[Enter]"
read
run_cmd "docker ps --filter=\"name=project\""
echo ""
echo "[Enter]"
read

echo ">>> Refactor Cluster to 3 Nodes..."
# Start (3 nodes, containerd)
run_cmd "minikube delete -p project"
run_cmd "minikube start -p project --nodes=3 --cpus=2 --memory=2g --driver=docker --container-runtime=containerd"

run_cmd "kubectl get nodes -o wide"
echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[6] Running: Node Scaling"
echo "Add worker node..."
run_cmd "minikube -p project node add --worker=true"
run_cmd "kubectl get nodes -o wide"

echo "Delete node m04..."
run_cmd "minikube -p project node delete m04"

run_cmd "kubectl get nodes -o wide"
echo ""
echo "[Enter]"
read
run_cmd "minikube profile project"
echo ""
echo "[Enter]"
read
run_cmd "minikube profile list"
echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[7] Running: Advanced Inspection"
run_cmd "kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEMORY:.status.capacity.memory"

echo "Check GPU"
run_cmd "kubectl get nodes -o json | jq '[.items[] | {Name: .metadata.name, GPU: (.status.capacity[\"nvidia.com/gpu\"] == \"1\")}]'"

echo "SSH & Logs"
run_cmd "minikube ip -p project"
run_cmd "minikube ssh-key -p project"
run_cmd "minikube ssh -- hostname < /dev/null"
run_cmd "minikube ssh --node=project-m02 -- cat /etc/hosts < /dev/null"

echo ""
echo "[Enter]"
read

echo "-----------------------------------------------------"
echo "[8] Running: Addons (Dashboard & Metrics)"
run_cmd "minikube addons list"
run_cmd "minikube addons enable dashboard"

echo "Waiting for Dashboard to be ready..."
run_cmd "kubectl wait pod --all -n kubernetes-dashboard --for=condition=ready --timeout=300s"
run_cmd "kubectl get pod -n kubernetes-dashboard"
run-cmd "minikube dashboard &"
minikube dashboard &
echo "Dashboard started in background with PID: $DASH_PID"

echo "Waiting for Metrics Server..."
run_cmd "minikube addons enable metrics-server -p project"
run_cmd "kubectl wait pod -n kube-system -l \"k8s-app=metrics-server\" --for=condition=ready --timeout=300s"
run_cmd "kubectl get pod -n kube-system -l \"k8s-app=metrics-server\""

echo "Waiting for Metrics API to collect data..."
# Loop wait
run_cmd "until kubectl top node &>/dev/null; do echo \"Waiting for Kubernetes API...\"; sleep 5; done"

echo "TOP NODES"
run_cmd "kubectl top node"
echo ""
echo "[Enter]"
read

echo "TOP PODS"
run_cmd "kubectl top pod --all-namespaces"
echo ""
echo "[Enter]"
read
run_cmd "kubectl top pod -n kube-system --sort-by=cpu"
run_cmd "kubectl top pod -n kube-system --sort-by=memory"

echo "-----------------------------------------------------"
echo "[Enter to clean up]"
read

# Cleanup process dashboard
kill $DASH_PID 2>/dev/null
run_cmd "minikube stop -p project"
run_cmd "minikube delete -p project"

