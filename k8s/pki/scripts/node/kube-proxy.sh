#!/bin/bash
cat > ${PKI_DIR}/kube-proxy-csr.json <<EOF
{
    "CN": "system:kube-proxy",
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


echo "====> kube-proxy"
cfssl gencert \
-ca=${PKI_DIR}/k8s-ca.pem \
-ca-key=${PKI_DIR}/k8s-ca-key.pem \
-config=${PKI_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_DIR}/kube-proxy-csr.json | cfssljson -bare ${PKI_DIR}/kube-proxy -
echo ""


echo "====> create kube-proxy.kubeconfig"
kubeconfig kube-proxy kubernetes default-proxy kube-proxy.kubeconfig kube-proxy
echo ""
