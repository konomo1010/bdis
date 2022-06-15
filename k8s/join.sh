#!/bin/bash

export containerd_PKG_NAME=cri-containerd-cni-1.6.4-linux-amd64.tar.gz
export libseccomp_PKG_NAME=libseccomp-2.5.1-1.el8.x86_64.rpm
export NODE_WORK_DIR=/root/
export TARGET_DIR=/etc/kubernetes


export PKI_DIR=./pki/files
export PACKAGE_DIR=./build/packages
export K8S_BIN_DIR=${PACKAGE_DIR}/kubernetes/server/bin
export MANIFEST_DIR=./manifest




while getopts "h:u:p:n:f:" opt;do
    case $opt in
        h)
            HOST=$OPTARG
        ;;
        u)
            USER=$OPTARG
        ;;
        p)
            PASSWD=$OPTARG
        ;;
        n)
            NODENAME=$OPTARG
        ;;
        f)
            echo "fff"
            exit 1
        ;;
        ?)
            echo "Invalid Option"
            exit 1
        ;;
        *)
            echo "abc"
        ;;
    esac
done

# 免密钥
function SSHPass() {
    NODE=$1
    PASSWORD=$2
    expect << EOF
    spawn ssh-copy-id $NODE
    expect {
        "password:" {send "$PASSWORD\n";exp_continue}
        "yes/no" {send "yes\r";exp_continue}
    }
EOF
}

# 验证 & 拷贝
function mscp() {
    node=`echo $2| awk -F ':' '{print $1}'`
    remofile=`echo $2| awk -F ':' '{print $NF}'`

    local_flag=`[ -e $1 ]&&echo 0||echo 1`
    if [[ $local_flag -eq 0 ]];then
        remo_flag=`ssh  ${node} "[ -e ${remofile} ]&&echo 0||echo 1"`
        if [[ $remo_flag -eq 1 ]];then
            scp ${1} ${2}
        fi
    else
        echo "$1 does not exist !"
        exit
    fi
}






## 准备材料
if [[ ! -z $USER && ! -z $HOST && ! -z $PASSWD ]];then

    if [ ! -e ~/.ssh/id_rsa ];then 
        ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
    fi

    if [ ! `grep ${HOST} ~/.ssh/known_hosts|wc -l` -gt 0 ];then
        SSHPass $USER@$HOST $PASSWD
    fi

    ## 验证远端目录是否存在
    if [[ `ssh  ${USER}@${HOST} "[ -e ${TARGET_DIR}/manifests ]&&echo 0||echo 1"` -eq 1 ]];then
        ssh  ${USER}@${HOST} "mkdir -p ${TARGET_DIR}/manifests"
    fi

    mscp $PACKAGE_DIR/$containerd_PKG_NAME $USER@$HOST:${NODE_WORK_DIR}/$containerd_PKG_NAME
    mscp $PACKAGE_DIR/$libseccomp_PKG_NAME $USER@$HOST:${NODE_WORK_DIR}/$libseccomp_PKG_NAME
    scp ${K8S_BIN_DIR}/kubelet ${USER}@${HOST}:/usr/local/sbin/kubelet
    scp ${PKI_DIR}/kubelet-bootstrap.kubeconfig ${USER}@${HOST}:${TARGET_DIR}/kubelet-bootstrap.kubeconfig
    scp ${PKI_DIR}/k8s-ca.pem ${USER}@${HOST}:${TARGET_DIR}/k8s-ca.pem
    scp ${MANIFEST_DIR}/kubelet-config.yaml ${USER}@${HOST}:${TARGET_DIR}/kubelet-config.yaml
    scp ${MANIFEST_DIR}/kubelet.service ${USER}@${HOST}:/usr/lib/systemd/system/kubelet.service


    ############################################ node 节点安装 containerd
    # libseccomp  版本要大于 2.3
    ssh ${USER}@${HOST} "yum remove libseccomp -y&&rpm -ivh ${NODE_WORK_DIR}/$libseccomp_PKG_NAME"
    ssh ${USER}@${HOST} "cd ${NODE_WORK_DIR}&&tar xfzv ${NODE_WORK_DIR}/$containerd_PKG_NAME --no-overwrite-dir -C /"
    scp ${MANIFEST_DIR}/config.toml ${USER}@${HOST}:/etc/containerd/config.toml
    ssh ${USER}@${HOST} "systemctl daemon-reload && systemctl enable containerd  && systemctl restart containerd"

    ############################################ node 节点初始化
    # hostname, 时区，时间同步， hosts解析
     ssh ${USER}@${HOST} "systemctl enable kubelet && systemctl start kubelet"

else

    echo "Usage : -h <host> -u <user> -p <password> -n <NodeName>|| -f file"
fi






















