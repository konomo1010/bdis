FROM swr.cn-north-4.myhuaweicloud.com/wenxl/baseimage:v1
ADD ./packages/etcd-v3.5.4-linux-amd64.tar.gz /root/
COPY entrypoint.sh /root/
COPY etcd-conf.yaml /root/conf/
RUN chmod +x /root/entrypoint.sh && ln -s /root/etcd-v3.5.4-linux-amd64 /root/etcd && mkdir -p /data /root/conf /root/pki
CMD /bin/bash /root/entrypoint.sh