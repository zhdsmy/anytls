FROM alpine:latest

ARG TARGETARCH
ARG VERSION=0.0.12

RUN apk update \
    && apk add --no-cache unzip wget tar bsdmainutils \
    && rm -rf /var/cache/apk/*

RUN if [ "$TARGETARCH" = "arm64" ] ; then \
    wget -q https://github.com/anytls/anytls-go/releases/download/v${VERSION}/anytls_${VERSION}_linux_arm64.zip \
    && unzip -q anytls_${VERSION}_linux_arm64.zip \
    && cp anytls-server /usr/bin/anytls-server \
    && chmod +x /usr/bin/anytls-server; \
    else \
    wget -q https://github.com/anytls/anytls-go/releases/download/v${VERSION}/anytls_${VERSION}_linux_amd64.zip \
    && unzip -q anytls_${VERSION}_linux_amd64.zip \
    && cp anytls-server /usr/bin/anytls-server \
    && chmod +x /usr/bin/anytls-server; \
    fi

RUN rm -rf /tmp/*

# 复制启动脚本到容器
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]
