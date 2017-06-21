---
title: "字体及Archlinux折腾记"
date: 2017-06-22
layout: post
---

简言之，就是Firefox显示fastmail里用的Source Sans Pro字体，自带hinting。多次hinting之后，就会有问题，单词的字母之间就会有很大的空间，和空格基本无法区分。


依次试了:

 - Elementary OS
 - Ubuntu
 - Deepin Linux
 - Debian 9
 - Archlinux

都有问题。


以前的老旧字体，加上专利的问题，需要用操作系统的Fontconfig的Hinting来美化。新字体自己内建的Hinting已经很不错了，再加上额外的Hinting就会出问题。

## Firefox 配置

如果Firefox开了 `Allow pages to choose their own fonts, instead of your selections above` 的话，系统的fontconfig中的hinting开关就不起效了。

于是只能override Firefox里面的所有网页自带字体。

```bash
pacman -S adobe-source-{sans,serif,code}-pro-fonts noto-fonts-cjk
```

 - Allow pages to choose their own fonts, instead of your selections above : OFF
 - Fonts for Simplified Chinese:
   - Serif: Noto Serif CJK SC
   - Sans: Noto Sans CJK SC
   - Monospace: Noto Sans Mono CJK SC
 - Fonts for Latin:
   - Proportional: Sans Serif , 16
   - Serif: Droid Serif
   - Sans-Serif: Cantarell
   - Monospace: Dejavu Sans Mono / Source Code Pro
 - Gnome Tweak:
   - Theme:
     - GTK+:  Arc-Darker
     - Icons: Numix-Circle
   - Fonts:
     - Window Titles: Cantarell Bold 11
     - Interface: Cantarell Regular 11
     - Documents: Noto Sans CJK SC Regular 11
     - Monospace: Monospace Regular 11
     - Hinting: Slight
     - Antialiasing: Rgba


## Fontconfig 配置


放在 `~/.fonts.conf`即可

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "../fonts.dtd">
<fontconfig>
	<match target="font">
		<edit name="lcdfilter" mode="assign"><const>lcddefault</const>
	</edit>
	</match>
	<match target="font">
		<edit name="antialias" mode="assign"><bool>true</bool></edit>
		<edit name="autohint" mode="assign"><bool>false</bool></edit>
		<edit name="hinting" mode="assign"><bool>false</bool></edit>
		<edit name="hintstyle" mode="assign"><const>hintnone</const></edit>
		<edit name="rgba" mode="assign"><const>rgb</const></edit>
	</match>
</fontconfig>
```


## 调试
```bash
$ fc-match mono
```

## 附: Archlinux 目前装的包

<details markdown="1"><summary> <pre> pacman -Qet </pre> </summary>
```
adobe-source-code-pro-fonts 2.030ro+1.050it-3
adobe-source-han-sans-cn-fonts 1.004-2
adobe-source-sans-pro-fonts 2.020ro+1.075it-2
adobe-source-serif-pro-fonts 2.000-1
alpine 2.21-1
archlinuxcn-keyring 20170522-1
autoconf 2.69-4
automake 1.15-2
baobab 3.24.0+1+g202d168-1
binwalk 2.1.1-3
bison 3.0.4-2
elvish 0.8-1
empathy 3.12.12+120+g4a4b45b94-1
eog 3.24.1-1
epiphany 3.24.2-1
fakeroot 1.21-2
fcitx-configtool 0.4.9-1
fcitx-gtk2 4.2.9.1-2
fcitx-gtk3 4.2.9.1-2
fcitx-table-extra 0.3.7-2
firefox 54.0-1
flex 2.6.4-1
gdm 3.24.2-1
gnome-backgrounds 3.24.0+2+g755b6f9-1
gnome-calculator 3.24.0+2+g0ca2919b-1
gnome-contacts 3.22.1+4+gb235b6d-1
gnome-dictionary 3.24.0+5+ga7aa054-1
gnome-disk-utility 3.24.1-1
gnome-font-viewer 3.24.0-1
gnome-screenshot 3.22.0+42+g8472361-1
gnome-shell-extensions 3.24.2-1
gnome-system-monitor 3.24.0+4+g9140c85a-1
gnome-terminal 3.24.2-1
gnome-tweak-tool 3.24.1-1
gnome-user-docs 3.24.2-1
grub 2:2.02-1
gucharmap 9.0.4-1
hexchat 2.12.4-4
inetutils 1.9.4-5
intel-ucode 20170511-1
iputils 20161105.1f2bb12-2
jfsutils 1.1.15-4
licenses 20140629-2
logrotate 3.12.2-1
lvm2 2.02.171-1
make 4.2.1-2
man-db 2.7.6.1-2
man-pages 4.11-1
mdadm 4.0-1
mousetweaks 3.12.0-2
nano 2.8.4-1
nerd-fonts-complete 1.0.0-3
net-tools 1.60.20160710git-1
netctl 1.12-2
network-manager-applet 1.8.2-1
noto-fonts-cjk 20170512-1
numix-circle-icon-theme-git 0.r16.5a11140-1
numix-gtk-theme 2.6.6-1
nvidia 381.22-3
pam_u2f 1.0.4-1
patch 2.7.5-1
pcmciautils 018-7
pkg-config 0.29.2-1
procps-ng 3.3.12-1
proxychains-ng 4.12-1
ranger 1.8.1-1
reiserfsprogs 3.6.25-1
rslsync 2.5.4-1
shadowsocks-libev 3.0.6-1
sushi 3.24.0-1
telegram-desktop 1.1.7-1
the_silver_searcher 2.0.0-1
tmux 2.5-1
totem 3.24.0-1
typora 0.9.29-2
uim 1.8.6-7
usbutils 008-1
vi 1:070224-2
vim 8.0.0628-1
weechat 1.8-2
wget 1.19.1-2
which 2.21-2
xcursor-vanilla-dmz 0.4.4-1
xdg-user-dirs-gtk 0.10+9+g5b7efc6-1
xfsprogs 4.11.0-1
yaourt 1.8.1-1
zsh 5.3.1-2
```
</details>


**Fcitx:** 由于没用X而用了Wayland，不能在`.xprofile`里加，而应该在`/etc/environment`里加:

```
$ cat /etc/environment 
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

## 参考

 - <http://www.jinbuguo.com/gui/linux_fontconfig.html>
 - <https://gist.github.com/dantmnf/0ed6e21b6ad80bb3570a0917c9cef4bc>
 - [Bigeagle: Archlinux安装教程](https://bigeagle.me/2014/06/archlinux-install-for-beginners/)
 - [bigeagle/dotfiles](https://github.com/bigeagle/dotfiles)
