#! /usr/bin/env bash 
# leo 20190812
# docker YUM一键安装
# 安装最新版 		./docker-install.sh 
# 安装指定旧版本 	./docker-install.sh 18.09.8

echo "安装关联工具..."
yum install -y yum-utils device-mapper-persistent-data lvm2

echo "添加阿里yum源..."
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

echo "开启旧版本仓库"
yum-config-manager --enable docker-ce-edge

echo "更新缓存..."
yum makecache fast

if [ $# -eq 1 ]
then
  echo "安装docker-ce-$1"
  yum -y install docker-ce-$1
  yum -y install docker-ce-cli-$1
else 
  echo "安装最新版docker-ce"
  yum -y install docker-ce
  yum -y install docker-ce-cli
fi 

echo "开机启动..."
systemctl enable docker

echo "镜像加速..."
mkdir -p /etc/docker
cat >> /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://ydfo52fm.mirror.aliyuncs.com"]
}
EOF

echo "启动docker..."
systemctl start docker

docker version
docker info
