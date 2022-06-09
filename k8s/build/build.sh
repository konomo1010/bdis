#!/bin/bash
package_dir=./packages
download_url=https://dl.k8s.io/v1.24.1/kubernetes-server-linux-amd64.tar.gz
package_name=kubernetes-server-linux-amd64.tar.gz

if [ ! -d ${package_dir} ];then
    mkdir -p ${package_dir}
fi

if [ ! -e ${package_dir}/${package_name} ];then
    wget -P ${package_dir} ${download_url}
    tar xfzv ${package_dir}/${package_name} -C ${package_dir}
fi

read -p "please enter [all|kube-apiserver|kube-controller-manager|kube-scheduler|kube-proxy] : " arges

case $arges in 
    "kube-apiserver")
        echo "====> building kube-apiserver docker image"
        docker build --rm --no-cache -t konomo/k8s/kube-apiserver:v1 . -f kube-apiserver.dockerfile
        echo ""
    ;;
    "kube-controller-manager")
        echo "====> building kube-controller-manager docker image"
        docker build --rm --no-cache -t konomo/k8s/kube-controller-manager:v1 . -f kube-controller-manager.dockerfile
        echo ""
    ;;
    "kube-scheduler")
        echo "====> building kube-scheduler docker image"
        docker build --rm --no-cache -t konomo/k8s/kube-scheduler:v1 . -f kube-scheduler.dockerfile
        echo ""
    ;;

    "kube-proxy")
        echo "====> building kube-proxy docker image"
        docker build --rm --no-cache -t konomo/k8s/kube-proxy:v1 . -f kube-proxy.dockerfile
        echo ""
    ;;
    *)
        echo "nothing to do ; Bye-Bye"
        exit
    ;;
esac





# 清理 dangling image
if [ `docker images -f "dangling=true" -q|wc -l` -gt 0 ];then
    docker rmi $(docker images -f "dangling=true" -q)
fi
