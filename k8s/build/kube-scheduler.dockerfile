FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-scheduler /root/
ADD kube-scheduler_entrypoint.sh /root/
WORKDIR /root
RUN chmod +x kube-scheduler kube-scheduler_entrypoint.sh
CMD /root/kube-scheduler_entrypoint.sh
