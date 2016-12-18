---
layout: post
title:  "大陆局域网route列表"
date:   2014-12-02 16:14:48
categories: route
---

<https://github.com/jimmyxu/chnroutes>  

这个项目, 从[APNIC](http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest)上将最新的路由信息爬下来, 然后生成ip-pre-up和ip-down两个脚本. 

特别值得一提的是, 为了加快ip-route导入速度, jimmyxu/chnroutes项目里使用了`ip -batch`命令, 减少了传统的`route`命令的进程开销. 

哼哼. 

另外, B哥建议墙裂建议本项目配合 [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list) 使用. 

在清华校内, 可以使用[Tuna的Fork版本](https://github.com/tuna/thuroutes), 有针对学术数据库的优化. 
