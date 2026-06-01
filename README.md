# AnyTLS

Docker image for [anytls-go](https://github.com/anytls/anytls-go), a TLS proxy server.

[![Docker Pulls](https://img.shields.io/docker/pulls/domizhang/anytls.svg)](https://hub.docker.com/r/domizhang/anytls)
[![Docker Image Size](https://img.shields.io/docker/image-size/domizhang/anytls/latest)](https://hub.docker.com/r/domizhang/anytls)

## Included version

- anytls-go: `0.0.12`
- Go toolchain: `1.26`
- Base image: `alpine:3.23`

## Supported platforms

- `linux/amd64`
- `linux/arm64`

## Tags

- `latest`: latest build from the default branch
- `0.0.12`: current AnyTLS version build
- `0.0`: major/minor tag for versioned releases

## Quick start

Run with a generated password:

```bash
docker run -d \
  --name anytls \
  -p 8443:8443 \
  domizhang/anytls:latest
```

Read the generated password from logs:

```bash
docker logs anytls
```

Run with a fixed password:

```bash
docker run -d \
  --name anytls \
  -p 8443:8443 \
  -e PSK="your-secure-password" \
  domizhang/anytls:latest
```

Customize listener and extra arguments:

```bash
docker run -d \
  --name anytls \
  -p 9443:9443 \
  -e LISTEN_ADDR="0.0.0.0:9443" \
  -e PSK="your-secure-password" \
  domizhang/anytls:latest \
  --help
```

## Docker Compose

```yaml
services:
  anytls:
    image: domizhang/anytls:latest
    container_name: anytls
    restart: unless-stopped
    ports:
      - "8443:8443"
    environment:
      LISTEN_ADDR: 0.0.0.0:8443
      PSK: your-secure-password
```

## Environment variables

| Variable | Default | Description |
| --- | --- | --- |
| `LISTEN_ADDR` | `0.0.0.0:8443` | Server listen address and port |
| `PSK` | generated | Pre-shared key. If empty, a random key is generated and printed once at startup |
| `ARGS` | empty | Deprecated compatibility option. Prefer passing extra arguments after the image name |

## Security notes

- Use a strong explicit `PSK` in production.
- The generated `PSK` is printed to container logs so the client can be configured. Treat logs as sensitive.
- Provided `PSK` values are not printed.
- Do not expose the service publicly without firewall rules or an explicit access policy.

## Build locally

```bash
docker build \
  --build-arg VERSION=0.0.12 \
  -t domizhang/anytls:local .
```

## Update policy

The anytls-go version is pinned in `Dockerfile` and `.github/workflows/main.yml`. To update:

1. Check the upstream [anytls-go releases](https://github.com/anytls/anytls-go/releases).
2. Update `VERSION` / `DEFAULT_VERSION`.
3. Build and test the image.
4. Tag the repository as `vX.Y.Z` to publish versioned tags.

## License

This repository builds anytls-go from upstream source for the target platform. anytls-go is distributed under its upstream license.
