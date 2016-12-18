---
layout: post
title:  "提取Macbook的EFI固件"
date: 2015-07-18 21:57:00
---

由于brew里安装的flashrom没有把internal这个programmer编译进去, 所以没有办法dump出macbook的EFI固件. 

会报如下的错误:

    sudo flashrom -p internal -r ~/MBA13.bin
    
    flashrom v0.9.7-r1711 on Darwin 14.4.0 (x86_64)
    
    flashrom is free software, get the source code at http://www.flashrom.org
    
    
    
    Error: Unknown programmer "internal". Valid choices are:
    
    dummy, ft2232_spi, serprog, buspirate_spi, pony_spi, usbblaster_spi.
    
    Please run "flashrom --help" for usage info.

所以需要从源代码进行编译. 

### 1. 借brew之手把编译所需要的依赖库安装上:

    brew install flashrom
    brew uninstall flashrom 


### 2. 安装DirectHW

简而言之, OS X没有`lspci`这个命令, [DirectHW](http://www.coreboot.org/DirectHW)提供了一套包装好的接口, 从而使得`lspci`可以跑起来. 

去[这个链接](http://ho.ax/posts/2012/06/send-me-your-lspci/)上, 把编译好的[DirectHW.dmg](http://ho.ax/downloads/DirectHW.dmg)和[pciutils-3.1.7.dmg](http://ho.ax/downloads/pciutils-3.1.7.dmg)下载回来, 装上

    sudo kextload /System/Library/Extensions/DirectHW.kext

然后测试一下

    sudo lspci -v

    00:00.0 Host bridge: Intel Corporation Device 0a04 (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation Device 0a2e (rev 09)
    00:03.0 Audio device: Intel Corporation Device 0a0c (rev 09)
    00:14.0 USB Controller: Intel Corporation Device 9c31 (rev 04)
    00:16.0 Communication controller: Intel Corporation Device 9c3a (rev 04)
    00:1b.0 Audio device: Intel Corporation Device 9c20 (rev 04)
    00:1c.0 PCI bridge: Intel Corporation Device 9c10 (rev e4)
    00:1c.1 PCI bridge: Intel Corporation Device 9c12 (rev e4)
    00:1c.2 PCI bridge: Intel Corporation Device 9c14 (rev e4)
    00:1c.4 PCI bridge: Intel Corporation Device 9c18 (rev e4)
    00:1c.5 PCI bridge: Intel Corporation Device 9c1a (rev e4)
    00:1f.0 ISA bridge: Intel Corporation Device 9c43 (rev 04)
    00:1f.3 SMBus: Intel Corporation Device 9c22 (rev 04)
    03:00.0 Network controller: Broadcom Corporation Device 43a0 (rev 03)
    04:00.0 SATA controller: Samsung Electronics Co Ltd Device 1600 (rev 01)


### 3. 拉下代码, 打个Patch

    wget http://download.flashrom.org/releases/flashrom-0.9.8.tar.bz2

直接编译会报错:

    chipset_enable.c:1148:2: error: implicit declaration of function 'OUTB' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
            OUTB(0x8f, 0xcd6);
            ^
    chipset_enable.c:1149:8: error: implicit declaration of function 'INB' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
            reg = INB(0xcd7);


在`hwaccess.h`里加入以下Patch:

    #if IS_MACOSX
    #define OUTB outb
    #define INB inb
    #define INW inw
    #define INL inl
    #define OUTW outw
    #define OUTL outl
    #endif


然后`make`


补充: 有[同学](http://cicku.me)说, 其实 patch 可以不打, make 的时候直接加上 "WARNERROR=" 即可. 


### 4. Dump固件

    sudo ./flashrom  -p internal -r mbp-late-2013.bin

Log:

    flashrom v0.9.8-r1888 on Darwin 14.4.0 (x86_64)
    flashrom is free software, get the source code at http://www.flashrom.org
    
    Calibrating delay loop... OK.
    No DMI table found.
    Found chipset "Intel Lynx Point LP Premium".
    This chipset is marked as untested. If you are using an up-to-date version
    of flashrom *and* were (not) able to successfully update your firmware with it,
    then please email a report to flashrom@flashrom.org including a verbose (-V) log.
    Thank you!
    Enabling flash write... Warning: SPI Configuration Lockdown activated.
    FREG0: Warning: Flash Descriptor region (0x00000000-0x00000fff) is read-only.
    FREG2: Warning: Management Engine region (0x00002000-0x0018ffff) is read-only.
    FREG4: Warning: Platform Data region (0x00001000-0x00001fff) is read-only.
    Not all flash regions are freely accessible by flashrom. This is most likely
    due to an active ME. Please see http://flashrom.org/ME for details.
    PR0: Warning: 0x00000000-0x00001fff is read-only.
    PR1: Warning: 0x00190000-0x0060ffff is read-only.
    PR2: Warning: 0x00632000-0x01ffffff is read-only.
    Writes have been disabled for safety reasons. You can enforce write
    support with the ich_spi_force programmer option, but you will most likely
    harm your hardware! If you force flashrom you will get no support if
    something breaks. On a few mainboards it is possible to enable write
    access by setting a jumper (see its documentation or the board itself).
    OK.
    Found Macronix flash chip "MX25L6405" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
    Found Macronix flash chip "MX25L6405D" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
    Found Macronix flash chip "MX25L6406E/MX25L6408E" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
    Found Macronix flash chip "MX25L6436E/MX25L6445E/MX25L6465E/MX25L6473E" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
    Multiple flash chip definitions match the detected chip(s): "MX25L6405", "MX25L6405D", "MX25L6406E/MX25L6408E", "MX25L6436E/MX25L6445E/MX25L6465E/MX25L6473E"
    Please specify which chip definition to use with the -c <chipname> option.


于是按照提示改一下:

    $ sudo ./flashrom  -p internal -r mbp-late-2013.bin -c MX25L6405
    flashrom v0.9.8-r1888 on Darwin 14.4.0 (x86_64)
    flashrom is free software, get the source code at http://www.flashrom.org
    
    Calibrating delay loop... OK.
    No DMI table found.
    Found chipset "Intel Lynx Point LP Premium".
    This chipset is marked as untested. If you are using an up-to-date version
    of flashrom *and* were (not) able to successfully update your firmware with it,
    then please email a report to flashrom@flashrom.org including a verbose (-V) log.
    Thank you!
    Enabling flash write... Warning: SPI Configuration Lockdown activated.
    FREG0: Warning: Flash Descriptor region (0x00000000-0x00000fff) is read-only.
    FREG2: Warning: Management Engine region (0x00002000-0x0018ffff) is read-only.
    FREG4: Warning: Platform Data region (0x00001000-0x00001fff) is read-only.
    Not all flash regions are freely accessible by flashrom. This is most likely
    due to an active ME. Please see http://flashrom.org/ME for details.
    PR0: Warning: 0x00000000-0x00001fff is read-only.
    PR1: Warning: 0x00190000-0x0060ffff is read-only.
    PR2: Warning: 0x00632000-0x01ffffff is read-only.
    Writes have been disabled for safety reasons. You can enforce write
    support with the ich_spi_force programmer option, but you will most likely
    harm your hardware! If you force flashrom you will get no support if
    something breaks. On a few mainboards it is possible to enable write
    access by setting a jumper (see its documentation or the board itself).
    OK.
    Found Macronix flash chip "MX25L6405" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
    Reading flash... done.


## 附:自行编译安装DirectHW/lspci的思路

<http://www.coreboot.org/DirectHW>

另一位同学说:

> pciutils是可以编译的, 记得指定编译器是clang, directhw下载源代码后, 打开那个Xcode工程, 把几个选项从i386改到x86\_64就可以了

### 安装PackageMaker

<http://adcdownload.apple.com/Developer_Tools/auxiliary_tools_for_xcode__late_july_2012/xcode44auxtools6938114a.dmg>

参考: <http://liwpk.blog.163.com/blog/static/36326170201392914523316/>

    Mac开发：PackageMaker: No such file or directory  
    
    近来苹果默认不提供packageMaker了. 所以需要的话还得自己下.  没有packageMacker, 在打包时候会出现下面错误提示. 
    
    creating package: XXXXXXXXXXXXXXXXXXX.pkg
    /Users/davidli/Downloads/src/Installer/Package/make-package: line 141: /Applications/Xcode.app/Contents/Developer/usr/bin/PackageMaker.app/Contents/MacOS/PackageMaker: No such file or directory
    
    需要自行下载
    download PackageMaker which is included in "Auxiliary Tools for Xcode-Late July 2012"
    from developer.apple.com/downloads
    下载下来的文件名貌似是xcode44auxtools6938114a.dmg
    
    下载后, 右键"packageMaker.app", 选show package contents
    拷贝/contents/MacOS/ 目录下的所有文件（貌似有7个）到/Applications/Xcode.app/Contents/Developer/usr/bin/ 目录中; 
    拷贝packageMaker.app  到/Applications/Xcode.app/Contents/Developer/usr/bin/中. 
    OK了. 


## Others

台湾的同学做了进一步的分析: <http://www.osslab.com.tw/2352639511234602257721578/-apple-macbook-efi>
