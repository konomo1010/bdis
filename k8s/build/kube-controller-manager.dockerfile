FROM konomo/baseimage:v1
ADD ./packages/kubernetes/server/bin/kube-controller-manager /root/
ADD kube-controller-manager_entrypoint.sh /root/
WORKDIR /root
RUN chmod +x kube-controller-manager kube-controller-manager_entrypoint.sh
CMD /root/kube-controller-manager_entrypoint.sh
