wget cfssl https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl-bundle_1.6.1_linux_amd64
wget https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
docker build -t konomo/etcd/etcd:v1 . -f Dockerfile

mkdir -p /data/etcd-0{1..3}