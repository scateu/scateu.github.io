---
layout: post
title: ubuntu里alt+tab禁止鼠标/去除显示桌面
date: 2014/02/25 00:34:48
---

# ubuntu里alt+tab禁止鼠标/去除显示桌面

渣班图的unity的默认alt+tab功能特别废柴

alt+tab切换的时候鼠标经常误点到其它程序上, 另外alt+tab中的显示桌面也非常讨厌, 生生占一个位置

于是
    
    
    sudo apt-get install compizconfig-settings-manager
    
    ccsm 
    

在 Desktop > Ubuntu Unity Plugin > Switcher里把最后两项勾上
    
    
    Disable Show Desktop in the Switcher
    Disable the mouse in the Switcher