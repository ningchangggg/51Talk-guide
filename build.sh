#!/usr/bin/env bash
# 由 iCloud 的成品檔產生 GitHub Pages 用的完整 HTML 文件。
# 用法：./build.sh   （改完內容後執行，再 git commit && git push）
set -e
SRC="/Users/ningchang/Library/Mobile Documents/com~apple~CloudDocs/▲知寧/口碑行銷/(直)51 Talk/51Talk_2027_創作者拍攝指南_手機版.html"
[ -f "$SRC" ] || { echo "找不到來源檔：$SRC" >&2; echo "檔案搬過位置的話，請改上面的 SRC。" >&2; exit 1; }
DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$DIR/wrap.py" "$SRC" "$DIR/index.html"
