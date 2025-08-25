#!/bin/bash
set -e
 
sudo hostnamectl set-hostname master
 
sudo kubeadm init --cri-socket=unix:///var/run/crio/crio.sock
# Configure kubeconfig for ubuntu user
sudo mkdir -p /home/ubuntu/.kube
sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
# Install Weave Net CNI
sudo -u ubuntu kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
# Wait until node is Ready
echo "Waiting for node to become Ready..."
until sudo -u ubuntu kubectl get nodes | grep -q ' Ready '; do
    sleep 5
done
# Remove control-plane taint
sudo -u ubuntu kubectl taint node $(hostname) node-role.kubernetes.io/control-plane:NoSchedule- || true
# Wait for kube-system pods
echo "Waiting for kube-system pods to be Ready..."
until sudo -u ubuntu kubectl get pods -n kube-system | grep -Ev 'STATUS|Running' | wc -l | grep -q '^0$'; do
    sleep 5
done
echo "Kubernetes control-plane setup complete."