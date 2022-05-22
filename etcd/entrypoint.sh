#!/bin/bash

ETCD_CONFIG_FILE=/root/conf/etcd-conf.yaml

etcd_env_vars=(
    NAME
    DATA_DIR
    LISTEN_PEER_URLS
    LISTEN_CLIENT_URLS
    INITIAL_ADVERTISE_PEER_URLS
    ADVERTISE_CLIENT_URLS
    INITIAL_CLUSTER
    INITIAL_CLUSTER_TOKEN
    INITIAL_CLUSTER_STATE
    CLIENT_AUTO_TLS
    CLIENT_CLIENT_CERT_AUTH
    CLIENT_CERT_FILE
    CLIENT_KEY_FILE
    CLIENT_TRUSTED_CA_FILE
    PEER_AUTO_TLS
    PEER_CLIENT_CERT_AUTH
    PEER_CERT_FILE
    PEER_KEY_FILE
    PEER_TRUSTED_CA_FILE
    ENABLE_PPROF
    LOG_LEVEL
    LOGGER
    LOG_OUTPUTS
)


for env_var in "${etcd_env_vars[@]}"; do
    if [ -n ${!env_var} ]; then
        sed -i 's#${'"${env_var}"'}#'"${!env_var}"'#g' ${ETCD_CONFIG_FILE}
    fi 
done

/root/etcd/etcd --config-file=${ETCD_CONFIG_FILE}

