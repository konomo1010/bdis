FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-proxy /root/
ADD kube-proxy_entrypoint.sh /root/
WORKDIR /root
RUN apk add ipset iptables && chmod +x kube-proxy kube-proxy_entrypoint.sh
CMD /root/kube-proxy_entrypoint.sh
