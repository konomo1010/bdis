FROM konomo/baseimage:v1
COPY ./packages/kubelet /root/
COPY wait-for-it.sh /root/
WORKDIR /root
RUN chmod +x kubelet wait-for-it.sh
CMD /root/wait-for-it.sh
