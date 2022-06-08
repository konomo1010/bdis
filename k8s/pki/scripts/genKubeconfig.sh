 
PKI_DIR=../files
K8S_BIN_DIR=../../build/packages/kubernetes/server/bin


 # 设置集群参数
${K8S_BIN_DIR}/kubectl config set-cluster kubernetes \
--certificate-authority=${PKI_DIR}/k8s-ca.pem \
--embed-certs=true \
--server=https://127.0.0.1:6443 \
--kubeconfig=${PKI_DIR}/kubeconfig
  
# 设置客户端认证参数   会在 bootstrap.kubeconfig users 字段下添加内容 set-credentials   Set a user entry in kubeconfig
${K8S_BIN_DIR}/kubectl config set-credentials kubernetes \
--client-certificate=${PKI_DIR}/kube-apiserver-client.pem \
--client-key=${PKI_DIR}/kube-apiserver-client-key.pem \
--embed-certs=true \
--kubeconfig=${PKI_DIR}/kubeconfig

# 设置上下文参数      会在 bootstrap.kubeconfig contexts 字段下添加内容   账户 kubectl get sa -n kube-system
${K8S_BIN_DIR}/kubectl config set-context default \
--cluster=kubernetes \
--user=kubernetes \
--kubeconfig=${PKI_DIR}/kubeconfig

# 设置默认上下文
${K8S_BIN_DIR}/kubectl config use-context default \
--kubeconfig=${PKI_DIR}/kubeconfig

if [ ! -d ~/.kube ];then
    mkdir ~/.kube
fi
cp -f ${PKI_DIR}/kubeconfig ~/.kube/config
