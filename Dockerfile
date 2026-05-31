# syntax=docker/dockerfile:1

FROM alpine:3.23 AS downloader

ARG TARGETARCH
ARG VERSION=0.0.12

RUN apk add --no-cache ca-certificates unzip wget \
    && case "${TARGETARCH}" in \
         amd64) ANYTLS_ARCH="amd64" ;; \
         arm64) ANYTLS_ARCH="arm64" ;; \
         *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
       esac \
    && wget -qO /tmp/anytls.zip "https://github.com/anytls/anytls-go/releases/download/v${VERSION}/anytls_${VERSION}_linux_${ANYTLS_ARCH}.zip" \
    && unzip -q /tmp/anytls.zip -d /tmp \
    && install -m 0755 /tmp/anytls-server /usr/bin/anytls-server

FROM alpine:3.23

ARG VERSION=0.0.12

LABEL org.opencontainers.image.title="anytls" \
      org.opencontainers.image.description="Docker image for AnyTLS, a TLS proxy server" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/zhdsmy/anytls"

ENV LISTEN_ADDR=0.0.0.0:8443 \
    PSK="" \
    ARGS=""

EXPOSE 8443

COPY --from=downloader /usr/bin/anytls-server /usr/bin/anytls-server
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgrep -f anytls-server > /dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh"]
