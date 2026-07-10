---
title: "使得UCDOS再次伟大"
date: 2026-07-10
layout: post
---

小时候在DOS 6.22上使用UCDOS+WPS打字,响应非常快.即使是在486/586的机器上也运指如飞.

一直想复刻,但水平有限.之前折腾过uim-fep: <https://github.com/scateu/uim-fep-wb86>,勉强可用,要装很多信赖包,年久失修.

还折腾过Vim自带的输入法,速度太慢: <https://github.com/scateu/ywvim>

还很口水fcitx所支持的,与Vim的梦幻联动功能 - 进入退出INSERT模式,会自动把输入法切换回英文.


于是花了一两个小时,请AI复刻了一套.性能非常不错,我很满意.此刻我就是SSH到Raspberry Pi 4上,使用Vim在写本文(其实用Nano也可以).

功能:
 - `Ctrl-\`: 由汉字输入法和英文输入法之间切换
 - `Ctrl-@` 或 `Ctrl-Space`: 由[En] [五] [拼]之间切换
 - `-a` 五笔 四码唯一自动上屏
 - `-V` Vim跟随模式, 根据屏幕最下一行开头是否有`-- INSERT --`和`ESC`和`i`键,来判断输入法跟随.
 - `-s` 只载入五笔还是拼音还是全载入
 - 带词组嘿嘿
 - 不需要其它资源文件,码表集成在文件本体(大了点,4MB多)
 - 透传readline按键们:`C-n C-p ... M-f C-d C-k`
```
./wubi-ime -h
   usage: wubi [-s SCHEME] [-a] [-V] [-h]
  -s, --scheme SCHEME  which tables to load (default: both):
                         both    wubi + pinyin
                         wubi    wubi only
                         pinyin  pinyin only
                       Loading fewer schemes lowers resident memory.
  -a, --auto-commit    wubi: auto-commit a full 4-letter code that has a
                       single exact match (off by default)
  -V, --vim            follow vim insert mode: turn the IME on when vim
                       shows "-- INSERT --", off when you leave insert
  -h, --help           show this help
```


地址: <https://github.com/scateu/wubi-fep>

Demo: [1](https://asciinema.org/a/ybRjkiDkExr9qIUA) [2](https://asciinema.org/a/ElvhVDs2w2y1LZnh) [3](https://asciinema.org/a/JzauBlLHOmWr0ZCZ)
