#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
echo $DIR
export PKI_FILES_DIR=./pki/files
export PKI_SCRIPTS_DIR=./pki/scripts
export K8S_BIN_DIR=./build/packages/kubernetes/server/bin
export MANIFEST_DIR=./manifest

export K8S_DOCKER_BUILD_DIR=./build
export DOCKERIMAGE_BUILD_DIR=../baseimage


source ${PKI_SCRIPTS_DIR}/func/kubeconfig_gen.sh

if [ ! -d ${PKI_FILES_DIR} ];then
    mkdir -p ${PKI_FILES_DIR}
fi




################### 构建 docker 镜像
### 构建 baseimage
cd ${DOCKERIMAGE_BUILD_DIR}
. build.sh baseimage

### 构建 k8s 组件
echo $DIR
cd ${DIR}
cd ${K8S_DOCKER_BUILD_DIR}
. build.sh all

# 创建证书
cd $DIR
. ${PKI_SCRIPTS_DIR}/clear.sh
. ${PKI_SCRIPTS_DIR}/pki.sh all

# 启动 master 三大组件

# 启动 kube-proxy

# node join

