#!/bin/bash
cat > ${PKI_DIR}/kubelet_master-csr.json <<EOF
{
    "CN": "system:node:master",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "system:nodes",
            "OU": "System"
        }
    ]
}
EOF


echo "====> create kubelet node:master certificate"
cfssl gencert \
-ca=${PKI_DIR}/k8s-ca.pem \
-ca-key=${PKI_DIR}/k8s-ca-key.pem \
-config=${PKI_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_DIR}/kubelet_master-csr.json | cfssljson -bare ${PKI_DIR}/kubelet_master -
echo ""


echo "====> create kubelet node:master kubeconfig"
#CERT_NAME=$1 CLUSTER_NAME=$2 USER=$3 KUBECONFIG_NAME=$4 CONTEXT_NAME=$5
kubeconfig kubelet_master kubernetes system:node:master kubelet_master.kubeconfig system:node:master
echo ""

