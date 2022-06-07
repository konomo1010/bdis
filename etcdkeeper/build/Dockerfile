FROM konomo/baseimage:v1
ADD ./packages/etcdkeeper-v0.7.6-linux_x86_64.zip /root/
ADD ./entrypoint.sh /root/entrypoint.sh
RUN mkdir /root/pki
WORKDIR /root/
RUN unzip etcdkeeper-v0.7.6-linux_x86_64.zip && chmod +x etcdkeeper/etcdkeeper /root/entrypoint.sh && rm -fr etcdkeeper-v0.7.6-linux_x86_64.zip
CMD /root/entrypoint.sh











