FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-scheduler /root/
ADD wait-for-it.sh /root/
WORKDIR /root
RUN chmod +x kube-scheduler wait-for-it.sh
CMD /root/wait-for-it.sh
