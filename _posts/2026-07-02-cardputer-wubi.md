---
title: "Cardputer中文打字机"
date: 2026-07-02
layout: post
---

![]({{ site.imageurl }}/cardputer_typewriter.png)

 - 打字速度确实和设备是有关系的, 就像开一辆好车,车给你信心,速度自然就跑起来了

## 使用场景

> "快!憋不住了!" 
>
> "啥? "
>
> "灵感... 灵感憋不住了"


## 之前

一直想要有一个中文Distriction-Free的打字机.

我之前做过如下努力:

 - uim-fep:  仿UCDOS,在Terminal里直接打中文 <https://github.com/scateu/uim-fep-wb86>
 - VIM 五笔输入法: <https://github.com/scateu/ywvim>
 - Linux 内核里把汉字编进去: <https://github.com/Gentoo-zh/linux-cjktty>
 - 还在想使用Grub/Coreboot写

硬件:
 - 买过4台 Alphasmart Neo, 不支持中文
 - 看过Freewrite,但据说有人在上面打了一万多字后丢了
 - 买过Pomera DM250, DM100
 - 口水过BYOK

## Cardputer

最近发现M5 Cardputer ADV小机器,199人民币,好多人在玩

原生的M5 Burner商店里,有韩国大哥写的Micro Journal

于是请出了AI大神,花了两天的时间请祂老人家把Micro Journal加上了五笔/拼音/双拼的支持.

实测打字的响应速度比电脑上还要快.

哦,多提一句,2010年我在听涛园食堂旁,以BlackBerry自动图文集五笔输入法,赢了三星举办的打字竞速赛,获得了一辆自行车.


Micro Journal上游支持的功能:

1. 自动存盘, 3秒
2. 自动存盘的红绿灯提示
3. 可以用外接USB键盘
4. 可以同步到Google Drive
5. 按Fn+0-9可以切10个文件. 应该是参考了Alphasmart Neo的设计

我增加的功能:

1. Ctrl - 空格 切输入法
2. Emacs / Readline 风格的光标移动, C-n C-p上下,C-d删,C-k删到行尾等
3. Ctrl - S 触发保存
4. Ctrl -/+ 切三种字号
5. 按住e键开机,可以进入USB Drive模式,把TF卡给电脑读,导出
6. Flash里给分出了512KB的位置存码表,码表里有index,会载入到内存(因为内存不足够大); 如果码表不够用,还可以考虑把它放进SD卡里,Index仍然进RAM,或Flash.


演示视频在: [1](https://youtube.com/shorts/lltQv1eadMk) [2](https://www.youtube.com/watch?v=CoNwv29xYIk)

项目地址在:<https://github.com/scateu/micro-journal-wubi-v4-esp32> 


---

本文即是在Cardputer上的打字机写作完成. 十分丝滑,比电脑上丝滑多了. 脑子思路跟不上手速嘿嘿.
