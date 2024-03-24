#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
echo $DIR
export PKI_FILES_DIR=./pki/files
export PKI_SCRIPTS_DIR=./pki/scripts
export K8S_BIN_DIR=./build/packages/kubernetes/server/bin
export MANIFEST_DIR=./manifest

export DOCKERIMAGE_BUILD_DIR=../baseimage
export ETCD_BUILD_DIR=../etcd/build
export ETCD_PKI_DIR=../etcd/pki

export K8S_DOCKER_BUILD_DIR=./build



source ${PKI_SCRIPTS_DIR}/func/kubeconfig_gen.sh

if [ ! -d ${PKI_FILES_DIR} ];then
    mkdir -p ${PKI_FILES_DIR}
fi

################### 环境检查
#### containerd
#### docker
#### docker-compose
#### cfssl cfssljson


################### 构建 docker 镜像
### 构建 baseimage
cd ${DOCKERIMAGE_BUILD_DIR}
. build.sh baseimage

### 构建 etcd
echo $DIR
cd ${ETCD_BUILD_DIR}
. build.sh
cd ${DIR}



### 构建 k8s 组件
cd ${DIR}
cd ${K8S_DOCKER_BUILD_DIR}
. build.sh all