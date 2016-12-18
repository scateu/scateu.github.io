---
layout: post
title:  "某WinPad折腾记"
date: 2016-08-05
---

## 目标

酷比魔方 iWork 10 平板电脑, 型号为i15-TD开头, 预装了Windows和Android双系统. 昨天想更新到Windows Redstone试试Bash, 一直提示硬盘空间不够. 
于是打算把Android干掉. 

## 原厂重装方法

 - [IWORK10旗舰本（i15-TD）双系统刷机软件及教程【仅适用于出厂为双系统的机器】](http://www.51cube.com/ch/DownShow.asp?ID=400)

Android部分略过不看, 简要的说, 制备两个U盘, 一个FAT32, 一个NTFS格式. 一个用于存Windows PE基本系统, 一个用于存`images/install.wim`. 

(为什么需要两个U盘? 我猜测是因为引导PE只能用FAT32, 而`images/install.wim`的安装镜像有5.78GB, 超过FAT32的4GB上限. )

(补充: 有人提示此机型支持NTFS的UEFI, 可以尝试只用一个U盘, 我还没来得及尝试)

开机按F7选那个FAT32的U盘引导, 剩下全自动. 

<del>我猜测原厂提供的PE里面, 有检测是否为双系统的脚本, 于是走完过程之后, Android的分区还在. </del>


注: 很有意思的一点, 使用[IWORK10超极本（i15机身序列号开头）Win10系统安装文件](http://www.51cube.com/ch/DownShow.asp?ID=404)里面的镜像不可引导. 有可能是安装脚本中有检测平板型号的功能. 

## 解决

主要参考[这篇文章](http://bbs.51cube.com/thread-210868-1-1.html)的[Google缓存](http://webcache.googleusercontent.com/search?q=cache:W5V-dQEqL7kJ:bbs.51cube.com/thread-210868-1-1.html+&cd=1&hl=zh-CN&ct=clnk&gl=cn)

 - 找一个支持这个平板的[电脑城风格的Windows PE: wingwy-win8pe4.0-v1](https://pan.baidu.com/s/1eRXiblg), 解压到一个FAT32的U盘(SD卡加读卡器也可). 
 - 开机按F7, 用电脑城风格的Windows PE引导
   - 用DiskGenius, 把所有分区干掉
   - 重新建一个完整的NTFS分区(貌似DiskGenius会自动加上前面的两个小辅助分区)
 - 换用原厂的两个U盘重新安装. Android分区就不见了. 完成

备注: 之前最后一步没有使用原厂的U盘, 而是尝试进行了以下操作, 但进入Windows之前提示硬件没装好, 失败. 

 - 下载[WinNTSetup](http://www.msfn.org/board/topic/149612-winntsetup-v386/)项目
 - 在PE里面使用64位的WinNTSetup
   - 选择原厂提供的`images/install.wim`镜像
   - 引导驱动器选C盘
   - 安装磁盘位置选C盘
   - 点`开始安装`, *需要*选`UEFI`

## Future Work

 - 把BIOS刷掉, 这样开机就没有那个WINDOWS/Android选单了. 
 - 安装独立版本的Windows, 但是需要备份原厂的驱动, 据说驱动特别不好找. 


## 附: Windows 10 anniversary update fails with 0x80070057 error.

<http://answers.microsoft.com/en-us/windows/forum/windows_10-update/windows-10-anniversary-update-fails-with/1d04d8f7-46c4-4f3a-83dc-a13f5fe02500?page=3&auth=1>

Watch for Verifying Download and make sure to turn off your Internet/WIFI/LAN if it reaches 100% IMMEDIATELY. 

这特么也行. 


## 开启Linux子系统

"Windows功能"-"适用于 Linux 的 Windows 子系统(Beta)", 然后进cmd, bash, 同意, 好了. 

Windows上也可以用MobaXTerm, 但貌似中文支持有点问题.... 跑emacs的时候

> Version 9.0 (2016-05-04)
> New feature: added support for the new "Ubuntu Bash on Windows" feature (introduced in latest Windows 10 builds). In "Shell" sessions, you can choose between native Bash, Cmd, Powershell and "Ubuntu bash"


## 配套的键盘 CDK05

就是个坑货. 由上沿向下摸, 会触发显示桌面. 经常干着干着活, 尼玛的窗口没了. 

根据[CDK01键盘底座固件升级烧录程序-20150630](http://www.51cube.com.cn/ch/DownShow.asp?ID=357)看来, 同一系列的CDK01使用了深圳某厂的[HTK2188](https://detail.1688.com/offer/1240162214.html). 单片机芯片疑似是[NT25F273](http://www.dataman.com/nt25f273.html?package=1622)

刚开始以`Disable Edge Swipes`为关键词, 找了好几圈, 试用过:

 - [Touchpad Blocker](http://touchpad-blocker.com/)
 - [TouchpadFreeze](http://touchfreeze.net/)
 - Skip Metro Suite (据说在部分Windows 10平板上好评如[潮](http://answers.microsoft.com/en-us/windows/forum/windows_10-other_settings/how-can-i-disable-swipe-in-windows-10/fbf90bb9-0342-467a-81c3-2ecac56b7e28?page=3))

均无效. (但这几个工具可能会有别的用处, 故在此记录)

发现, 这个键盘首先并不是Precision Touchpad, 因此Windows的鼠标控制面板那边不能控制. (刚开始还以为是Windows 10 Home版本的限制, 后来发现并不是这样)

其次, 这个坑货键盘并不像Synaptics/Asus等等一线大厂提供了自己的驱动, 所以鼠标属性那边也没有额外的选项卡可以用. 

最精彩的部分来了, 我打开`屏幕键盘`, 然后再次由上沿向下摸, 发现Win键那边闪了一下. 再仔细一看, 原来这个坑货键盘是把这个手势定义为了`Win+D`. (我通过`taskkill /f /im explorer.exe`之后, 弹出的CMD窗口里发现的. )并把由右向左的手势, 绑定到了`Win+A`. 其实找一个键盘测试软件可以更清楚地了解这一点. 

 - 由上向下: Win+D
 - 由下向上: Win+B
 - 由右向左: Win+A

至此, 简直可以把这个键盘扔掉了. 

暂时只能想办法把这几个快捷键从系统层面上屏蔽掉了? 但是我经常在用`WIN+D`显示桌面的组合键啊. 


正可谓买寨板愁白头. 
