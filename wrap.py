#!/usr/bin/env python3
"""把 Artifact 用的 HTML 片段包成獨立網頁（補 doctype / html / head / body 與 noindex）。"""
import io, sys, re

src, dst = sys.argv[1], sys.argv[2]
s = io.open(src, encoding="utf-8").read()

# 去掉可能已存在的外層標籤，永遠從片段狀態重建
s = re.sub(r"(?is)^\s*<!doctype[^>]*>\s*", "", s)
# (?![a-zA-Z]) 避免把 <header> 當成 <head> 誤刪
s = re.sub(r"(?is)</?(?:html|head|body)(?![a-zA-Z])[^>]*>", "", s)

# 切出 head（meta / title / link / style）與 body
m = re.search(r"(?is)</style>", s)
if not m:
    sys.exit("來源檔裡找不到 </style>，無法切出 <head>")
head, body = s[: m.end()], s[m.end():]

# data-embed="on"：獨立網頁可以嵌 Instagram；Artifact 會擋外站 iframe，沒有這個屬性時頁面改顯示連結卡
# 獨立網頁不像 Artifact 外框會替 :root 補安全區留白，拿掉 viewport-fit=cover 讓瀏覽器自己避開瀏海
head = head.replace(", viewport-fit=cover", "")

if "noindex" not in head:
    head = head.replace(
        '<meta charset="utf-8">',
        '<meta charset="utf-8">\n<meta name="robots" content="noindex, nofollow, noarchive">',
        1,
    )

out = (
    "<!DOCTYPE html>\n<html lang=\"zh-Hant\" data-embed=\"on\">\n<head>\n"
    + head.strip()
    + "\n</head>\n<body>\n"
    + body.strip()
    + "\n</body>\n</html>\n"
)
io.open(dst, "w", encoding="utf-8").write(out)
print(f"wrapped -> {dst} ({len(out)/1024:.0f} KB)")
