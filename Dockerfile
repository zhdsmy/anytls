# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.0.12

RUN apk add --no-cache ca-certificates tar wget \
    && case "${TARGETARCH}" in \
         amd64 | arm64) ;; \
         *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
       esac \
    && wget -qO /tmp/anytls.tar.gz "https://github.com/anytls/anytls-go/archive/refs/tags/v${VERSION}.tar.gz" \
    && mkdir -p /src \
    && tar -xzf /tmp/anytls.tar.gz -C /src --strip-components=1

WORKDIR /src

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download \
    && CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} \
    go build -trimpath -buildvcs=false -ldflags="-s -w" -o /usr/bin/anytls-server ./cmd/server

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

COPY --from=builder /usr/bin/anytls-server /usr/bin/anytls-server
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgrep -f anytls-server > /dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh"]
