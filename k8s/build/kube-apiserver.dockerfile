FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-apiserver /root/
ADD wait-for-it.sh /root/
WORKDIR /root
RUN chmod +x kube-apiserver wait-for-it.sh
CMD /root/wait-for-it.sh
