---
layout: post
title: Etherpad 安装插件
date: 2014/03/17 00:54:07
---

# Etherpad 安装插件

首先[Etherpad](http://etherpad.org)是个好项目! 

几乎可以称为Google Docs的本地版本. 

然后今天发现Etherpad别有洞天地有一个管理接口, 只需要改一下目录里的`settings.json`

把默认的`admin`什么的用户打开就行了

然后就可以通过访问`<url>/admin`来进行插件安装管理啦. 

### 插件推荐

可参考这两篇文章[1](http://mclear.co.uk/2014/01/04/top-10-etherpad-plugins-2014/) [2](http://blog.etherpad.org/2013/01/31/9-etherpad-plugins-to-extend-functionality/)
    
    
    ep_aa_file_menu_toolbar, ep_adminpads, ep_colors, ep_clear_authorship_no_prompt, 
    ep_headings, ep_historicalsearch, ep_markdownify, ep_markdown, 
    ep_mathjax, ep_page_view, ep_print, ep_prompt_for_name, 
    ep_timesliderdiff, ep_tasklist, ep_tables
    

### Bug Fix

貌似Etherpad.org上提供的Windows发行包的admin中plugin搜索功能有问题, 需要手动修复一下.  

参考[Github Issue](https://github.com/ether/etherpad-lite/issues/2094)

Windoes package errors and exits the server when the "plugin manager" under admin (http://127.0.0.1:9001/admin/plugins) is viewed (simple auth completed for an admin user).

Blows up when data.versions is a non-object and quits: "TypeError: Object.keys called on non-object"

Bug found in: ~\etherpad-lite-win\node_modules\ep_etherpad-lite\node_modules\npm\lib\search.js line 89

Was:
    
    
     , version: Object.keys(data.versions)[0] || []
    

My local fix:
    
    
     , version: Object.keys(data.versions || {})[0] || []