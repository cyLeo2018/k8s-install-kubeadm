#!/bin/bash
# leo 20200624
# 镜像一键下载

images=(
  #calico官方镜像下载速度很慢，使用自己配置的阿里云镜像仓库
  #calico/node:v3.10.0
  #calico/cni:v3.10.0
  #calico/kube-controllers:v3.10.0
  #calico/pod2daemon-flexvol:v3.10.0  
  
  #registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_node:v3.10.0
  #registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_cni:v3.10.0
  #registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_kube-controllers:v3.10.0
  #registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_pod2daemon-flexvol:v3.10.0
  
  # 使用kubeadm config images list --kubernetes-version=v1.18.2 查看各个组件的版本，然后更新到下面
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.18.2
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.18.2
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.18.2
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.18.2
  registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.4.3-0
  registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.7
  registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2
)

for imageName in ${images[@]} ; do
    docker image pull $imageName
done
