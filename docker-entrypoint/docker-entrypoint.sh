#!/bin/bash
set -e
exec /nginx-entrypoint.sh  nginx -g "daemon off;" > output.log 2>&1 &
exec bash