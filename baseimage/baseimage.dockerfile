FROM alpine
RUN sed -i 's#dl-cdn.alpinelinux.org#mirrors.aliyun.com#g' /etc/apk/repositories
RUN apk add bash busybox-extras tree 
RUN echo ". /etc/profile" > ~/.bashrc
RUN ln -sf /bin/bash /bin/sh

