package_dir=./packages
download_url=https://github.com/evildecay/etcdkeeper/releases/download/v0.7.6/etcdkeeper-v0.7.6-linux_x86_64.zip
package_name=etcdkeeper-v0.7.6-linux_x86_64.zip

if [ ! -d ${package_dir} ];then
    mkdir -p ${package_dir}
fi

if [ ! -e ${package_dir}/${package_name} ];then
    wget -P ${package_dir} ${download_url}
fi

docker build --rm --no-cache -t konomo/etcd/etcdkeeper:v1 . -f Dockerfile


# 清理 dangling image
if [ `docker images -f "dangling=true" -q|wc -l` -gt 0 ];then
    docker rmi $(docker images -f "dangling=true" -q)
fi