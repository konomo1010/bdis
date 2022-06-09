PKI_DIR=./pki/files


echo -n "====> kube-apiserver : "
curl -k \
--cacert ${PKI_DIR}/kubernetes-ca.pem \
--cert ${PKI_DIR}/cluster-admin.pem \
--key ${PKI_DIR}/cluster-admin-key.pem \
https://127.0.0.1:6443/healthz
echo ""

kubectl get --raw="/readyz?verbose"

# echo -n "====> kube-controller-manager : "
# curl -k \
# --cacert ${PKI_DIR}/kubernetes-ca.pem \
# --cert ${PKI_DIR}/cluster-admin.pem \
# --key ${PKI_DIR}/cluster-admin-key.pem \
# https://127.0.0.1:10257/healthz
# echo ""