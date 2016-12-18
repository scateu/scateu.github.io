---
layout: post
title:  "Raspberry Pi + XBMC 配置"
date: 2015-02-15 12:27:00
---

## 安装

手头有几只Raspberry Pi, 一直在落灰, 于是去<http://www.raspbmc.com>上下载了镜像. 

在Mac上的安装, 使用dd. 步骤如下

 - 找到SD卡对应的/dev/disk*
 - 在磁盘工具里, 把这个盘卸载掉, 不能直接推出
 - `sudo dd bs=1m if=xbmc.img of=/dev/disk1` 注意此处再三确认disk号
  - 看进度: `while true;do sudo kill <dd的PID> -s SIGINFO;done`


然后开机, 需要优化的几项:

 - 默认音频输出只有HDMI, 如果需要用3.5mm耳机插头, 需要到设置里设成"HDMI+Analog"同时输出
 - 接显示器默认的分辨率太高, 有可能会导致树莓派顶不住, 屏幕闪, 或者出横线, 建议设置成1280x720p
 - 默认主题中的字体无法显示中文, 需要到`Apperance`里把字体选成`Arial`
 - 建议关掉自动更新, 否则更新完有可能会出现`Relax, Kodi will restart shortly`, 然后卡死...
   - 位于`Settings->Raspbmc Settings->System Configration->Keep Raspbmc updated`

### 添加资源地址

例如:

    smb://192.168.x.x/

## TODO

 - 字幕
 - 搜狐视频/百度云
   - 百度云 <http://www.hdpfans.com/thread-420833-1-1.html>
 - [Airplay](http://arstechnica.com/information-technology/2013/04/airplaying-music-and-video-from-ipad-to-raspberry-pi-its-as-easy-as/)
 - 红外遥控
 - 自身可以通过Webserver开启一个80端口从而被遥控
 - iOS上的控制客户端
 - 安装插件 <http://www.hdpfans.com/thread-329076-1-1.html>
 - ZeroConf
