FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-controller-manager /root/
ADD wait-for-it.sh /root/
WORKDIR /root
RUN chmod +x kube-controller-manager wait-for-it.sh
CMD /root/wait-for-it.sh
