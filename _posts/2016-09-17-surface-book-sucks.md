---
layout: post
title:  "Surface Book 折腾记"
date: 2016-09-17 23:59:59
---

中秋帮贵校一位音乐[<del>副</del>教授](http://www.arts.tsinghua.edu.cn/publish/arts/4613/2010/20101226210827556457399/20101226210827556457399_.html)配置他的Surface Book上的Windows 10. 
目标如下:

- [ ] 装Sibelius
- [ ] 装Pro Tools
- [ ] 把Windows 3.1时代的 [Microsoft Music Instrument](https://archive.org/details/microsoft-musical-instruments)跑起来

记下血泪史供后人参考. 

## -1 京东换货
电脑到了首先开不了机. 卡在那不动
壮哉. 二手东换货. 

## 0 版权问题

Sibelius和Pro Tools都是AVID公司旗下的产品. Sibelius是行业标准级别的作曲打谱软件, 与Finale同级别. 二者皆免费提供First版本. [Pro Tools First](http://www.avid.com/ptfirst)永久免费, [Sibelius First](http://avid.com/sibelius-first)可用30天. 

我目前对First版本的体验, 主要是它限制同时只能编辑三个文件, 而且这些文件都会存在它的Cloud上面. 

## 1 Sibelius

### 卡住不动

HiDPI的锅. 

装上Sibelius会卡在Logo那里不动. CPU跑到30%左右, 遇到有人遇到过[同样的情况](http://www.sibelius.com/cgi-bin/helpcenter/chat/chat.pl?com=thread&start=700304&groupid=3&&guest=1). 貌似7.5版本之后会有针对HiDPI的修复. 他的建议是把`Quick Start`引导窗口禁了就行. 不过这方案不完美. 字太小完全看不清楚了. 

	Any Sibelius 7 earlier than 7.5 is incompatible with the pixel scaling of Windows 10 required for the display of the Surface Book. Sibelius will crash when it attempts to display the Quick Start screen, either at launch, or when the last score is closed.
	
	There is no fix for this, and will never be one.
	
	There is a work-around as follows:
	- reduce the Windows pixel scaling to 150% or less;
	- launch Sibelius, as far as the Quick Start screen;
	- uncheck "Show Quick Start when Sibelius starts";
	- uncheck "Show Quick Start again after closing last score";
	- Exit Sibelius;
	- restore Windows pixel scaling to its original value 200%;
	- now you can use Sibelius without the Quick Start screen; 

### HiDPI的目前对策: 降低分辨率

Surface Book的默认分辨率是3000x2000, 默认开启了200%缩放. 
换成1500x1000这样, 缩放变成100%应该就好了. 
不过! Windows 10没有3:2的分辨率, 要么上下有黑边, 要么左右有黑边. 并且不提供Customization的入口. 

折腾了半天, [找到了](https://blogs.msdn.microsoft.com/danchar/2015/10/26/surface-book-and-surface-pro-4-high-dpi-multi-monitor-optimization-regkey-for-alternate-32-aspect-ratio-resolutions/)一个哥们提供的注册表[SP4-SB-custom-resolutions5.reg](https://msdnshared.blob.core.windows.net/media/MSDNBlogsFS/prod.evol.blogs.msdn.com/CommunityServer.Components.PostAttachments/00/10/65/02/47/SP4-SB-custom-resolutions5.reg)文件, 导入重启, 多了以下分辨率:


    2704×1800 (* not quite 3:2 – limited by TCON)
    2400×1600
    2304×1536
    2160×1440
    2056×1368
    2040×1360
    1920×1280
    1800×1200
    1728×1152
    1600×1066
    1536×1024
    1504×1000 (* not quite 3:2 – limited by TCON) <-选了这个
    1496×1000 (* not quite 3:2 – limited by TCON)
    1440×960
    1368×912
    1200×800
    1152×768
    1080×720

起初比较模糊, 但在ClearType里把字体的边缘重新校正一下, 貌似还看得过去. 

## Pro Tools 

### HiDPI
同样的问题, 由于上面配置Sibelius的时候已经解决了. 

### -6117错误卡住无法启动

详细细节在[这篇文章](http://surfaceproaudio.com/running-pro-tools-surface-pro-3/)里有阐述. 

> First of all can we run it on just the Surface without having to plug anything else in? Well you’ll need an iLok which will take up the single USB port. Pro Tools can’t deal with regular Windows audio drivers – it needs an ASIO driver or it won’t get past the splash screen. Luckily there’s an awesome application called ASIO5ALL which wraps up regular WDM drivers into a nice ASIO driver which Pro Tools understands (www.asio4all.com). This enables us to use the Surface’s on-board audio, plug in some headphones and be completely mobile without having to plug-in a proper audio interface. Groovy.

大意是说, Surface Book自带的声卡, 不支持ASIO接口. 工作室里专业人士用Pro Tools, 一般都会有一个外接的Interface盒子支持ASIO接口, 而我们没有的话, 可以用[ASIO4ALL](http://www.asio4all.com)虚拟一个来. 它会在任何程序试图去调ASIO接口的时候, 把外面的声卡包一下, 虚拟桥接一下. Windows 10上可用. 装英文版的比较好. 中文翻译太太太太走心了. 建议安装时勾上那个Offline Configuration Tool什么的, 这样可以在不启动Pro Tools的时候配置ASIO4ALL. 

装上重启了就行. 

哦对, 貌似还不行. 继续卡住. 查了一圈才知道, 需要在系统声音里, 把所有的Speaker/Microphone什么的全部禁用, 等能进去Pro Tools了之后, 都选成ASIO4ALL, 然后关掉, 最后再把那些禁掉的都重新打开. 参考这个视频: [PRO TOOLS FIRST AAE ERROR -6117 FIX (when you already have an ASIO Interface/ASIO4ALL)](https://www.youtube.com/watch?v=d2a3kTqM0y8)

真的好累. 

跑起来了, 貌似输出的声音会卡, 毛刺什么的. 尝试在ASIO4ALL的那几个设置中点一点什么的会有点改观. 不知道是Surface Book的锅, 还是Pro Tools的锅, 还是Windows 10的锅, 还是Realtek的Audio的锅. 锅锅锅锅不是我的锅. 

## 3 Microsoft Music Instrument

这个是Windows 3.1时代就有的程序, 做的真是挺不错的, 尽管很老了, 1992年出品, 但是很完备. 

在Windows 7/ Windows XP上都可以用, 但在这台机器上不能安装. 迅速地提示:

### "this app can't run on your computer"

刚开始是怀疑兼容性的问题, 折腾了好几圈. 甚至装了[ADK, Assessment and Deployment Kit](https://msdn.microsoft.com/en-US/windows/hardware/dn913721.aspx#adkwin10), 试图在系统预置的兼容性黑名单中找到这个程序, 打算给Disable掉就行. (上述过程参考[这个](https://www.youtube.com/watch?v=07XZrn6ZxUM)) 找了几! 个! 小! 时! 未果. 

后来一想, 这个程序是当年Windows 3.1时代的, 当然是16bit的啦, 需要子系统NTVDM. 
找到教程说可以在"Windows功能"中(就是开Telnet/Linux子系统的那个地方)打开. 
或者用以下命令打开. 

    fondue /enable-feature:ntvdm

但是这台机器上死活找不到. 以为是Windows 10的Redstone更新的问题, 正暗自叫苦为啥要手欠花2个小时更新. 

后来才发现, 凡是64位系统里是都是没有NTVDM子系统的, 只有32位系统才行, 即使是64bit的XP也不行. 

只有一条路, 上虚拟机. 

### VMware

偷懒从百度云上找了一个XP的虚拟机, vmdk硬盘文件, 先直接试着导入Virtual Box. 卡住不动. 

后来又装VMware. 导进来, 可以直接用. 但是! 开机关机声断断续续! (keyword: VMware audio distorted). 折腾半天, 没弄好. 于是下载了一个XP的ISO安装镜像, 从头装了一个. 居然好了. 

过了一夜, 正美美地打算收工. 点了一下"升级硬件兼容性"什么的, 并且也点了"升级时克隆一个副本". 然后就把原来的虚拟机又搞成断断续续的了. 

折腾了半天, 甚至尝试改vmx文件里的

    sound.virtualdev = "sb16"
    sound.virtualdev = "es1371"
    sound.virtualdev = "hdaudio"

也不行. 

又发现这事貌似是Windows 8之后出现的, 仅出现于XP作为Guest OS的情况. 也有不少人[遇到过](https://www.experts-exchange.com/questions/28019722/Weird-VMWare-Sound-Issue.html). 给的建议是装一个[VMAudioFixTray](http://www.lilchips.com/vmaudiofixtray.htm). 但是需要.net framework 3.5. 懒得装. 

怒了拖了一个Windows 7 32位的镜像回来从头装了一个新的虚拟机. 好在VMware支持快速安装, 速度还不错. 搞定. 

早点装VMware + Windows 7 32位, 不就完了么. 活活被坑了十几个小时. 

## 结论

买mac. 

不过完全配置好了之后, 把Surface Book拔下来在Sibelius上看谱子的那一瞬间, 舒服了一小会. 

![]({{ site.imageurl }}/sibelius-surface-book.jpg)

## See Also

- <http://staffpad.net/>
- museScore
- Hans Zimmer的纪录片[Hans Zimmer Revealed - The Documentary](https://www.youtube.com/watch?v=jEu-ESPmqs8), 也都是在用Macbook+Pro Tools. 
- Radiolab[也在用](http://transom.org/2012/jad-abumrad-gut-wrench/)Pro Tools

![](https://www.wired.com/images_blogs/gadgetlab/2024/02/gl_jad_8f-660x660.jpg)
![](http://newcdn.transom.org/wp-content/uploads/2012/07/Protools-Screen-Shot.png)

- 有很多配乐的网站, 可直接向作曲家购买版权 <https://bandcamp.com>, 99% invisible podcast在用. 

**MIDI键盘**

- KORG Triton Extreme
- M-Audio Oxygen (全配重)
- M-Audio keyboard station (半配重)
- Coursera上的Pro Tools Basic课程中推荐的 AKAI MPK mini, 貌似只要720块人民币


[Bonus: 周杰伦现场演示用Pro Tools编曲](https://www.facebook.com/jaychoums/videos/1407143322648169/)
