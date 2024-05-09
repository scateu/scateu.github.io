---
title: "Chromebook装原生Linux"
date: 2023-09-28
layout: post
---

2016年在xiaq大牛的推荐下，我[买了Chromebook](http://scateu.me/2016/10/09/chromebook-rocks.html)，然后推荐了大鹰也[买了Chromebook](https://bigeagle.me/2017/02/ASUS-chromebook-flip/)。

不多久，这款ASUS Chromebook Flip (armhf, codename: veyron-minnie) 被Google停止支持了。而且这款设备不支持KVM-based Linux，只能用chroot的方式用Linux。ChromeOS的底层应该是Gentoo。

于是我又在淘宝上买了一台Samsung Chromebook Plus V1 (arm64, codename: gru/kevin, CPU Rockchip RK3399, XE513C24)。虽然能用Linux子系统了，但在国内访问Google实在是麻烦，首次开机要Google，输密码要用Gmail账号，Proxy设置也奇怪。反正使用率很低。

特别是，这只Samsung Chromebook Plus在昨天被Google下达最后一次安全更新。不爽。于是花了一天一夜时间装好了Linux。


先说过程，再说结论。

## 先一天一夜试了这几个海鲜项目

(这几条路，1和5可以继续用，其它的可以不再看了。)

1. [PrawnOS](https://github.com/SolidHal/PrawnOS)(只能用sd卡装)。完成度不错。但作者把所有专有固件什么的都干掉了，即使你找到了Firmware，Kernel也会拒绝load... 没有WiFi，有声音。串口驱动有些不支持。比如QRP Labs的QMX插上去玩FT8不行。貌似也可以[手动编译](https://github.com/SolidHal/PrawnOS/issues/282)，`make BLOBBY_BUILD=1 TARGET=armhf kernel_config`这样。
2. Cadmium(只能用u盘装)，装上有WiFi固件，但没声，原因是Kernel版本卡在不高不低，刚好把声音搞坏了。而且作者已经把项目Archive掉了。
3. Gentoo: <https://wiki.gentoo.org/wiki/Samsung_Chromebook_Plus>
4. Arch: <https://archlinuxarm.org/platforms/armv8/rockchip/samsung-chromebook-plus>
5. hexdump0815/imagebuilder  **胜出！** 最新Kernel！自动Build！支持设备种类多！有WiFi! 有声音! 开发活跃! 硬件解码视频正常！触摸屏正常！

这些项目的名字都是海产品，吃多了海产品会镉中毒(Cadmium)吧。

我理解是，先有Prawn(对虾)。后有Shrimp(虾)，再有Cadmium(镉 <del>中毒</del>)，后来再有人基于这俩出了[CrawfishOS](https://github.com/austin987/crawfishos
)。

## 柳暗花明 SOLUTION: hexdump0815/imagebuilder

### 1. 设置开发者模式

这些步骤可以参考[PrawnOS](https://github.com/SolidHal/PrawnOS)的教程。

1. 先要在Chromebook上按 "ESC - Refresh - 电源" 开机，置为Developer模式。
2. Enable Debugging Features.  设置密码
3. 登录google账号 (可以不做，直接Ctrl-Alt-F2, root 然后你的密码)
4. Ctrl-Alt-T  开终端
5. 敲`shell`回车，再敲下面两行允许usb引导，不检查签名

```bash
crossystem dev_boot_signed_only=0
crossystem dev_boot_usb=1
```

### 2. 准备: 烧U盘/SD卡

去<https://github.com/hexdump0815/imagebuilder/releases>里按你的机器的codename找到对应的release，比如这台Samsung Chromebook Plus V1机器codename是gru/kevin，按前面的gru算，下载这个就行:

`https://github.com/hexdump0815/imagebuilder/releases/download/230220-03/chromebook_gru-aarch64-bookworm.img.gz`

### 3. 装

开机，在原来按`Ctrl-D`才能进系统的位置，插上U盘/SD卡，按`Ctrl-U`，从U盘引导。

此时已经可以当LiveCD LiveUSB LiveSDCard用了！好多企鹅！最新内核！

按项目的教程 <https://github.com/hexdump0815/imagebuilder/blob/main/doc/install-to-emmc-on-arm-chromebooks.md> ，有三种方法可以装

我用方法1，直接`dd`就装好了。一定注意要找对codename，否则起不来。
(注意ASUS Chromebook Flip,  C100 codename: veyron-minnie，这台不能直接dd，得仔细看安装说明。)

具体来说

0. `Ctrl-U`进LiveUSB系统，启动用户名/密码为 linux / changeme
1. U盘LiveUSB系统里，先执行`/scripts/extend-rootfs.sh`，把U盘变大
2. 然后再拷一份`chromebook_gru-aarch64-bookworm.img.gz`到U盘里
3. `zcat *.img.gz | dd of=/dev/mmcblk1 bs=1024k status=progress` 此处的`mmcblk1`可以由`fdisk -l`看出，21GB左右。
4. 写完eMMC后，重启，启动按Ctrl-D引导。(每次都要)
5. eMMC系统进去之后，再执行一下`/script/extend-rootfs.sh`，把eMMC撑大。



## REF


<details markdown="1"><summary>随手记的比较乱，也放这里备用吧。</summary>
```
    armhf cpu:
        Asus C201 (C201P) (C201PA) (veyron-speedy)
        Asus C100 (veyron-minnie)   — cyxu
        BETA Asus Chromebit CS10 (veyron-mickey)
    arm64 cpu:
        BETA Samsung Chromebook Plus V1 (XE513C24) (gru-kevin)
        ALPHA Asus C101p (gru-bob)

-----
Samsung Chromebook Plus

https://github.com/hexdump0815/imagebuilder/blob/main/systems/chromebook_gru/readme.md
https://github.com/Maccraft123/Cadmium/releases
https://tuxphones.com/cadmium-linux-for-chromebooks/

声卡:
    https://archlinuxarm.org/platforms/armv8/rockchip/samsung-chromebook-plus
    关键词:  rk3399-gru-sound 
    https://github.com/thesofproject/linux/pull/3681
    cd /usr/share/alsa/ucm2; sudo mv rk3399-gru-soun rk3399-gru-sound

Sound seems to be broken on all kernels above 5.10, so the only solution is to downgrade to that one following my example.
https://github.com/MichaIng/DietPi/issues/5337


编WIFI:
https://github.com/SolidHal/PrawnOS/issues/282
Did you build PrawnOS with the bobby kernel option or did you compile the non-free kernel independently to use with PrawnOS?

需要WiFi Firmware: 88W8997.bin
https://git.lsd.cat/g/PrawnOS-nonfree   这个Build可能可行

make BLOBBY_BUILD=1 TARGET=armhf kernel_config	
https://github.com/SolidHal/PrawnOS#dependencies
https://github.com/SolidHal/PrawnOS/issues/282

C100PA:
https://gist.github.com/kapilhp/01c3e8fc24d938eeaa45c1c2ab02eaaa
https://github.com/SolidHal/PrawnOS
https://github.com/austin987/crawfishos

gru 	kevin 	Samsung 	Chromebook Plus V1 	Convertible laptop 	eDP 	No 	4GB 		atmel-mxt-ts 	atmel-mxt-ts 	? / mwifiex-pcie 		No
veyron 	minnie 	Asus 	C100PA 	Convertible laptop 	1280x800 eDP 	No 	2-4GB 	16-32GB 			BCM4354 SDIO / brcmfmac 		No 	

After rebooting/powering on, at the 'OS verification is off' screen, press 'CTRL' + 'U' to boot from USB/SD. Or 'CTRL' + 'D' to boot from the internal emmc.

Make sure the device is in developer mode. Open the terminal window by pressing Ctrl + Alt + F2. Log in as root . Type the default password test0000, or the custom password you set previously.


The device you inserted does not contain chrome os:
> Next time you see the missing or damaged screen press the tab key. 

```
</details>

## 小调整们
 - xfce: settings > 
   - Power Manager > Laptop Lid: When Laptop lid is closed: Switch off display
   - Login Window > Users > Hide the user list -> OFF

 - i3status的电池: 在`/etc/i3status.conf`里`battery all`一节改成: (然后alt-shift-r重启i3才能生效)

```
battery all {
    path = "/sys/class/power_supply/%d/uevent"
	format = "%status %percentage %remaining %emptytime"
	format_down = "No battery"
	status_chr = "⚡ CHR"
	status_bat = "🔋 BAT"
	status_unk = "? UNK"
	status_full = "☻ FULL"
	low_threshold = 10
}
```

 - Suspend的话， <del>以root`# echo mem > /sys/power/state`，这个太猛了。 </del> 通常会用`systemctl suspend`
 - PowerButton: 先在`/etc/systemd/logind.conf`里把`HandlePowerKey=ignore`，再在`.config/i3/config`里绑上`bindsym XF86PowerOff exec --no-startup-id systemctl suspend`
 - 关Trackpad，有时候容易误触 `synclient TouchpadOff=1` 开是`0`

## 小结

Chromebook原生Linux: 进developer模式，`Ctrl-U`引导进U盘系统，hexdump0815/imagebuilder牛。

可惜bigeagle和[fugoes](https://blog.fugoes.xyz/2018/09/19/Notes-on-Chromebook.html)都把Chromebook卖掉了。<del> "就差一步啊，就差一步 ...." </del>

## 又及

当年有幸[见过一回](https://github.com/scateu/scateu.github.io/blob/master/images/with_rms.jpg?raw=true)Richard Matthew Stallman，当时没有理解他为什么若为自由故。现场貌似还有个哥们拿了台mba找他签名，RMS果然不签。

用了iPhone Android macbook越多，越觉得自由软件重要，起码不至于被强制报废。

## See Also (updated: May 9, 2024)

 - <https://wiki.postmarketos.org/wiki/Devices>
