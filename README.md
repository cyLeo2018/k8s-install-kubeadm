# k8s-install-kubeadm
使用kubeadm部署kubernetes集群

# 实验环境
内网IP|主机名|备注
--|--|--
172.18.222.171|node1|master
172.18.222.172|node2|worker
172.18.222.173|node3|worker

```
image仓库地址：registry.cn-hangzhou.aliyuncs.com/google_containers
# pod子网：10.244.0.0/16
# service子网：10.96.0.0/12
```

# 步骤
## node1
```
git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
cd k8s-install-kubeadm
# bash install-docker.sh 18.09.8
bash install-docker.sh
# bash pull-image.sh
bash node1-init.sh > node1.log 2>&1 
```
# 暴露weavescope
```
# pod=$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')
# kubectl expose pod $pod -n weave --port=4040 --target-port=4040 --type=NodePort
```
- 通过日志找到以下语句(以实际为准)
```
kubeadm join 172.18.222.171:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
## node2
```
git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
cd k8s-install-kubeadm
# bash install-docker.sh 18.09.8
bash install-docker.sh
# bash pull-image.sh
bash node2-init.sh
kubeadm join 172.18.222.171:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
## node3
```
git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
cd k8s-install-kubeadm
# bash install-docker.sh 18.09.8
bash install-docker.sh
# bash pull-image.sh
bash node3-init.sh
kubeadm join 172.18.222.171:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:ffac755b9f184d0b9fe49f99c40a623b2d15eea0ea1684fab78a1442159ebfd0
```
# tips
# 1.kubeadm.yml中podSubnet参数要与calico.yaml中的CALICO_IPV4POOL_CIDR参数一致，处于同一网段
