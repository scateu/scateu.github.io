---
title: "RSS2Email替代RSS Reader: 自动建目录"
date: 2026-05-28
layout: post
---

[上一篇文章](https://scateu.me/2025/08/08/rss2email-public-inbox-nntp.html)里我在家里的RPi4+SSD引导(完全不要SD卡)上跑了一年多，很稳定。

这个方案有很多好处:

1. 先存本地，再读；不用担心RSS Reader那样，catch up之后就没了
2. IMAP天生适合多端同步，不用自建那些奇怪的RSS专用的小众同步服务
3. rss2email程序比较稳定，历史久，印象中Aaron Swartz也参与过; 爬取程序可以挂在国际互联网上，原生支持通过IMAP来inject条目。而市面上的RSS Reader的爬取IP要么是源自你的本地电脑(甚至没有设置proxy的功能)，要么是中心爬取，不太可控
4. 不收费: inoreader等有条目上限; Reeder改成订阅制了
5. 可以用你喜欢的Email客户端。我当前是用Thunderbird

我当前每天在0点，8点，16点跑三次rss2email。


唯一的缺点是，所有条目都直接进INBOX，而我又懒得一个一个加配置。于是INBOX会有3万多封。

于是我Vibe Coding了一个[工具](https://github.com/scateu/rss2email_classify)，自动把INBOX里的rss2email过来的邮件，按`From:`头的引号中的文字来命一个名，建目录，移过去。奇怪的字符都会被Escape掉。

上图:

<img  alt="image" src="https://github.com/user-attachments/assets/8d0fe266-1d7c-4488-a747-a0f88b07f3a5" />

<img  alt="image" src="https://github.com/user-attachments/assets/9b50968a-935a-4835-8f6b-561ee1639dc9" />

<img  alt="image" src="https://github.com/user-attachments/assets/8b22c88e-3433-479f-b188-fe589e6d4660" />
