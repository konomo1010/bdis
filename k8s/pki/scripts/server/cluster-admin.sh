#!/bin/bash
echo "====> create cluster-admin csr"
cat > ${PKI_FILES_DIR}/cluster-admin-csr.json <<EOF
{
    "CN": "kubernetes-admin",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "system:masters",
            "OU": "System"
        }
    ]
}
EOF

echo "====> create cluster-admin certificate"
cfssl gencert \
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_FILES_DIR}/cluster-admin-csr.json | cfssljson -bare ${PKI_FILES_DIR}/cluster-admin -
echo ""


echo "====> create cluster-admin kubeconfig"
# kubeconfig cluster-admin kubernetes clusterAdmin cluster-admin.kubeconfig localk8
CERT_NAME=cluster-admin
CLUSTER_NAME=kubernetes
USER=clusterAdmin
KUBECONFIG_NAME=cluster-admin.kubeconfig
CONTEXT_NAME=localk8
MASTER_ADDR=https://127.0.0.1:6443
kubeconfig ${CERT_NAME} ${CLUSTER_NAME} ${USER} ${KUBECONFIG_NAME} ${CONTEXT_NAME} ${MASTER_ADDR}
echo ""

if [ ! -d ~/.kube ];then
    mkdir ~/.kube
fi

echo "copy cluster-admin.kubeconfig    ~/.kube/config "
cp -f ${PKI_FILES_DIR}/cluster-admin.kubeconfig ~/.kube/config