---
title: "IMAP Notes"
date: 2023-08-29
layout: post
---

IMAP的实时性是非常好的。 它的和什么Handover速度不相上下。可惜作者Mark R. Crispin英年早逝，sigh。

## Alpine IMAP Notes

我一度在[alpine电子邮件客户端](http://scateu.me/2015/08/23/alpine.html)里配置了一个Role，新建一封消息，把所有都置空，只留Fcc (File Carbon Copy)到NOTE目录。

然后在主界面上按`#`，即可选这个`NOTE`的角色， 来写一封笔记。然后按`C-x`发送。

由于我配置了允许空收件人，`[X]  Send to Fcc Only Without Confirming`。

至此，可以优雅地把任何IMAP Server变成笔记工具。

```
Current Folder Type =
            (*)  Specific (Enter Incoming Nicknames or use ^T)
                 Folder List = {mail.example.com:993/ssl/user=scateu@example.com}NOTE
                 
Set From        = NOTE <note@scateu.me>
Set Fcc         = NOTE  #注意，在Fastmail里或者其它主流邮箱，Notes名字是苹果Notes.app用的保留字。下面马上要讨论到。
Use SMTP Server = dumb
Use NNTP Server = dumb   #防止误发
```

如果要修改NOTE，只需要在对应的Folder里，按`r`回复，Rules也会自动生效。

(btw: 而且这样还有机会做成一个Public IMAP BBS，我打算称它为Draft BBS。)


这个方法非常有效，我从2019年2月开始，一些很有趣的，不太敏感，但又不足以发到Blog的东西，就这样保存。


## iPhone原生的Notes.app

iPhone / macOS 上的 Notes.app 简直是扮猪吃老虎的典范。原来它本身就是个IMAP Client!

我之前还在奇怪，为什么苹果系统上添加新邮箱之后，邮箱下面总有一个Note开关。还以为是CalDAV/CardDAV的类似机制。没想到就是IMAP本身。

### IMAP note built by iPhone长什么样?

在手机上新建了一条备忘录。长这样。

```eml
Content-Type: text/html;
    charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: sdf <scateu@sdf.org>
X-Uniform-Type-Identifier: com.apple.mail-note
Mime-Version: 1.0 (iOS/15.7.8 \(19H364\) dataaccessd/1.0)
Date: Tue, 29 Aug 2023 19:50:49 +0800
X-Mail-Created-Date: Tue, 29 Aug 2023 19:50:37 +0800
Subject: =?utf-8?B?5ZWKaG8g55yf5LiN6ZSZ?=
X-Universally-Unique-Identifier: 0AB01715-09B5-4925-A75D-DE9CCC03D8EA
Message-Id: <0EC3A552-1784-4784-9CA6-70AB043A1600@sdf.org>
Content-Length: 253

<html><head></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; line-break: after-white-space;">啊ho
真不错<div><br></div><div>啊哈哈吼</div><div><br></div></body></html>``
```


### Alpine 上新建一封Notes.app可读的备忘录

同理，新建一个Role。

```
Set Fcc         = Notes
Set Other Hdrs  = X-Uniform-Type-Identifier: com.apple.mail-note
```


### Troubleshoot: 更新慢

经测试，新建一封Notes是很快能推到IMAP服务器上的，无论是在iPhone、mac还是在alpine里。

但被更新方的手机的Notes.app可能不会及时拉取。而Notes.app界面上没有下拉刷新。

1. 只需要到Mail.app里下拉刷新一下，然后在Notes.app界面上退到列表上，就会更新了。
2. 或者，在"设置>备忘录>账户>抓取新数据>[你的IMAP]" 由"抓取"改为"手动"。貌似效率反而更高。


### See also
 - <https://f-droid.org/packages/com.Pau.ImapNotes2/>
 - <https://jpmens.net/2015/09/28/experiments-using-imap-for-notes/>
    - <https://gist.github.com/jpmens/4ffde3335d1479a9abf0>
 - Thunderbird插件: <https://addons.thunderbird.net/cs/thunderbird/addon/ios-imap-notes/>
 - <https://kevinlee.io/wiki/IPhone_Notes_Shell_Script>
 - <https://forums.zimbra.org/viewtopic.php?t=66943>

> Well, I use the HeaderTools plugin with Thunderbird to accomplish this, so it's certainly possible. The notes app picks up the changes right away. 

## 外一则: taskpaper 通过 alpine 的 IMAP 工具同步

用户在一个全新的机器上(比如图书馆公用计算机)，可以直接敲

```bash
alpine -p {imap.example.org:993/ssl/user=scateu@example.org}remote_pinerc
```

就会从IMAP服务器的`remote_pinerc`目录里把配置文件拉下来，然后收邮件。这个设计太妙了。
而且所做的alpine配置的修改，可以直接被commit到这个IMAP目录。

alpine有一个remote folder机制。可以将配置文件写到一个同名的IMAP目录。可以保留5个版本。

比如`remote_pinerc`:

```
      1 13/Feb/19 Pine Remote D Header Message for Remote Data
      2 Aug 22    Pine Remote D Pine Remote Data Container
  N   3 Wed 21:31 Pine Remote D Pine Remote Data Container
      4 Wed 21:32 Pine Remote D Pine Remote Data Container
  N   5 Tue 21:52 Pine Remote D Pine Remote Data Container
```


```
Date: Wed, 13 Feb 2019 18:06:56
From: Pine Remote Data <nobody@nowhere>
Subject: Header Message for Remote Data

This folder contains a Alpine config file.
This message is just an explanatory message.
The last message in the folder is the live config data.
The rest of the messages contain previous revisions of the data.
To restore a previous revision just delete and expunge all of the messages
which come after it.

```

### 同步任意文本文件

于是我借用这个机制，在多机之间同步几个小文本文件。

```makefile
# password on macOS Keychain: add an item named 'taskpaper' in 'login' keychain.
upload:
        for i in 0 A B P P2 imac; do sshpass -P 'ENTER PASSWORD:' -p $$(security find-generic-password -l taskpaper -g 2>&1 1>/dev/null | cut -d'"' -f2) rpload -s 5 -t sig -l $$i.taskpaper -r {imap.example.org:993/ssl/user=steve@example.org}INBOX.taskpaper.$$i;done

download:
        for i in 0 A B P P2 imac; do echo $$i; sshpass -P 'ENTER PASSWORD:' -p $$(security find-generic-password -l taskpaper -g 2>&1 1>/dev/null | cut -d'"' -f2) rpdump -l $$i.taskpaper -r {imap.example.org:993/ssl/user=steve@example.org}INBOX.taskpaper.$$i;done

# Shortcuts: upload
# tell application "Finder" to set currentDir to (target of front Finder window) as text
# do shell script "export LANG=en_US.UTF-8; export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin; cd ~/org/taskpaper;git commit -am 'before upload @iMac'; make upload"

# Shortcuts: download
# tell application "Finder" to set currentDir to (target of front Finder window) as text
# do shell script "export LANG=en_US.UTF-8; export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin; cd ~/org/taskpaper;git commit -am '@iMac before download'; make download"
```

