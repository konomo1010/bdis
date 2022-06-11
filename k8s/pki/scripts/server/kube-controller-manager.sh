#!/bin/bash
echo "====> create kube-controller-manager csr"
cat > ${PKI_DIR}/kube-controller-manager-csr.json <<EOF
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
-ca=${PKI_DIR}/k8s-ca.pem \
-ca-key=${PKI_DIR}/k8s-ca-key.pem \
-config=${PKI_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_DIR}/kube-controller-manager-csr.json | cfssljson -bare ${PKI_DIR}/kube-controller-manager -
echo ""

echo "====> create kube-controller-manager kubeconfig"
kubeconfig kube-controller-manager kubernetes default-controller-manager kube-controller-manager.kubeconfig kube-controller-manager
echo ""
