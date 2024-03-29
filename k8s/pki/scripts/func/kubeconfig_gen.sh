#!/bin/bash

function kubeconfig() {
    CERT_NAME=$1
    CLUSTER_NAME=$2
    USER=$3
    KUBECONFIG_NAME=$4
    CONTEXT_NAME=$5
    MASTER_ADDR=$6
    which kubectl
    if [ $? == 0 ];then
      K8S_BIN_DIR=`which kubectl | awk -F '/kubectl' '{print $1}'`
    fi
    # 设置集群
    ${K8S_BIN_DIR}/kubectl config set-cluster ${CLUSTER_NAME} \
    --certificate-authority=${PKI_FILES_DIR}/k8s-ca.pem \
    --embed-certs=true \
    --server=${MASTER_ADDR} \
    --kubeconfig=${PKI_FILES_DIR}/${KUBECONFIG_NAME}
    
    # 设置
    ${K8S_BIN_DIR}/kubectl config set-credentials ${USER} \
    --client-certificate=${PKI_FILES_DIR}/${CERT_NAME}.pem \
    --client-key=${PKI_FILES_DIR}/${CERT_NAME}-key.pem \
    --embed-certs=true \
    --kubeconfig=${PKI_FILES_DIR}/${KUBECONFIG_NAME}

    # 设置上下文
    ${K8S_BIN_DIR}/kubectl config set-context ${CONTEXT_NAME} \
    --cluster=${CLUSTER_NAME} \
    --user=${USER} \
    --kubeconfig=${PKI_FILES_DIR}/${KUBECONFIG_NAME}

    # 设置当前使用的上下文
    ${K8S_BIN_DIR}/kubectl config use-context ${CONTEXT_NAME} \
    --kubeconfig=${PKI_FILES_DIR}/${KUBECONFIG_NAME}

}


