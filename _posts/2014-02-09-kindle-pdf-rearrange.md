---
layout: post
title: Kindle PDF重排
date: 2014/02/09 00:50:51
---

# Kindle PDF重排

关键词: Kindle 切边 自动重排 PDF

众所周知, 6寸Kindle看A4大小的PDF太坑了. 

于是在电脑端, 有了[k2pdfopt](http://willus.com/k2pdfopt/)和[convert-kindle.com](http://convert-kindle.com/). 可以进行自动重排(pdf reflow).  多看貌似也支持自动重排了. 

另外, **强烈**推荐在Kindle上直接装[KOReader](http://vislab.bjmu.edu.cn/blog/hwangxin/category/kindle/), 比多看不知道高明到哪里去了. 集成了k2pdfopt. 另外, KOReader貌似还可以直接使用tesseract来进行OCR. 

KOReader还可以看DjVu格式的书. 

哦对了, KOReader的作者是北大医学部的同学, 赞一个! 

# 以下为摘录:

## Kindle越狱

Kindle Touch/Paperwhite的越狱方法请参考：http://www.mobileread.com/forums/showthread.php?t=186645

## 安装KPVBooklet

KPVBooklet支持5.1.2及以上的Kindle固件（建议越狱后升级到5.3以上固件再安装）, 下载地址：https://code.google.com/p/kpvbooklet-package/downloads . 将下载的zip文件解压缩, 把update_kpvbooklet_x.x.x_install.bin文件拷贝到Kindle的磁盘根目录下, 断开USB连接. 通过Menu> Settings> Menu> Update Your Kindle升级安装2,3, 注意不要通过restart来安装. 

## 安装Koreader

下载最新的Koreader安装包, 下载地址：https://code.google.com/p/koreader-package/downloads . 将下载的zip文件解压缩后得到的三个目录（extensions, koreader和launchpad）拷贝到Kindle磁盘根目录即可. 

## 关于原生系统固件升级

开启WIFI的情况下原生系统可能会在后台自动升级固件. 不管手动固件升级还是自动固件升级都会擦除KPVBooklet启动器造成Koreader无法启动, 解决这个问题只需要升级完成后重新安装KPVBooklet即可, Koreader无需重新安装. 

## Comments

**[鲁斌 徐](#5 "2014-03-02 21:24:00"):** 北大医学部的同学, 牛啊! ! ! 

