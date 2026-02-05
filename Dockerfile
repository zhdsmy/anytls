FROM alpine:latest AS builder

ARG TARGETARCH
ARG VERSION=0.0.12

# 安装依赖并下载anytls二进制文件
RUN apk update \
    && apk add --no-cache unzip wget hexdump ca-certificates \
    && rm -rf /var/cache/apk/* \
    && if [ "$TARGETARCH" = "arm64" ] ; then \
         ARCH="arm64"; \
       else \
         ARCH="amd64"; \
       fi \
    && wget -q https://github.com/anytls/anytls-go/releases/download/v${VERSION}/anytls_${VERSION}_linux_${ARCH}.zip \
    && unzip -q anytls_${VERSION}_linux_${ARCH}.zip \
    && mv anytls-server /usr/bin/anytls-server \
    && chmod +x /usr/bin/anytls-server \
    && rm -rf /tmp/* anytls_${VERSION}_linux_${ARCH}.zip

FROM alpine:latest

ARG VERSION=0.0.12

LABEL maintainer="domizhang" \
      description="Docker image for anytls - A TLS proxy server" \
      version="${VERSION}"

# 设置环境变量默认值
ENV LISTEN_ADDR=0.0.0.0:8443 \
    PSK=""

# 暴露默认端口
EXPOSE 8443

# 复制二进制文件和启动脚本
COPY --from=builder /usr/bin/anytls-server /usr/bin/anytls-server
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /

# 健康检查（动态检测进程是否存在）
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgrep -f anytls-server > /dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh"]
