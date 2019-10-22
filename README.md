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
pod子网：10.244.0.0/16
service子网：10.96.0.0/12
```

# 步骤

```
# git clone https://github.com/cyLeo2018/k8s-install-kubeadm.git
# cd k8s-install-kubeadm
# bash install-docker.sh 18.09.8
# bash master-node-init.sh
```
