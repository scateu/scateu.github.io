---
layout: post
title: 再用UEFI就剁手
date: 2014/03/25 23:37:35
---

# 再用UEFI就剁手

适用于最新预装了Win8的笔记本

Thinkpad X230s / X240

试图在原有的Win7旁边装双系统

最终的方案如下：（其中血泪不表）

  * 进BIOS 
    * 把USB 3.0模式先关了, 否则装Win7不认USB光驱/硬盘/U盘/PE
    * 把Safe Boot 关了
    * OS Optimizing关了
    * UEFI Boot换回Legacy Only
  * _切记_ 把原来所有东西都格了, 特别是主引导区前面的什么鸟GDT
  * 装Win7
  * 装Ubuntu

再碰UEFI剁手. 一个晚上没了