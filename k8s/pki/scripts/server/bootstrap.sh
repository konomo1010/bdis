#!/bin/bash
echo "====> bootstrap-token.csv"
echo "`openssl rand -hex 16`,kubelet-bootstrap,10001,"system:kubelet-bootstrap"" > ${PKI_DIR}/bootstrap-token.csv
echo ""

${K8S_BIN_DIR}/kubectl config set-cluster bootstrap \
--server='https://kube-apiserver:6443' \
--certificate-authority=${PKI_DIR}/k8s-ca.pem \
--embed-certs=true \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig



${K8S_BIN_DIR}/kubectl config set-credentials kubelet-bootstrap \
--token=`cut -d ',' -f1 ${PKI_DIR}/bootstrap-token.csv` \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig


${K8S_BIN_DIR}/kubectl config  set-context bootstrap \
--user=kubelet-bootstrap \
--cluster=bootstrap \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig

${K8S_BIN_DIR}/kubectl config use-context bootstrap --kubeconfig=${PKI_DIR}/bootstrap.kubeconfig