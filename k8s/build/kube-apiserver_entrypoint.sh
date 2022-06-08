#!/bin/bash

ETCD_PKI_DIR=/root/pki/etcd
K8S_PKI_DIR=/root/pki/k8s

# - BIND_ADDRESS=192.168.1.101
# - ADVERTISE_ADDRESS=192.168.1.101
# - SECURE_PORT=6443
# - SERVICE_CLUSTER_IP_RANGE=10.1.0.0/16
# - ETCD_SERVERS=https://etcd.svc.local:2379
# - TOKEN_AUTH_FILE=bootstrap-token.csv
# - ETCD_CAFILE=etcd-ca.pem
# - ETCD_CERTFILE=kube-apiserver-etcd-client.pem
# - ETCD_KEYFILE=kube-apiserver-etcd-client-key.pem
# - CLIENT_CA_FILE=kubernetes-ca.pem
# - SERVICE_ACCOUNT_KEY_FILE=kubernetes-ca-key.pem
# - SERVICE_ACCOUNT_SIGNING_KEY_FILE=kubernetes-ca-key.pem
# - SERVICE_ACCOUNT_ISSUER=konomo
# - TLS_CERT_FILE=kube-apiserver.pem
# - TLS_PRIVATE_KEY_FILE=kube-apiserver-key.pem
# - KUBELET_CLIENT_CERTIFICATE=kube-apiserver-kubelet-client.pem
# - KUBELET_CLIENT_KEY=kube-apiserver-kubelet-client-key.pem
# - REQUESTHEADER_CLIENT_CA_FILE=kubernetes-front-proxy-ca.pem
# - PROXY_CLIENT_CERT_FILE=front-proxy-client.pem
# - PROXY_CLIENT_KEY_FILE=front-proxy-client-key.pem


/root/kube-apiserver \
--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota,NodeRestriction \
--allow-privileged=true \
--v=2 \
--service-node-port-range=1-65500 \
--authorization-mode=Node,RBAC \
--anonymous-auth=false \
--enable-bootstrap-token-auth \
--bind-address=${BIND_ADDRESS} \
--advertise-address=${ADVERTISE_ADDRESS} \
--secure-port=${SECURE_PORT} \
--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
--token-auth-file=${K8S_PKI_DIR}/${TOKEN_AUTH_FILE} \
--etcd-servers=${ETCD_SERVERS} \
--etcd-cafile=${ETCD_PKI_DIR}/${ETCD_CAFILE} \
--etcd-certfile=${ETCD_PKI_DIR}/${ETCD_CERTFILE} \
--etcd-keyfile=${ETCD_PKI_DIR}/${ETCD_KEYFILE} \
--client-ca-file=${K8S_PKI_DIR}/${CLIENT_CA_FILE} \
--service-account-key-file=${K8S_PKI_DIR}/${SERVICE_ACCOUNT_KEY_FILE} \
--service-account-signing-key-file=${K8S_PKI_DIR}/${SERVICE_ACCOUNT_SIGNING_KEY_FILE} \
--service-account-issuer=${SERVICE_ACCOUNT_ISSUER} \
--tls-cert-file=${K8S_PKI_DIR}/${TLS_CERT_FILE} \
--tls-private-key-file=${K8S_PKI_DIR}/${TLS_PRIVATE_KEY_FILE} \
--kubelet-client-certificate=${K8S_PKI_DIR}/${KUBELET_CLIENT_CERTIFICATE} \
--kubelet-client-key=${K8S_PKI_DIR}/${KUBELET_CLIENT_KEY} \
--requestheader-client-ca-file=${K8S_PKI_DIR}/${REQUESTHEADER_CLIENT_CA_FILE} \
--proxy-client-cert-file=${K8S_PKI_DIR}/${PROXY_CLIENT_CERT_FILE} \
--proxy-client-key-file=${K8S_PKI_DIR}/${PROXY_CLIENT_KEY_FILE}
