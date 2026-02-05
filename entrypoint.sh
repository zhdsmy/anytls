#!/bin/sh

# 设置默认值
LISTEN_ADDR=${LISTEN_ADDR:-0.0.0.0:8443}

# 如果密码环境变量不存在，生成随机密码
if [ -z "$PASSWORD" ]; then
    PASSWORD=$(hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom)
    echo "Generated password: $PASSWORD"
fi

# 运行anytls-server并传递参数
exec /usr/bin/anytls-server -l "$LISTEN_ADDR" -p "$PASSWORD"