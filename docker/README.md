# 安装
## 下载地址
* https://download.docker.com/linux/static/stable/x86_64/


```bash
timedatectl set-timezone Asia/Shanghai


yum remove docker-ce
rm -fr /usr/bin/docker

yum remove libseccomp -y
rm -fr /usr/bin/containerd
rm -fr /usr/bin/runc

mkdir ./packages && cd ./packages

wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz

# 下载containerd依赖。libseccomp  版本要大于 2.3
wget http://rpmfind.net/linux/centos/8-stream/BaseOS/x86_64/os/Packages/libseccomp-2.5.1-1.el8.x86_64.rpm

# 下载containerd
wget https://github.com/containerd/containerd/releases/download/v1.6.4/cri-containerd-cni-1.6.4-linux-amd64.tar.gz


rpm -ivh libseccomp-2.5.1-1.el8.x86_64.rpm

[root@master ~]# tar xfzv docker-20.10.9.tgz 
docker/
docker/containerd-shim-runc-v2
docker/dockerd
docker/docker-proxy
docker/ctr
docker/docker
docker/runc
docker/containerd-shim
docker/docker-init
docker/containerd

cp -f docker/docker* /usr/local/sbin/



tar xfzv cri-containerd-cni-1.6.4-linux-amd64.tar.gz --no-overwrite-dir -C /

cp ../config.toml /etc/containerd/config.toml

cp -f ../containerd.service /etc/systemd/system/containerd.service
cp -f ../docker.service /etc/systemd/system/docker.service

systemctl daemon-reload

systemctl enable --now containerd

# yum install -y yum-utils device-mapper-persistent-data lvm2
systemctl enable --now docker

mkdir -p /etc/docker


#  修改 Cgroup Driver: systemd
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "debug":true,
  "registry-mirrors":["https://docker.mirrors.ustc.edu.cn/"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "default-runtime":"runc",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF


wget -O /usr/local/sbin/docker-compose https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64

chmod +x /usr/local/sbin/docker-compose


yum install -y chrony

[root@master k8s]# grep -Ev "#|^$" /etc/chrony.conf
server ntp.aliyun.com iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
allow 192.168.0.0/16
logdir /var/log/chrony


[root@master k8s]# chronyc sources -v




```