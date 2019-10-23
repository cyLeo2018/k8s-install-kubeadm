#!/bin/bash
# leo 20190923
# 镜像一键下载

images=(
  #calico官方镜像下载速度很慢，使用自己配置的阿里云镜像仓库
  #calico/node:v3.10.0
  #calico/cni:v3.10.0
  #calico/kube-controllers:v3.10.0
  #calico/pod2daemon-flexvol:v3.10.0  
  
  registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_node:v3.10.0
  registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_cni:v3.10.0
  registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_kube-controllers:v3.10.0
  registry.cn-shenzhen.aliyuncs.com/k8s-install-kubeadm/calico_pod2daemon-flexvol:v3.10.0
  
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.16.0
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.16.0
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.16.0
  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.16.0
  registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.15-0
  registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2
  registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
)

for imageName in ${images[@]} ; do
    docker pull $imageName
done
