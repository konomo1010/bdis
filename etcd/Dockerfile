FROM alpine
ADD etcd-v3.5.4-linux-amd64.tar.gz /root/
COPY entrypoint.sh /root/
COPY etcd-conf.yaml /root/conf/
RUN chmod +x /root/entrypoint.sh
RUN sed -i 's#dl-cdn.alpinelinux.org#mirrors.aliyun.com#g' /etc/apk/repositories
RUN apk add busybox-extras
RUN apk add bash
RUN ln -sf /bin/bash /bin/sh
RUN ln -s /root/etcd-v3.5.4-linux-amd64 /root/etcd
RUN mkdir -p /data /root/conf /root/pki
CMD /bin/bash /root/entrypoint.sh