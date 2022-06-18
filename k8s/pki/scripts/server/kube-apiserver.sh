#!/bin/bash
echo "====> create kube-apiserver csr"
cat > ${PKI_FILES_DIR}/kube-apiserver-csr.json <<EOF
{
    "CN": "kube-apiserver",
    "hosts": [
      "10.1.0.1",
      "127.0.0.1",
      "192.168.1.101",
      "192.168.2.11",
      "kube-apiserver",
      "master.k8s.endpoint",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF



echo "====> create kube-apiserver certificate"
cfssl gencert \
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-server \
${PKI_FILES_DIR}/kube-apiserver-csr.json | cfssljson -bare ${PKI_FILES_DIR}/kube-apiserver - 
echo ""

echo "====> create kube-apiserver-kubelet-client csr"
cat > ${PKI_FILES_DIR}/kube-apiserver-kubelet-client-csr.json <<EOF
{
    "CN": "kube-apiserver-kubelet-client",
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


echo "====> create kube-apiserver-kubelet-client certificate"
cfssl gencert \
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_FILES_DIR}/kube-apiserver-kubelet-client-csr.json | cfssljson -bare ${PKI_FILES_DIR}/kube-apiserver-kubelet-client -
echo ""
