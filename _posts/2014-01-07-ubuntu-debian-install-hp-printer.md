---
title: Ubuntu / Debian 系统里的HP打印机安装
date: 2014/01/07 10:55:05
layout: post
---

# Ubuntu / Debian 系统里的HP打印机安装

由于HP打印机提供了专用驱动, 所以不要用操作系统自带的打印机管理程序来装驱动. 

这里用的打印机是HP LaserJet Professional M1216nfh MFP
    
    
    sudo apt-get install hplip-gui hplip
    

然后`sudo hp-setup`设置即可