---
layout: post
title:  "Chromebook 手记"
date: 2016-10-09
---

买了 [ASUS Chromebook Flip](https://www.amazon.com/Chromebook-10-1-Inch-Convertible-Touchscreen-Rockchip/dp/B00ZS4HK0Q/ref=sr_1_1?s=pc&ie=UTF8&qid=1474962276&sr=1-1&keywords=chromebook+flip).用银联的信用卡还有10刀的优惠.机器本身 \$269.15.

亚马逊自营, 9月27日下单, 9月30日晚上清关完成. 10月8日上班第一天, 下午一点多收到. (要不是因为国庆UPS不工作, 10月1日应该就能到手了. )


可以用原生五笔! 是目前体验最顺滑的输入体验了. 键盘手感也挺不错的. (Windows 10经常在切输入法的时候卡很久. )


非常丝滑, 感觉比电脑上的Chrome浏览器还要滑. 

电池也非常给力, 实打实的9个小时. 不会因为突然Flash什么的跑野了电量狂掉. 

但是开机即需要一个原生翻墙的WiFi, 这点在国内用起来比较糟糕. 

另外, 看Chromebook貌似已经是2016第一季度最受欢迎的笔记本了, 据说还第一次出货量超过了Macbook. 
不贵, 所以美国中小学老师们都指定它作为上学用机. 

折腾了这个设备一番, 感觉非常接近我的需求:

 - Distraction Free
 - 打字机
 - Hackable
 - 便宜! 
 - 电量足! 

## Android

目前Chrome OS里面已经可以使用Google Play了, 即Android上的所有应用都可以在Chromebook上跑. 最感人的是, 不费电. 

注意, Android系统有独立的设置, 在Chrome设置中有一个链接可以点进去. 你可以把它固定在任务栏里. 

## 推荐应用

 - Text 可以离线写字, 配合SD卡/BTSync使用, 风味更佳
 - Telegram Chrome Web版
 - 原生的Files里可以装SFTP之类的插件
 - Octotree: 给Github/GitLab左边加一个文件导航栏, 看代码的时候很方便
 - Feedly: 网页版的就好了
 - Cisco Anyconnect for Chrome OS
 - XMarks: Lastpass旗下的书签同步, 建议用的时候, 把Chrome自身的同步特性关掉. 我遇到过一次冲突的问题. 
 - Secure Shell: 用于登SSH. 在它的任务栏图标上勾上"在窗口中打开", 所有的快捷键就可以都用. 
 - Crosh Window: 配合下文chroot环境使用

## chroot环境

先进Developer Mode, 再按Ctrl+D. 按下不表, 请自己检索具体过程. 按`Ctrl + Alt + T`可以打开一个Terminal, 输入`shell`回车. 


在这里 <https://github.com/dnschneid/crouton> 下载 `crouton`. 

注意, 一定要在所在的目录里面执行`crouton`, 例如:

    cd ~/Downloads
    sudo sh crouton -t cli-extra  -m https://mirrors.tuna.tsinghua.edu.cn/debian/ -r sid  

*(貌似在外面的目录里面`$ sudo sh ~/Downloads/crouton`装到后面会报错. )*

进入chroot环境:

    sudo enter-chroot


注意,这里面的sudo补全有问题.

体验非常好, 有兴趣的可以装xfce等图形界面, 非常神奇. 此外, 实测*不费电*. 


### 推荐 

使用Chrome的插件: Crosh Window. 这样`Ctrl+N`这样的快捷键就都能用了. 

Secure Shell: 用于登SSH. 在它的任务栏图标上勾上"在窗口中打开", 所有的快捷键就可以都用. 

### 不足

输入法用不了.....用不了.... 于是要么用emacs/vim里的输入法, 要么用我之前推荐的UCDOS风格的`uim-fep`. 

见: <http://scateu.me/2016/03/11/vim-im.html>


### Downloads文件夹读写效率

注意, 在chroot环境里, 尽量不要直接对Downloads文件夹做大量文件读写. 貌似是chroot环境里面对Downloads文件夹的挂载实现有问题. 

会卡住. 

## Shadowsocks

Android子系统里的网络是以NAT的方式从ChromeOS出来的. 

因此, Chrome想科学上网的话, 只能在chroot环境里跑一个`sslocal`. 

配合SwitchOmega/xxxlist使用风味更佳. 

2018-01-23补充: <chrome://flags> 里 `#arc-vpn` 可以让Android里面的应用接管Chrome的流量

## BTSync (Resilio Sync)

在chroot环境里用armhf版本的就行了. 

或者在Android子系统里装, 但是不能读写SD卡. sigh...

反正可以长时间不关机, 进一次chroot环境, 把东西起好了就行. 

## Tips

 - Ctrl + Alt + ? 可以看到所有的按键帮助, 按下Ctrl Alt等键会显示对应的快捷键
 - 触摸板的滚动方向是可以调整的
 - Alt + Backspace  = Del
 - 搜索键可以被重定义为Ctrl/CapsLock等等
 - Ctrl + 左 右 可以快速在单词间跳转 
 - 全屏状态下, 图标/标签页会留下一点点小的横线, 在屏幕外侧对应的位置用手触摸, 可以切换过去. 换句话说, Chromebook的屏幕显示区域外侧是有一些额外的触摸区的. (这样全屏状态就非常好用啦, 我的Chrome经常就置于全屏模式, 视野非常好)
 - Search + Up/Down = PgUp/PgDn
 - 截图: 
   - 全屏: Ctrl+切换窗口键
   - 部分: Ctrl+Shift+切换窗口键
 - 设置中, 还有 Alt + Backspace 等相关键绑定的设置, 很贴心. 如果发现有不舒服的地方, 都可以去改. 
 - 可以把自动时区关掉, 否则它会可能根据你VPN的位置, 擅自修改系统时区. 
 - Alt+Shift+m 打开文件管理器
 - 彩蛋: Ctrl+Shift+Alt+刷新 
 - 系统诊断数据: chrome://system/
 - Search+Esc: 任务管理器
 - Alt+Search = Caps Lock
 - 貌似有原生的emacs可以用: <https://www.emacswiki.org/emacs/EmacsForChromeBooks> (目前的ARM机器还不完全被支持)
 - Crosh Window: 配置Powerline字体: [wernight/powerline-web-fonts](https://github.com/wernight/powerline-web-fonts)


## One More Thing

如果你想在自己的笔记本电脑上跑ChromeOS, 可以使用~~<http://getchrome.eu/download>~~ [CloudReady](https://www.neverware.com/freedownload/) 提供的编译好的ChromiumOS镜像. 试了一下在Thinkpad上跑起来, 挺流畅的. 可以先当LiveUSB体验一下再考虑安不安装. 另外, 安装的时候可以双系统. 

Chromium OS是开源的. 

2017-02-07 补充: sbilly提醒，有一家国内的公司 [Flint OS](http://techcrunch.cn/2017/02/06/flint-os/)，打算把Chromium OS本土化。

以及2016年10月中旬，阿里和HP及Intel[发布了中国版的Chromebook](http://www.ifanr.com/731268)。

此外, 此机器的拆解见[张宇翔发布在iFixit上的帖子](https://www.ifixit.com/Teardown/Asus+Chromebook+Flip+C100P+Teardown/72454)


## Links

 - [Crouton Command Cheat sheet](https://github.com/dnschneid/crouton/wiki/Crouton-Command-Cheat-Sheet)
 - [Crouton udev workaround](https://github.com/dnschneid/crouton/wiki/udev:-manage-inserted-devices)

## [Blink兄](https://blog.blink.moe/)的Chromebook故事

简言之就是买了之后, eMMC坏掉了, 且无法进行Recovery. 一直在转圈. 按Ctrl-Alt-F2貌似可以看到安装脚本在失败之后, 使用`badblocks`在检查坏道了. 

买了[H26M52103FMR](https://item.taobao.com/item.htm?ut_sk=1.WAionKv8eSQDAI%2BwbiJNt3KW_21380790_1479807598643.Copy.1&id=45849929512&sourceType=item&price=35-85&suid=59CBBBF7-DDB7-4FD0-9FC2-F78037047B9E&un=d49adc12bab59d5fc8173a2742a8d707&share_crt_v=1&cpp=1&shareurl=true&spm=a313p.22.1eg.16658551388&short_name=h.YFlnQX&cv=AAbEPRDo&sm=a6f2bd&app=chrome)(大约35块钱)去中关村换上好了. 


## See Also

 - [Bigeagle 关于 ASUS Chromebook Flip 的体验](https://bigeagle.me/2017/02/ASUS-chromebook-flip/)
 - [Ubuntu.com上的教程](https://tutorials.ubuntu.com/tutorial/install-ubuntu-on-chromebook)
 - [Fugoes: Chromebook手记](https://blog.fugoes.xyz/2018/09/19/Notes-on-Chromebook.html)


<iframe width="560" height="315" src="https://www.youtube.com/embed/K_dd7yINXCE" frameborder="0" allowfullscreen></iframe>


## Secure Shell里显示图片

*2018-01-23补充*

类似于[iTerm2](https://iterm2.com/documentation-images.html)和w3m的`w3mimgdisplay`及[ranger](https://github.com/ranger/ranger/wiki/Image-Previews)或[termpdf](https://github.com/dsanson/termpdf)，Google Chrome近期也支持了原生的Terminal传图片的协议:

<https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc/hterm-show-file.sh>

在最近的版本，Secure Shell，按`Ctrl-Shift-P`

```
Extensions
	allow-image-inline : true
```

即可。

用上述`hterm-show-file.sh`

```
hterm-show-file.sh blahblah.png
```

Chroot环境、ssh都可以。


## 2018年9月23日补充

 - 入了一台Samsung Chromebook Plus，可以参看[Fugoes: Chromebook手记](https://blog.fugoes.xyz/2018/09/19/Notes-on-Chromebook.html)

如果想干掉原来的系统，装原生的Linux:(仅X86... //sad)

 - <https://galliumos.org/>
 - <https://chrx.org/>

如果是ARM的，Debian的教程似乎不错:
 - <https://wiki.debian.org/InstallingDebianOn/Asus/C201#Installing_to_internal_memory_from_SD_card>
