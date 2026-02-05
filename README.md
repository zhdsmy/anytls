# AnyTLS

Docker image for [AnyTLS](https://github.com/anytls/anytls-go) - A TLS proxy server

[![Docker Hub](https://img.shields.io/docker/pulls/domizhang/anytls.svg)](https://hub.docker.com/r/domizhang/anytls)
[![Docker Image Size](https://img.shields.io/docker/image-size/domizhang/anytls/latest)](https://hub.docker.com/r/domizhang/anytls)

## 快速开始

### 使用 Docker 运行

```bash
# 使用随机生成的密码（密码会在启动时输出到日志）
docker run -d -p 8443:8443 --name anytls domizhang/anytls:latest

# 查看生成的密码
docker logs anytls

# 使用自定义密码
docker run -d -p 8443:8443 \
  -e PSK="your-secure-password" \
  --name anytls \
  domizhang/anytls:latest

# 自定义监听地址和端口
docker run -d -p 9443:9443 \
  -e LISTEN_ADDR="0.0.0.0:9443" \
  -e PSK="your-secure-password" \
  --name anytls \
  domizhang/anytls:latest
```

### 使用 Docker Compose

创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  anytls:
    image: domizhang/anytls:latest
    container_name: anytls
    ports:
      - "8443:8443"
    environment:
      - LISTEN_ADDR=0.0.0.0:8443
      - PSK=your-secure-password
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

## 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `LISTEN_ADDR` | `0.0.0.0:8443` | 服务监听地址和端口 |
| `PSK` | 随机生成 | 连接密码，如果不设置将自动生成并输出到日志 |

## 支持的架构

- `linux/amd64`
- `linux/arm64`

## 镜像标签

- `latest` - 最新的 main 分支构建
- `x.y.z` - 特定版本号（如 `0.0.12`）
- `x.y` - 主次版本号（如 `0.0`）

## 安全建议

1. **强烈建议**在生产环境中使用 `PSK` 环境变量设置强密码
2. 不要在公网直接暴露服务，建议配合防火墙或反向代理使用
3. 定期更新到最新版本以获取安全补丁
4. 建议使用非标准端口以减少扫描风险

## 许可证

本项目遵循 anytls-go 的许可证。详见 [anytls-go](https://github.com/anytls/anytls-go)。

## 相关链接

- [anytls-go GitHub](https://github.com/anytls/anytls-go)
- [Docker Hub](https://hub.docker.com/r/domizhang/anytls)
