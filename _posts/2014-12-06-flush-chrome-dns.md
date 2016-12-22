---
layout: post
title:  "清空DNS缓存"
date:   2014-12-06 18:40
---

## 清理Chrome的DNS缓存

[chrome://net-internals/#dns](chrome://net-internals/#dns)

然后点 Clear host cache

## Mac 下清理 DNS 缓存

    dscacheutil -flushcache 

Yosemite:

    sudo discoveryutil mdnsflushcache
    
## Windows 下清理 DNS 缓存

    ipconfig /flushdns

## 其它

比如有的公司封禁了印象笔记...

    119.254.30.32  app.yinxiang.com
    119.254.30.39  yinxiang.com
    119.254.30.33  www.yinxiang.com
