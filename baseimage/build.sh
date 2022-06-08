#!/bin/bash
read -p "please enter [baseimage] : " arges

case $arges in 
    "baseimage")
        echo "====> building baseimage docker image"
        docker build --rm --no-cache -t konomo/baseimage:v1 . -f baseimage.dockerfile
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
