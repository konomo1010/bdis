#!/bin/bash

# - ETCDKEEPER_USETLS=true
# - ETCDKEEPER_CACERT=etcd-ca.pem 
# - ETCDKEEPER_CERT=kube-etcd-healthcheck-client.pem
# - ETCDKEEPER_KEY=kube-etcd-healthcheck-client-key.pem
# - ETCDKEEPER_PORT=8080

if [ ${ETCDKEEPER_USETLS} == true ];then
    /root/etcdkeeper/etcdkeeper -usetls -p ${ETCDKEEPER_PORT} \
    -cacert /root/pki/${ETCDKEEPER_CACERT} \
    -cert /root/pki/${ETCDKEEPER_CERT} \
    -key /root/pki/${ETCDKEEPER_KEY}
 else
    /root/etcdkeeper/etcdkeeper -p ${ETCDKEEPER_PORT}
fi

