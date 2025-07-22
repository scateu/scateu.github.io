---
title: "Chromebook: Coreboot, Libreboot, Debian原生安装"
date: 2025-07-22
layout: post
---

设备: Samsung Chromebook Plus V1 (arm64, codename: gru/kevin, CPU Rockchip RK3399, XE513C24)。 网卡型号 Marvel 88W8997

## 安装Libreboot

### 1. 解除SPI Flash写保护螺丝

参考文章:
 - 

写保护螺丝是把SPI Flash的WE(Write Enable)线拉到GND上。需要拆除才能刷Libreboot

拆开机壳，把散热片拆下来，把HDMI连接器拆下来，把右下角的喇叭拆下(线先不拆)。把几个排线拆下(有一个黑色压条)
目标是把主板翻个面，电池在下方的阵形中，右上角的散热片紧固螺丝(在背后，键盘与主板之间)，拆下。

```
         屏线   黑盖  Type-C
                      Audio Jack
      主板

           SPI FLASH

SPK    电池    SPK

```
散热片的螺柱与主板的螺孔之间，有一圈金属网圈，一定要撕下来，否则仍然WE线仍然在GND上。

```
   / \
   \ /

```

撕掉金属网圈，露出上图螺孔的圈圈,实际上是四个小焊盘组成的一个圆形。其中一组对角是GND。

记得要用螺丝刀把这四片焊盘之间划拉干净，不然还是接到GND上。SPI Flash没办法写。


### 2. 上编程器

Samsung Chromebook Plus v1, codename: Kevin
使用的Flash是TODO

它用的是1.8V电压

买回来CH341A，还需要买1.8V的适配板。

用夹具夹上，烧写`libreboot-20241206rev11_gru_kevin.tar.xz` 中的.rom文件

Windows上有个比较好用的工具叫: `thereadreg/asprogrammer-dregmod`


如果直接把这个SPI Flash吹下来烧录，就可以省得折腾第1步里的写保护螺丝了。


### 2‘. 如果没有编程器: flashrom 内置烧写

就先进入Developer模式，或者各种方式能有flashrom工具(比如imagebuilder啊，各种虾系OS)
的情况下:

	sudo flashrom -p internal -w uboot_gru_kevin_libgfxinit_corebootfb.rom

注意20241206版本的uboot有wifi, lspci:

	00:00.0 PCI bridge: Rockchip Electronics Co., Ltd RK3399 PCI Express Root Port
	01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88W8997 2.4/5 GHz Dual-Band 2x2 Wi-Fi® 5 (802.11ac) + Bluetooth® 5.3 Solution (rev 11)

https://mirror.math.princeton.edu/pub/libreboot/

最新版 FAILED: libreboot-25.06_gru_kevin.tar.xz 没有wifi。lspci里是空的。


## 装Debian

参考:  https://libreboot.org/docs/uboot/uboot-debian-bookworm.html

注意，最后一步

 - YES: Force installation to removable media path
 - NO:  Update NVRAM Variables

网卡驱动在:

```
sudo apt install firmware-libertas
```



## i3wm

/etc/i3status.conf:

```
order += 'battery 0'
battery 0 {
    format = "%status %percentage %remaining"
	path = /sys/class/power_supply/sbs-9-000b/uevent
}
```

`~/.config/i3/config`:

```
exec xrandr --dpi 220
```

```
sudo apt install suckless-tools
```

