# k8s-install-kubeadm
- 使用kubeadm部署kubernetes集群
- 当前最新版本为1.18.4
- 但是国内阿里的镜像仓库只更新到1.18.2

# 实验环境
内网IP|主机名|备注
--|--|--
192.168.65.128|k8s-node0|master
192.168.65.129|k8s-node1|worker
192.168.65.130|k8s-node2|worker

```
image仓库地址：registry.cn-hangzhou.aliyuncs.com/google_containers
# pod子网：10.244.0.0/16
# service子网：10.96.0.0/12
```

# 步骤
## k8s-node0
- 编辑/etc/hosts
```
192.168.65.128 k8s-node0
192.168.65.129 k8s-node1
192.168.65.130 k8s-node2
```
```
# git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
# cd k8s-install-kubeadm
# bash install-docker.sh
# bash pull-image.sh
# nohup bash -x node0-init.sh > node0.log 2>&1 &
```
- 暴露weavescope
```
# pod=$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')
# kubectl expose pod $pod -n weave --port=4040 --target-port=4040 --type=NodePort
- 访问weave ui
```
http://192.168.65.128:4040
```
```
- 通过日志node0.log找到以下语句(以实际为准)
```
kubeadm join 192.168.65.128:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
## k8s-node1
- 编辑/etc/hosts
```
192.168.65.128 k8s-node0
192.168.65.129 k8s-node1
192.168.65.130 k8s-node2
```
```
# git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
# cd k8s-install-kubeadm
# bash install-docker.sh
# bash pull-image.sh
# nohup bash -x node1-init.sh > node1.log 2>&1 &
# kubeadm join 192.168.65.128:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
## k8s-node2
- 编辑/etc/hosts
```
192.168.65.128 k8s-node0
192.168.65.129 k8s-node1
192.168.65.130 k8s-node2
```
```
# git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
# cd k8s-install-kubeadm
# bash install-docker.sh
# bash pull-image.sh
# nohup bash -x node2-init.sh > node2.log 2>&1 &
kubeadm join 192.168.65.128:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
# tips

