---
layout: post
title: Loongson YeeLoong 上手体验
date: 2014/05/19 23:48:37
---

# Loongson YeeLoong 上手体验

## Debian 网络安装

将以下三个文件拷贝到一个不大于2G的U盘分区内(EXT2,FAT均可) 

<http://d-i.debian.org/daily-images/mipsel/daily/loongson-2f/netboot/>

按住DEL开机,输入devls,看是否有usb0 
    
    bl -d ide (usb0,0)/boot.cfg 

理论上是可以按fn+F5把无线网卡打开, 从而使用无线网来安装的.  但是我没有试成功, 改用有线网安装.  tasksel: 增加选择了laptop, 不选Desktop Environment 安装到最后报错, grub安装失败.  于是进入shell. 参照<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740740>的解决方案.  
    
    mount --bind /dev /target/dev
    mount --bind /proc /target/proc
    mount --bind /sys /target/sys
    mount --bind /dev/pts /target/dev/pts
    cd /target
    chroot .
    grub-install --target=mipsel-loongson /dev/sda

然后依然启动失败, 提示 file is not set or not exist 于是再用U盘进入维护模式, 
    
    
    # mount /dev/sda1 /mnt
    # nano /mnt/boot.cfg
    
    default 0
    timeout 3
    showmenu 1
    title Boot with GRUB (grub.elf)
            kernel (wd0,0)/grub.elf
            args some-dummy-string
    title Debian GNU
            kernel (wd0,0)/vmlinuz-xxxxxxxxxxxxx
            initrd (wd0,0)/initrd.img-xxxxxxxxx
            args root=/dev/sda5 rootdelay=8

 

## 安装lxde

## anheng.com.cn预置的安装镜像

下载地址: <http://www.anheng.com.cn/loongson/install/>

说明文件: <http://www.anheng.com.cn/loongson/install/readme.txt>

将以下两个文件拷贝到一个不大于2G的U盘分区内(EXT2,FAT均可)

 <http://www.anheng.com.cn/loongson/install/loongson2_debian7_20110518.tar.lzma>

 <http://www.anheng.com.cn/loongson/install/vmlinux>
 
 事实证明`loongson2_debian7_lxde_20131120.tar.lzma`目前仍有问题, 会出现`filesystem readonly`的错误, 安装之后无法引导.  

## 手动

    pmon> load /dev/fat/disk@usb0/vmlinux 
    pmon> g 

## 镜像

龙芯的架构是mipsel 

因此, 只要是含有mipsel架构的debian镜像都可以使用 debian.ustc.edu.cn 

## 讨论

 - <http://tieba.baidu.com/p/2743119297> 
 - <https://www.bdwm.net/bbs/bbstcon.php?board=Notebook&threadid=14751466>
 - <http://yafanzhao.blog.163.com/blog/static/1931962672013112310503359/>
 - <http://blog.chinaunix.net/uid-7304044-id-4033950.html>
 - IRC: #debian-yeeloong 
 - <https://wiki.debian.org/DebianYeeloong/HowTo/Install>
 - <http://dev.lemote.com/>
 - [吕宗庭同学的安装手记](https://github.com/lvzongting/loongson-parabola)

## PMON

按说明： 
    
    
    load /dev/fs/ext2@wd0/vmlinux-3.2.0-4-loongson-2f

  加载内核, 注意内核文件的名称可能不太一样 
    
    
    initrd /dev/fs/ext2@wd0/initrd.gz

  加载initrd, 然后 g 就开始boot了.  随后就是一般debian安装的过程.  

## wireless
    
    
    iwconfig wlan0 txpower on  或者按fn+f5,然后看dmesg|tail的提示
    ifconfig wlan0 up或ifup wlan0
    wpa_passphrase yourSSID yourPASS > wpa.conf
    wpa_supplicant –D wext –i wlan0 –c wpa.conf &
    dhclient wlan0

## Dosbox

<http://www.linuxidc.com/Linux/2007-05/4597.htm>

## clean

	sudo apt-get purge didiwiki eva sudo apt-get update && sudo apt-get upgrade sudo apt-get install openconnect git build-essential tmux cmake tcitx-table-wubi

geeknote paldos:   <http://bbs.lemote.com/viewthread.php?action=printable&tid=72856>   

注: 使用fbterm可以在终端下显示中文