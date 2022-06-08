FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-apiserver /root/
ADD kube-apiserver_entrypoint.sh /root/
WORKDIR /root
RUN chmod +x kube-apiserver kube-apiserver_entrypoint.sh
CMD /root/kube-apiserver_entrypoint.sh
