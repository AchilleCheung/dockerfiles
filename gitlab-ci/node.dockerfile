FROM node:lts-buster-slim

ENV HELM_VER=${HELM_VER:-v3.6.0}
ENV NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node

# Install required software
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's#deb.debian.org#mirrors.tencent.com#g; s#security.debian.org#mirrors.tencent.com#g' /etc/apt/sources.list

# Install docker
RUN apt-get update \
    && apt-get -y install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release \
    && curl -fsSL https://mirrors.tencent.com/docker-ce/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.tencent.com/docker-ce/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/

# Install kubectl
RUN curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://mirrors.tencent.com/kubernetes/apt/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/

# Install curl and helm
RUN apt-get update \
    && apt-get install -y curl jq git python2 \
    && curl -SL "https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz" | tar zx --strip=1 -C /usr/local/bin/ \
    && rm -rf /var/lib/apt/

# Set npm
RUN npm config set registry https://mirrors.tencent.com/npm/

