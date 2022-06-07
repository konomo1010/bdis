# etcdkeeper 使用

```bash
wget https://github.com/evildecay/etcdkeeper/releases/download/v0.7.6/etcdkeeper-v0.7.6-linux_x86_64.zip


unzip etcdkeeper-v0.7.6-linux_x86_64.zip

./etcdkeeper -usetls  -h 192.168.1.101 -p 8080 \
 -cacert /root/k8s-deploy/etcd/pki/etcd-ca.pem \
 -cert /root/k8s-deploy/etcd/pki/kube-etcd-healthcheck-client.pem \
 -key /root/k8s-deploy/etcd/pki/kube-etcd-healthcheck-client-key.pem

```



```
https://etcd.svc.local:2379
```



