#!/bin/bash
export PKI_DIR=../files
export K8S_BIN_DIR=../../build/packages/kubernetes/server/bin

source func/kubeconfig_gen.sh

if [ ! -d ${PKI_DIR} ];then
    mkdir -p ../../files
fi

# echo "====> Create CAs"
# . ./genCA.sh


# . ./server/kube-apiserver.sh
# . ./server/kube-controller-manager.sh
# . ./server/kube-scheduler.sh
# . ./node/kube-proxy.sh
# . ./node/kubelet.sh

args=$1
if [ ! -z $args ];then
    case $args in 
        all)
        . ./genCA.sh
        . ./server/kube-apiserver.sh
        . ./server/kube-controller-manager.sh
        . ./server/kube-scheduler.sh
        . ./server/bootstrap.sh
        . ./node/kube-proxy.sh
        . ./node/kubelet.sh
        . ./user/cluster-admin.sh
        ;;
        *)
            script_file=$(find ./ -type f -name ${args}.sh)
            if [  ! -z $script_file ];then
                . $script_file
            else
                echo "$args.sh not found; nothing to do ; Bye-Bye"
            fi
        ;;
    esac
else
    echo "nothing to do ; Bye-Bye"
    exit
fi






