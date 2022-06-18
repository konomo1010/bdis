#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
case $1 in 
    "baseimage")
        echo "====> building baseimage docker image"
        docker build --rm --no-cache -t konomo/baseimage:v1 . -f baseimage.dockerfile
        echo ""
    ;;
    "salt-ssh")
        echo "====> building baseimage docker image"
        docker build --rm --no-cache -t konomo/salt/salt-ssh:v1 . -f salt-ssh.dockerfile
        echo ""
    ;;
    *)
        echo "[baseimage|salt-ssh]; nothing to do ; Bye-Bye"
        exit
    ;;
esac

# 清理 dangling image
if [ `docker images -f "dangling=true" -q|wc -l` -gt 0 ];then
    docker rmi $(docker images -f "dangling=true" -q)
fi
