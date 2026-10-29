#!/usr/bin/env bash
# 把網站的檔案複製到 www/，給 iPhone App 使用（網站和 App 用同一份程式）
set -euo pipefail
rm -rf www && mkdir -p www
cp index.html manifest.json favicon.png apple-touch-icon.png icon-192.png icon-512.png icon-maskable-512.png www/
echo "www/ 準備完成"
