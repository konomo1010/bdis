#!/bin/bash
K8S_PKI_DIR=/root/pki/k8s

# - BIND_ADDRESS=0.0.0.0
# - SECURE_PORT=10259
# - MASTER=https://kube-apiserver:6443
# - TLS_CERT_FILE=kube-scheduler.pem
# - TLS_PRIVATE_KEY_FILE=kube-scheduler-key.pem
# - AUTHENTICATION_KUBECONFIG=kube-scheduler.kubeconfig
# - AUTHORIZATION_KUBECONFIG=kube-scheduler.kubeconfig
# - KUBECONFIG=kube-scheduler.kubeconfig


/root/kube-scheduler \
--v=2 \
--leader-elect=true \
--bind-address=${BIND_ADDRESS} \
--secure-port=${SECURE_PORT} \
--master=${MASTER} \
--tls-cert-file=${K8S_PKI_DIR}/${TLS_CERT_FILE} \
--tls-private-key-file=${K8S_PKI_DIR}/${TLS_PRIVATE_KEY_FILE} \
--authentication-kubeconfig=${K8S_PKI_DIR}/${AUTHENTICATION_KUBECONFIG} \
--authorization-kubeconfig=${K8S_PKI_DIR}/${AUTHORIZATION_KUBECONFIG} \
--kubeconfig=${K8S_PKI_DIR}/${KUBECONFIG}