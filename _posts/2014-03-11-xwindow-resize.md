---
layout: post
title: 改变XWindow里的窗口尺寸
date: 2014/03/11 11:32:04
---

# 改变XWindow里的窗口尺寸

`xdotool`是一个针对X的自动化工具
    
    
    xdotool search --name "sometitle" windowsize 1120 630
    

另外, 以下脚本可以显示当前鼠标像素下面窗口的PID
    
    
    xprop -id $(xwit -current -print | cut -d ":" -f 1) | grep _NET_WM_PID | cut -d "=" -f2 | cut -c 2-