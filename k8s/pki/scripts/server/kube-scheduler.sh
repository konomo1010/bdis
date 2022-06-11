#!/bin/bash
echo "====> create kube-scheduler csr"
cat > ${PKI_DIR}/kube-scheduler-csr.json <<EOF
{
    "CN": "system:kube-scheduler",
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

echo "====> create kube-scheduler certificate"
cfssl gencert \
-ca=${PKI_DIR}/k8s-ca.pem \
-ca-key=${PKI_DIR}/k8s-ca-key.pem \
-config=${PKI_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_DIR}/kube-scheduler-csr.json | cfssljson -bare ${PKI_DIR}/kube-scheduler -
echo ""




echo "====> create kube-scheduler kubeconfig"
kubeconfig kube-scheduler kubernetes default-scheduler kube-scheduler.kubeconfig kube-scheduler
echo ""
