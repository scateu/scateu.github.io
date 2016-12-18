---
layout: post
title: 修复Windows启动故障一例
date: 2014/05/20 22:55:49
---

# 修复Windows启动故障一例

原来的系统有两套Windows 

最早在C盘有Windows XP

然后在F盘安装Windows 7

据当事人说, 装完Win7之后, XP不可用. 

于是应其要求安装Ubuntu 13.10. 于是将其C盘彻底格掉, 从0磁道开始分一个EXT4加上一点SWAP

安装执行到最后一步时, 提示grub安装失败. 

于是进入LiveCD之后重新安装grub.
    
    
    sudo mount /dev/sda5 /mnt
    sudo grub-install --boot-directory=/mnt/boot/ /dev/sda

然后依然报错, 提示
    
    
    /usr/sbin/grub-bios-setup: error: embedding is not possible, but this is required for RAID and LVM install.

随后发现, 原因是从0磁道开始分了给Linux使用的分区, 导致grub安装的时候没有足够的空间. 于是重新分区, 将开头留出100MB的Free Space. 解决.  之后, 发现Windows不能启用了. 原因后来想到, 应该是之前装Win7的时候, 把bootmgr等一众东西装到了C盘上. 导致C盘没有了之后, F盘上的Win7自然就缺少bootmgr和f:\boot\目录.  于是先尝试进入grub shell 
    
    
    grub> insmod part_msdos
    grub> insmod ntfs
    grub> set root='(hd0,msdos2)'
    grub> chainloader +1
    grub> boot

于是发现果然引导不了了.  

然后找到Win7的安装盘, 引导进控制台之后, 执行
    
    
    bootrec /ScanOs

找到F盘上的Windows系统

再执行
    
    
    bootrec /RebuildBCD
    bootrec /FixBoot
    bootrec /FixMBR

报错

后来使用LiveCD进入Ubuntu, 使用GParted将F盘所在分区设置为活动.  再进入Win7的安装盘的控制台, 修复成功   然后启动Win7的半路上蓝屏, 猜测是修复之后把F盘认成了C盘, 找不到文件.  于是进了WinPE, 打算修复一下驱动器盘符. 但是无奈程序不支持.  然后再一重启, 发现启动成功了.  

所以说, 一定要随身多备U盘.......