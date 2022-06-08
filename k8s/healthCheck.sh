PKI_DIR=./pki/files


echo -n "====> kube-apiserver : "
curl -k \
--cacert ${PKI_DIR}/kubernetes-ca.pem \
--cert ${PKI_DIR}/kube-apiserver-client.pem \
--key ${PKI_DIR}/kube-apiserver-client-key.pem \
https://127.0.0.1:6443/healthz
echo ""


echo -n "====> kube-controller-manager : "
curl -k \
--cacert ${PKI_DIR}/kubernetes-ca.pem \
--cert ${PKI_DIR}/kube-apiserver-client.pem \
--key ${PKI_DIR}/kube-apiserver-client-key.pem \
https://127.0.0.1:10257/healthz
echo ""