#!/bin/bash

K8S_PKI_DIR=/root/pki/k8s

# - BIND_ADDRESS=0.0.0.0
# - MASTER=https://kube-apiserver:6443
# - HOSTNAME_OVERRIDE=master
# - KUBECONFIG=kube-proxy.kubeconfig

/root/kube-proxy \
--bind-address=${BIND_ADDRESS} \
--master=${MASTER} \
--hostname-override=${HOSTNAME_OVERRIDE} \
--kubeconfig=${K8S_PKI_DIR}/${KUBECONFIG} \
--masquerade-all \
--proxy-mode=ipvs \
--ipvs-min-sync-period=5s \
--ipvs-sync-period=5s \
--ipvs-scheduler=rr \
--v=2