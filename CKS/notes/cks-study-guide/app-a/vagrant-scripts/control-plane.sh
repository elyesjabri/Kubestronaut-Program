#!/usr/bin/env bash

POD_CIDR=$1
API_ADV_ADDRESS=$2

kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

# deb packages for kubelet on pkgs.k8s.io seem to include a systemd service definition for redhat machines #3276
# apply same sed fix as in https://github.com/kubernetes/release/pull/3279
sed -i 's;/etc/sysconfig/kubelet;/etc/default/kubelet;g' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
echo "KUBELET_EXTRA_ARGS=--node-ip=$API_ADV_ADDRESS --cgroup-driver=systemd" > /etc/default/kubelet
systemctl restart kubelet

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml
sed -i 's~cidr: 192\.168\.0\.0/16~cidr: 172\.18\.0\.0/16~g' custom-resources.yaml
kubectl create -f custom-resources.yaml
rm custom-resources.yaml

cp /etc/kubernetes/admin.conf /vagrant/admin.conf