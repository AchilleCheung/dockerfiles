FROM nginx:1.19

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's#deb.debian.org#mirrors.tencent.com#g; s#security.debian.org#mirrors.tencent.com#g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
        procps iproute2 dnsutils iputils-ping \
        tcpdump ngrep \
        vim nano \
    && rm -rf /var/lib/apt/lists
