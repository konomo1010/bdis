package_dir=./packages
etcdkeeper_download_url=https://github.com/evildecay/etcdkeeper/releases/download/v0.7.6/etcdkeeper-v0.7.6-linux_x86_64.zip
etcdkeeper_package_name=etcdkeeper-v0.7.6-linux_x86_64.zip

if [ ! -d ${package_dir} ];then
    mkdir -p ${package_dir}
fi

if [ ! -e ${package_dir}/${etcdkeeper_package_name} ];then
    wget -P ${package_dir} ${etcdkeeper_download_url}
fi

docker build -t konomo/etcd/etcdkeeper:v1 . -f Dockerfile
