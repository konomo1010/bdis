#!/bin/bash
cat > ${PKI_FILES_DIR}/kube-proxy-csr.json <<EOF
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
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_FILES_DIR}/kube-proxy-csr.json | cfssljson -bare ${PKI_FILES_DIR}/kube-proxy -
echo ""


echo "====> create kube-proxy.kubeconfig"
CERT_NAME=kube-proxy
CLUSTER_NAME=kubernetes
USER=default-proxy
KUBECONFIG_NAME=kube-proxy.kubeconfig
CONTEXT_NAME=kube-proxy
MASTER_ADDR=https://kube-apiserver
kubeconfig ${CERT_NAME} ${CLUSTER_NAME} ${USER} ${KUBECONFIG_NAME} ${CONTEXT_NAME} ${MASTER_ADDR}
echo ""


echo "====> create kube-proxy-config.yaml"
cat > ${PKI_FILES_DIR}/kube-proxy-config.yaml <<EOF
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
bindAddress: 0.0.0.0
clientConnection:
  acceptContentTypes: ""
  burst: 10
  contentType: application/vnd.kubernetes.protobuf
  kubeconfig: /var/lib/kube-proxy/kube-proxy.kubeconfig
  qps: 5
# 集群中 Pod IP 的 CIDR 范围
# clusterCIDR: ${CLUSTER_CIDR}
clusterCIDR: 10.1.0.0/16
configSyncPeriod: 15m0s
conntrack:
  # 每个核心最大能跟踪的NAT连接数，默认32768
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: 1h0m0s
  tcpEstablishedTimeout: 24h0m0s
enableProfiling: false
healthzBindAddress: 0.0.0.0:10256
iptables:
  # SNAT 所有 Service 的 CLUSTER IP
  masqueradeAll: false
  masqueradeBit: 14
  minSyncPeriod: 0s
  syncPeriod: 30s
ipvs:
  minSyncPeriod: 0s
  # ipvs 调度类型，默认是 rr，支持的所有类型:
  # rr: round-robin
  # lc: least connection
  # dh: destination hashing
  # sh: source hashing
  # sed: shortest expected delay
  # nq: never queue
  scheduler: rr
  syncPeriod: 30s
metricsBindAddress: 0.0.0.0:10249
# 使用 ipvs 模式转发 service
mode: ipvs
# 设置 kube-proxy 进程的 oom-score-adj 值，范围 [-1000,1000]
# 值越低越不容易被杀死，这里设置为 —999 防止发生系统OOM时将 kube-proxy 杀死
oomScoreAdj: -999
EOF
echo ""




echo "====> create kube-proxy configMap"
kubectl create cm -n kube-system system-kube-proxy \
--from-file=kube-proxy.kubeconfig=${PKI_FILES_DIR}/${KUBECONFIG_NAME} \
--from-file=kube-proxy-config.yaml=${PKI_FILES_DIR}/kube-proxy-config.yaml








