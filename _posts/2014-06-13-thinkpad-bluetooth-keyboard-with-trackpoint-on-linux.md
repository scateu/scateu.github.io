---
layout: post
title: Thinkpad 蓝牙键盘 0B47189 及其在 Ubuntu 上的Bug一例
date: 2014/06/13 21:07:51
---

# Thinkpad 蓝牙键盘 0B47189 及其在 Ubuntu 上的Bug一例

0B47189 是Thinkpad千呼万唤始出来的生产力神器, 拥有小红点的蓝牙键盘.  

据说在Android平台上使用的话, 可以有鼠标.  

实测在iPad上没问题, 但是iPad本身不支持鼠标使用. 

Windows键可以做为iPad的'花'Ctrl键使用.  

在Ubuntu 13.10上使用的时候有个大Bug, 就是连接的时候, 蓝牙配对的GUI需要你在蓝牙键盘上敲屏幕上显示的密码, 但是丫显示的是错的.  

于是可以参考[这篇文章](http://askubuntu.com/questions/290330/logitech-k760-failing-to-pair-ubuntu-13-04)给出的解决方案 
    
    
    $ sudo apt-get install bluez-hcidump
    
    $ sudo hcidump -at |grep -A 1 "User Passkey Notification"
    
    2014-06-13 20:51:40.202850 > HCI Event: User Passkey Notification (0x3b) plen ....  passkey xxxxxx

输入这个码然后回车就可以了