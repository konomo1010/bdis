#!/bin/bash
args=$1
if [ ! -z $args ];then
    case $args in 
        all)
        . ${PKI_SCRIPTS_DIR}/server/genCA.sh
        . ${PKI_SCRIPTS_DIR}/server/kube-apiserver.sh
        . ${PKI_SCRIPTS_DIR}/server/kube-controller-manager.sh
        . ${PKI_SCRIPTS_DIR}/server/kube-scheduler.sh
        . ${PKI_SCRIPTS_DIR}/server/bootstrap.sh
        # . ${PKI_SCRIPTS_DIR}kube-proxy.sh
        . ${PKI_SCRIPTS_DIR}/server/cluster-admin.sh
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






