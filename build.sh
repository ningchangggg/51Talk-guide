#!/usr/bin/env bash
# 由 iCloud 的成品檔產生 GitHub Pages 用的完整 HTML 文件。
# 根目錄 index.html＝七位總覽（自己用）；<key>/index.html＝每位的單人版（發給創作者的子網址）。
# 用法：./build.sh   （改完內容後執行，再 git commit && git push）
set -e
SRC="/Users/ningchang/Library/Mobile Documents/com~apple~CloudDocs/▲知寧/口碑行銷/(直)51 Talk/51Talk_2027_創作者拍攝指南_手機版.html"
SINGLES="/Users/ningchang/Library/Mobile Documents/com~apple~CloudDocs/▲知寧/口碑行銷/(直)51 Talk/2027_KOL個別企劃_工作檔/拍攝指南/單人版"
[ -f "$SRC" ] || { echo "找不到來源檔：$SRC" >&2; echo "檔案搬過位置的話，請改上面的 SRC。" >&2; exit 1; }
DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$DIR/wrap.py" "$SRC" "$DIR/index.html"
for f in "$SINGLES"/51Talk_2027_拍攝指南_*.html; do
  [ -f "$f" ] || { echo "找不到單人版：$SINGLES" >&2; exit 1; }
  k="${f##*_}"; k="${k%.html}"
  mkdir -p "$DIR/$k"
  python3 "$DIR/wrap.py" "$f" "$DIR/$k/index.html"
done
