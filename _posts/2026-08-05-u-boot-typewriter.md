---
title: "U-Boot中文打字机"
date: 2026-08-05
layout: post
---

## 演示

![图]({{ site.imageurl }}/uboot_typewrite.jpeg)


- 视频: <https://youtu.be/vDTKMEDWPtY> <https://www.youtube.com/shorts/Up-6oE29sNA>
- 项目: <https://github.com/scateu/u-boot-typewriter/>

实测从按下开机键到进入可以打字的状态是4秒

## 之前的努力

0. 四通MS-2401. 以及[difan写的四通打字机WASM全模拟器](https://difan.org.cn/ms2401/).
1. CJKTTY Kernel: 参看[我的RPi编译内核指南](https://github.com/scateu/raspberrypi-cjktty-howto) 很快. 注意HiDPI屏幕要把32x32的字体也编进去
2. 仿UCDOS的FEP们: uim-fep或[我Vibe出来的基于Golang的wubi-fep](https://github.com/scateu/wubi-fep)
3. fbterm, kmscon: fbterm太丑,纯白色无法显示; [kmscon](https://wiki.archlinuxcn.org/zh-hk/KMSCON)太卡,影响心情
4. Distraction-free typewriter: Alphasmart, Pomera, Freewrite, BYOK
5. Vim五笔输入法: <https://github.com/scateu/ywvim>, 使用AI对性能提升了不少

## 特性

1. 作为U-Boot的子命令,可选编译进去
2. 可以写TF卡(VFAT或EXT4)
3. 不需要硬盘,全在Flash里面.
4. 三秒开机 适用于"灵感!憋不住了!"场景
5. 完全没有电源管理,一直用到没电.不用担心灵感来了机器还在休眠,机器只可能没电,不可能在唤醒或启动中！

## 大致的安装过程

以Chromebook(gru kevin)为例:

1. 拆开后壳,拆开主板,把写保护螺丝拿掉,参看我的blog的文章
2. 使用flashrom烧进预编译好的rom. 见[U-Boot中文打字机项目的Release页](https://github.com/scateu/U-Boot-typewriter)
3. 插张FAT32的TF卡. 完成
4. 开机提示"press any key to stop autoboot in 1..0"时迅速按个键. 进入U-boot的命令行,敲`typewriter`即可默认打开TF卡(FAT格式)的a.txt; 
   - 其它屏幕下方有帮助
   - 按`C-r`可以出一个列表,会把TF卡里的文件都列出来,方便切换.
   - 有Readline式行快捷键,但Alt键似乎还不可用
   
5. 自己再想办法安装系统. 或者不要装系统了


## 自己编译的大致过程

libreboot基本上就是一些helper,本质上你是要先编译一个coreboot,然后再编U-Boot作为payload,还要处理dtb设备树之类的东西.最后把U-Boot作为载荷放进coreboot里.

1. 下载libreboot的src包
2. 使用`./mk`来安装依赖,然后配置一下默认的板卡,以及设置一下环境变量,使用40个CPU核心编译
3. 使用`./mk -m U-Boot gru_kevin`来配置一下U-Boot的各个开关. 可以提速. 在项目的README里都有. 还可以配置BOOTCMD和AUTOBOOT等待时长.注意: libreboot不允许U-Boot运行的时候改BOOTCMD等变量,无法保存.估计是没地方写入.写盘上容易把盘写坏了.
4. `./mk -c coreboot gru_kevin`可以编出rom.然后烧入. 注意U-Boot可能需要去把编译产物全清了,否则编coreboot的时候不会去重新取.

注意: CH341A的Flash programmer,在Linux下需要编一下驱动`.ko`.原生的串口驱动不能被`flashrom`所识别. 使用Raspberry Pi,或Pico也都可以烧.

## 不足

1. CPU转速似乎还是很高
2. 在Samsung Chromebook Plus上不能直接写eMMC的FAT分区,会把结构写坏掉.
3. U-Boot+Coreboot编出来很容易超过8MB Flash限制,要么换大Flash,要么把U-Boot里的`UEFI`子功能和网络子功能关掉不编译.

