---
layout: post
title: newsbeuter 终端下的RSS阅读器
date: 2014/04/04 18:31:36
---

# newsbeuter 终端下的RSS阅读器

可以导入opml文件 在.newsbeuter/config里加入以下内容, 使得键绑定为vim风格 
    
    
    # vimlike bindings
    unbind-key ^U
    bind-key ^U pageup
    unbind-key ^D
    bind-key ^D pagedown
    bind-key k up
    bind-key j down
    bind-key h quit
    unbind-key l 
    bind-key l open
    bind-key L toggle-show-read-feeds

目前还没有想到如何使其与digg reader或者其它reader进行同步