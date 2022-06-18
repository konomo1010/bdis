#!/bin/bash
echo "====> create kube-controller-manager csr"
cat > ${PKI_FILES_DIR}/kube-controller-manager-csr.json <<EOF
{
    "CN": "system:kube-controller-manager",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "OU": "System"
        }
    ]
}
EOF

echo "====> create kube-controller-manager certificate"
cfssl gencert \
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_FILES_DIR}/kube-controller-manager-csr.json | cfssljson -bare ${PKI_FILES_DIR}/kube-controller-manager -
echo ""

echo "====> create kube-controller-manager kubeconfig"
# kubeconfig kube-controller-manager kubernetes default-controller-manager kube-controller-manager.kubeconfig kube-controller-manager
CERT_NAME=kube-controller-manager
CLUSTER_NAME=kubernetes
USER=default-controller-manager
KUBECONFIG_NAME=kube-controller-manager.kubeconfig
CONTEXT_NAME=kube-controller-manager
MASTER_ADDR=https://127.0.0.1:6443
kubeconfig ${CERT_NAME} ${CLUSTER_NAME} ${USER} ${KUBECONFIG_NAME} ${CONTEXT_NAME} ${MASTER_ADDR}
echo ""
