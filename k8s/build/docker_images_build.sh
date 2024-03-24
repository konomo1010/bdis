#!/bin/bash
package_dir=./packages
download_url=https://dl.k8s.io/v1.24.1/kubernetes-server-linux-amd64.tar.gz
package_name=kubernetes-server-linux-amd64.tar.gz
docker_registry=swr.cn-north-4.myhuaweicloud.com/wenxl

if [ ! -d ${package_dir} ];then
    mkdir -p ${package_dir}
fi

if [ ! -e ${package_dir}/${package_name} ];then
    wget -P ${package_dir} ${download_url}
    tar xfzv ${package_dir}/${package_name} -C ${package_dir}
fi


function dockerbuild() {

    imageName=$1
    dockerfile=$2
    imageVersion=$3
    

    docker build --rm --no-cache -t ${docker_registry}/${imageName}:${imageVersion} . -f ${dockerfile}
}


case $1 in 
    "kube-apiserver")
        echo "====> building kube-apiserver docker image"
        dockerbuild kube-apiserver kube-apiserver.dockerfile v1.24.1
        echo ""
    ;;
    "kube-controller-manager")
        echo "====> building kube-controller-manager docker image"
        dockerbuild kube-controller-manager kube-controller-manager.dockerfile v1.24.1
        echo ""
    ;;
    "kube-scheduler")
        echo "====> building kube-scheduler docker image"
        dockerbuild kube-scheduler kube-scheduler.dockerfile v1.24.1
        echo ""
    ;;

    "kube-proxy")
        echo "====> building kube-proxy docker image"
        dockerbuild kube-proxy kube-proxy.dockerfile v1.24.1
        echo ""
    ;;

    "all")
        echo "====> building kube-apiserver docker image"
        dockerbuild kube-apiserver kube-apiserver.dockerfile v1.24.1
        echo ""
        
        echo "====> building kube-controller-manager docker image"
        dockerbuild kube-controller-manager kube-controller-manager.dockerfile v1.24.1
        echo ""

        echo "====> building kube-scheduler docker image"
        dockerbuild kube-scheduler kube-scheduler.dockerfile v1.24.1
        echo ""

        echo "====> building kube-proxy docker image"
        dockerbuild kube-proxy kube-proxy.dockerfile v1.24.1
        echo ""
    ;;

    *)
        echo "please enter [all|kube-apiserver|kube-controller-manager|kube-scheduler|kube-proxy] : nothing to do ; Bye-Bye"
        exit
    ;;
esac


# 清理 dangling image
if [ `docker images -f "dangling=true" -q|wc -l` -gt 0 ];then
    docker rmi $(docker images -f "dangling=true" -q)
fi
