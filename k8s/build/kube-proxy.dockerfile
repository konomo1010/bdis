FROM swr.cn-north-4.myhuaweicloud.com/wenxl/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-proxy /root/
ADD wait-for-it.sh /root/
WORKDIR /root
RUN apk add ipset iptables && chmod +x kube-proxy wait-for-it.sh
CMD /root/wait-for-it.sh
