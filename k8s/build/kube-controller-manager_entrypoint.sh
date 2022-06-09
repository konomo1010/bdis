#!/bin/bash
K8S_PKI_DIR=/root/pki/k8s

# - CLUSTER_NAME=kubernetes
# - BIND_ADDRESS=0.0.0.0
# - SECURE_PORT=10257
# - MASTER=https://kube-apiserver:6443
# - SERVICE_CLUSTER_IP_RANGE=10.1.0.0/16
# - CLUSTER_CIDR=10.1.0.0/16
# - REQUESTHEADER_CLIENT_CA_FILE=k8s-ca.pem
# - CLIENT_CA_FILE=k8s-ca.pem
# - CLUSTER_SIGNING_CERT_FILE=k8s-ca.pem
# - CLUSTER_SIGNING_KEY_FILE=k8s-ca-key.pem
# - TLS_CERT_FILE=kube-controller-manager.pem
# - TLS_PRIVATE_KEY_FILE=kube-controller-manager-key.pem
# - ROOT_CA_FILE=k8s-ca.pem
# - SERVICE_ACCOUNT_PRIVATE_KEY_FILE=k8s-ca-key.pem
# - AUTHENTICATION_KUBECONFIG=kube-controller-manager.kubeconfig
# - AUTHORIZATION_KUBECONFIG=kube-controller-manager.kubeconfig
# - KUBECONFIG=kube-controller-manager.kubeconfig

/root/kube-controller-manager \
--leader-elect=true \
--v=2 \
--cluster-signing-duration=876000h \
--use-service-account-credentials \
--controllers=*,bootstrapsigner,tokencleaner \
--requestheader-allowed-names="" \
--requestheader-extra-headers-prefix="X-Remote-Extra-" \
--requestheader-group-headers=X-Remote-Group \
--requestheader-username-headers=X-Remote-User \
--cluster-name=${CLUSTER_NAME} \
--bind-address=${BIND_ADDRESS} \
--secure-port=${SECURE_PORT} \
--master=${MASTER} \
--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
--cluster-cidr=${CLUSTER_CIDR} \
--requestheader-client-ca-file=${K8S_PKI_DIR}/${REQUESTHEADER_CLIENT_CA_FILE} \
--client-ca-file=${K8S_PKI_DIR}/${CLIENT_CA_FILE} \
--cluster-signing-cert-file=${K8S_PKI_DIR}/${CLUSTER_SIGNING_CERT_FILE} \
--cluster-signing-key-file=${K8S_PKI_DIR}/${CLUSTER_SIGNING_KEY_FILE} \
--tls-cert-file=${K8S_PKI_DIR}/${TLS_CERT_FILE} \
--tls-private-key-file=${K8S_PKI_DIR}/${TLS_PRIVATE_KEY_FILE} \
--root-ca-file=${K8S_PKI_DIR}/${ROOT_CA_FILE} \
--service-account-private-key-file=${K8S_PKI_DIR}/${SERVICE_ACCOUNT_PRIVATE_KEY_FILE} \
--authentication-kubeconfig=${K8S_PKI_DIR}/${AUTHENTICATION_KUBECONFIG} \
--authorization-kubeconfig=${K8S_PKI_DIR}/${AUTHORIZATION_KUBECONFIG} \
--kubeconfig=${K8S_PKI_DIR}/${KUBECONFIG}
