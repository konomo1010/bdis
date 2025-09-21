# go 1.22.2   nodejs `v20.12.2`  npm  `10.5.0`

FROM centos
WORKDIR /root
RUN curl -o /opt/go1.22.2.linux-amd64.tar.gz https://dl.google.com/go/go1.22.2.linux-amd64.tar.gz && tar xfz /opt/go1.22.2.linux-amd64.tar.gz -C /opt/
ENV GOENV=/root/.config/go/env
ENV GOPATH=/root/go
ENV PATH=/opt/go/bin:$PATH
RUN go env -w GO111MODULE=on && go env -w GOCACHE=/root/go/cache && go env -w GOPROXY=https://goproxy.cn,direct && go env -w GOROOT=/opt/go && go env -w GOMODCACHE=/root/go/pkg/mod


RUN curl -o install.sh  https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh && bash install.sh && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && nvm install 20

RUN npm config set registry https://mirrors.huaweicloud.com/repository/npm/ 
RUN npm install -g vite

RUN rm -fr /opt/go1.22.2.linux-amd64.tar.gz && rm -fr install.sh


# docker run -it --rm -v D:\project\go\src\marketemo:/root/go/src/marketemo centos bash