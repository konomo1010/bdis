[toc]



---





# 部署说明



客户端 ， etcd 集群 peer 都使用 TLS 通信，所以需要规划证书签名请求csr。参考 `pki.sh`



* 目录参考

  ```bash
  [root@k8-master-01 k8s-deploy]# tree etcd
  etcd
  ├── docker-compose.yml
  ├── docker-compose.yml.bak
  ├── pkg
  │   ├── Dockerfile
  │   ├── entrypoint.sh
  │   ├── etcd-conf.yaml
  │   └── etcd-v3.5.4-linux-amd64.tar.gz
  ├── pki
  │   ├── etcd-ca-config.json
  │   ├── etcd-ca.csr
  │   ├── etcd-ca-csr.json
  │   ├── etcd-ca-key.pem
  │   ├── etcd-ca.pem
  │   ├── etcd-client.csr
  │   ├── etcd-client-csr.json
  │   ├── etcd-client-key.pem
  │   ├── etcd-client.pem
  │   ├── etcd-peer.csr
  │   ├── etcd-peer-csr.json
  │   ├── etcd-peer-key.pem
  │   ├── etcd-peer.pem
  │   ├── kube-apiserver-etcd-client.csr
  │   ├── kube-apiserver-etcd-client-csr.json
  │   ├── kube-apiserver-etcd-client-key.pem
  │   ├── kube-apiserver-etcd-client.pem
  │   ├── kube-etcd-healthcheck-client.csr
  │   ├── kube-etcd-healthcheck-client-csr.json
  │   ├── kube-etcd-healthcheck-client-key.pem
  │   ├── kube-etcd-healthcheck-client.pem
  │   └── pki.sh
  └── README.md
  ```

  



```bash
wget https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
docker build -t konomo/etcd . -f Dockerfile

mkdir -p /data/etcd-0{1..3}


```

## Etcd 参考说明

```bash
--advertise-client-urls 就是客户端(etcdctl/curl等)跟etcd服务进行交互时请求的url 默认是 http://localhost:2379  可以设置: http://0.0.0.0:2379
--listen-client-urls   这个参数是etcd服务器自己监听时用的，也就是说，监听本机上的哪个网卡，哪个端口. 默认是 http://localhost:2379 可以设置: http://0.0.0.0:2379

说明etcdctl的底层逻辑，应该是调用curl跟etcd服务进行交换


```



# ETCD 连通性测试



## v2

```bash
export ETCDCTL_API=2
ETCD_PKI_DIR=/root/k8s-deploy/etcd/pki
etcdctl \
--endpoints=https://127.0.0.1:2379 \
--ca-file=${ETCD_PKI_DIR}/etcd-ca.pem \
--key-file=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client-key.pem \
--cert-file=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client.pem \
ls /
```



## v3



```bash
域名为 csr 里规划的域名。 如果是本机可以用127.0.0.1 如果是局域网内其他机器建议使用域名

export ETCDCTL_API=3
ETCD_PKI_DIR=/root/k8s-deploy/etcd/pki
etcdctl --endpoints=https://etcd.svc.local:2379 \
--cacert=${ETCD_PKI_DIR}/etcd-ca.pem \
--cert=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client.pem \
--key=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client-key.pem \
get / --prefix --keys-only


export ETCDCTL_API=3
ETCD_PKI_DIR=/root/k8s-deploy/etcd/pki
etcdctl --endpoints=https://etcd.svc.local:2379 \
--cacert=${ETCD_PKI_DIR}/etcd-ca.pem \
--cert=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client.pem \
--key=${ETCD_PKI_DIR}/kube-etcd-healthcheck-client-key.pem \
member list 
```

