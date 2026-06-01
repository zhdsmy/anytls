#!/bin/sh
set -eu

LISTEN_ADDR=${LISTEN_ADDR:-0.0.0.0:8443}

echo "=========================================="
echo "Starting anytls-server"
echo "=========================================="

if [ -z "${PSK:-}" ]; then
    PSK=$(hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom)
    echo "No PSK provided. Generated random password:"
    echo "Password: ${PSK}"
    echo "Save this password for client connections."
else
    echo "Using provided PSK."
fi

echo "Listen Address: ${LISTEN_ADDR}"
echo "=========================================="

if [ -n "${ARGS:-}" ]; then
    echo "ARGS is deprecated. Pass extra anytls-server options after the image name instead."
    set -f
    # shellcheck disable=SC2086
    set -- ${ARGS} "$@"
    set +f
fi

exec /usr/bin/anytls-server -l "${LISTEN_ADDR}" -p "${PSK}" "$@"
