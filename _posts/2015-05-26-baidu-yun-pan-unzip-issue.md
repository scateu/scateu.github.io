---
layout: post
title:  "解决百度云打包下载的zip文件解压失败"
date: 2015-05-26 23:47:00
---

## 问题

从百度云上, 直接打包下载某个目录回来之后, zip文件貌似不能直接用`unzip`解压

    $ unzip /tmp/2015.05.23故园此声专场音乐会.zip 
    Archive:  /tmp/2015.05.23故园此声专场音乐会.zip
       creating: -?/2015.05.23?-Ȧ?-+?ο??+
     extracting: -?/2015.05.23?-Ȧ?-+?ο??+8-?--+?.mp4   bad CRC afb75d18  (should be fdf65676)
     extracting: -?/2015.05.23?-Ȧ?-+?ο??+5_=+?+?.mp4   bad CRC c2f3766b  (should be 92563da9)



有人说可以用

    unzip -O CP936 /path/to/file.zip

但我没试成功


## 解

    $ sudo apt-get install unar
    $ unar /path/to/file.zip

即可.


