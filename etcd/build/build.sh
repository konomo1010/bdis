#!/bin/bash
# wget cfssl https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl-bundle_1.6.1_linux_amd64

package_dir=./packages
download_url=https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
package_name=etcd-v3.5.4-linux-amd64.tar.gz
docker_registry=swr.cn-north-4.myhuaweicloud.com/wenxl
if [ ! -d ${package_dir} ];then
    mkdir -p ${package_dir}
fi

if [ ! -e ${package_dir}/${package_name} ];then
    wget -P ${package_dir} ${download_url}
fi

docker build --rm --no-cache -t ${docker_registry}/etcd:v1 . -f Dockerfile
# mkdir -p /data/etcd-0{1..3}

# 清理 dangling image
if [ `docker images -f "dangling=true" -q|wc -l` -gt 0 ];then
    docker rmi $(docker images -f "dangling=true" -q)
fi
