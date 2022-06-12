#!/bin/bash


# export USER=$1
# export HOST=$2
# export NODENAME=$3
NODES_LIST_FILE=nodes_list.csv
#ssh-copy-id root@192.168.2.11

# function copyid() {
#     awk -F , '{print "ssh-copy-id " $1"@"$2}' $NODES_LIST_FILE
    
# }

# copyid




for n in "$@";do
echo $n
done
# case $args in
#     -f)
#     echo "$args"
#     ;;
#     *)
#     echo "all"
#     ;;
# esac





# export PKI_DIR=./pki/files
# export K8S_BIN_DIR=./build/packages/kubernetes/server/bin
# export MANIFEST_DIR=./manifest

# export TARGET_DIR=/etc/kubernetes



# scp ${K8S_BIN_DIR}/kubelet ${USER}@${HOST}:/usr/local/sbin/kubelet
# scp ${PKI_DIR}/kubelet-bootstrap.kubeconfig ${USER}@${HOST}:${TARGET_DIR}/kubelet-bootstrap.kubeconfig
# scp ${PKI_DIR}/k8s-ca.pem ${USER}@${HOST}:${TARGET_DIR}/k8s-ca.pem
# scp ${MANIFEST_DIR}/kubelet-config.yaml ${USER}@${HOST}:${TARGET_DIR}/kubelet-config.yaml
# scp ${MANIFEST_DIR}/kubelet.service ${USER}@${HOST}:/usr/lib/systemd/system/kubelet.service