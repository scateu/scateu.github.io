---
layout: post
title: 部分程序无法使用OSS 找不到/dev/dsp的问题
date: 2014/03/11 13:56:43
---

# 部分程序无法使用OSS: 找不到/dev/dsp的问题

gmfsk报错
    
    
    sound_open_for_read: opensnd: 
    open: /dev/dsp: No such file or directory
    

在Debian里可以直接
    
    
    aoss gmfsk
    

在Ubuntu里由于使用了Pulse Audio, 因此要使用
    
    
    padsp gmfsk
    

padsp和aoss都是模拟出一个`/dev/dsp`设备
