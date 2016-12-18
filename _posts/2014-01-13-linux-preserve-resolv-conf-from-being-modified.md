---
layout: post
title: Linux 防止/etc/resolv.conf被其它进程改动
date: 2014/01/13 16:17:59
---

# Linux 防止/etc/resolv.conf被其它进程改动

比如自作多情的NetworkManager或者dhcp什么的
    
    
    sudo chattr +i /etc/resolv.conf
    

改回来
    
    
    sudo chattr -i /etc/resolv.conf