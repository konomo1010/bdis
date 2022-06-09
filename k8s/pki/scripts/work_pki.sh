# https://kubernetes.io/zh/docs/reference/access-authn-authz/node/
# https://kubernetes.io/zh/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/

PKI_DIR=../files
K8S_BIN_DIR=../../build/packages/kubernetes/server/bin



${K8S_BIN_DIR}/kubectl config set-cluster bootstrap \
--server='https://127.0.0.1:6443' \
--certificate-authority=${PKI_DIR}/k8s-ca.pem \
--embed-certs=true \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig



${K8S_BIN_DIR}/kubectl config set-credentials kubelet-bootstrap \
--token=`cut -d ',' -f1 ${PKI_DIR}/bootstrap-token.csv` \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig


${K8S_BIN_DIR}/kubectl config  set-context bootstrap \
--user=kubelet-bootstrap \
--cluster=bootstrap \
--kubeconfig=${PKI_DIR}/bootstrap.kubeconfig

${K8S_BIN_DIR}/kubectl config use-context bootstrap --kubeconfig=${PKI_DIR}/bootstrap.kubeconfig