 
 PKI_DIR=../pki/files
 
 # 设置集群参数
./packages/kubernetes/server/bin/kubectl config set-cluster kubernetes \
--certificate-authority=${PKI_DIR}/k8s-ca.pem \
--embed-certs=true \
--server=https://127.0.0.1:6443 \
--kubeconfig=./kubeconfig
  
# 设置客户端认证参数   会在 bootstrap.kubeconfig users 字段下添加内容 set-credentials   Set a user entry in kubeconfig
./packages/kubernetes/server/bin/kubectl config set-credentials kubernetes \
--client-certificate=${PKI_DIR}/kube-apiserver-kubelet-client.pem \
--client-key=${PKI_DIR}/kube-apiserver-kubelet-client-key.pem \
--embed-certs=true \
--kubeconfig=./kubeconfig

# 设置上下文参数      会在 bootstrap.kubeconfig contexts 字段下添加内容   账户 kubectl get sa -n kube-system
./packages/kubernetes/server/bin/kubectl config set-context default \
--cluster=kubernetes \
--user=kubernetes \
--kubeconfig=./kubeconfig

# 设置默认上下文
./packages/kubernetes/server/bin/kubectl config use-context default \
--kubeconfig=./kubeconfig