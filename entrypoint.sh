#!/bin/sh
set -e

# 打印启动信息
echo "=========================================="
echo "Starting anytls-server"
echo "=========================================="

# 设置默认值
LISTEN_ADDR=${LISTEN_ADDR:-0.0.0.0:8443}

# 如果密码环境变量不存在，生成随机密码
if [ -z "$PSK" ]; then
    PSK=$(hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom)
    echo "⚠️  No PSK provided, generated random password:"
    echo "🔑 Password: $PSK"
    echo "⚠️  Please save this password for client connections!"
else
    echo "✓ Using provided PSK"
fi

echo "📡 Listen Address: $LISTEN_ADDR"
echo "=========================================="

# 运行anytls-server并传递参数
exec /usr/bin/anytls-server -l "$LISTEN_ADDR" -p "$PSK"