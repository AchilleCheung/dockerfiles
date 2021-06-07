FROM php:8.0-fpm

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's#deb.debian.org#mirrors.tencent.com#g; s#security.debian.org#mirrors.tencent.com#g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
        procps iproute2 dnsutils iputils-ping \
        tcpdump ngrep \
        vim nano \
    && rm -rf /var/lib/apt/lists

RUN curl -SL 'https://github.com/phpredis/phpredis/archive/5.3.2.tar.gz' -o phpredis.tgz \
    && mkdir -p phpredis \
    && tar -xf phpredis.tgz -C phpredis --strip 1 \
    && rm -rf phpredis.tgz \
    && ( \
        cd phpredis \
        && phpize \
        && ./configure --enable-redis \
        && make -j "$(nproc)" \
        && make install \
        && rm -rf /usr/local/src/phpredis \
    ) \
    && rm -rf phpredis \
    && docker-php-ext-enable redis \
    \
    && apt-get update \
    \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install -j$(nproc) zip \
    \
    && docker-php-ext-install -j $(nproc) pdo_mysql opcache \
    \
    && rm -rf /var/lib/apt/

