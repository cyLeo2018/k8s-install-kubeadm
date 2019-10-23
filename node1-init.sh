#!/bin/bash 
# leo 20190812
# master节点一键初始化

echo "修改镜像tag"
docker image tag registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_node:v3.10.0 calico/node:v3.10.0
docker image tag registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_cni:v3.10.0 calico/cni:v3.10.0
docker image tag registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_kube-controllers:v3.10.0 calico/kube-controllers:v3.10.0
docker image tag registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_pod2daemon-flexvol:v3.10.0 calico/pod2daemon-flexvol:v3.10.0

echo "设置hostname与hosts"
hostnamectl set-hostname node1
cat >> /etc/hosts << EOF
172.18.222.171 node1
172.18.222.172 node2
172.18.222.173 node3
EOF

echo "开启ipvs"
yum -y install ipvsadm ipset bind-utils
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

echo "关swap、配置内核"
swapoff -a
sed -i 's/\/dev\/mapper\/centos-swap swap/#\/dev\/mapper\/centos-swap swap/g' /etc/fstab 
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness=0
EOF
sysctl -p /etc/sysctl.d/k8s.conf

echo "配置iptables forward默认策略"
iptables -P FORWARD ACCEPT

echo "修改docker cgroup"
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://ydfo52fm.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl restart docker 

echo "编辑kubernetes仓库"
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

echo "安装kubelet kubeadm kubectl"
yum -y install kubelet kubeadm kubectl

echo "初始化"
systemctl enable kubelet
kubeadm init --config kubeadm.yml
#kubeadm init --kubernetes-version=1.15.0 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.6.128 --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers

mkdir -p ~/.kube
cp -i /etc/kubernetes/admin.conf ~/.kube/config
chown $(id -u):$(id -g) ~/.kube/config 

#echo "安装flannel 网络插件"
#kubectl apply -f kube-flannel.yml 

echo "安装calico网络插件"
#wget https://docs.projectcalico.org/v3.10/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
#需要修改calico.yaml中的默认pod网段为10.244.0.0/16
# CALICO_IPV4POOL_CIDR 参数

kubectl apply -f calico.yaml

echo "查看状态"
kubectl get nodes 
kubectl get pods --all-namespaces -o wide
