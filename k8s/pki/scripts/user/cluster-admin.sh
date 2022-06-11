#!/bin/bash
echo "====> create cluster-admin csr"
cat > ${PKI_DIR}/cluster-admin-csr.json <<EOF
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
-ca=${PKI_DIR}/k8s-ca.pem \
-ca-key=${PKI_DIR}/k8s-ca-key.pem \
-config=${PKI_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_DIR}/cluster-admin-csr.json | cfssljson -bare ${PKI_DIR}/cluster-admin -
echo ""


echo "====> create cluster-admin kubeconfig"
kubeconfig cluster-admin kubernetes clusterAdmin cluster-admin.kubeconfig localk8
echo ""

if [ ! -d ~/.kube ];then
    mkdir ~/.kube
fi

cp -f ${PKI_DIR}/cluster-admin.kubeconfig ~/.kube/config