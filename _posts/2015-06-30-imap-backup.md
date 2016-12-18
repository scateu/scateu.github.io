---
layout: post
title:  "使用mbsync对IMAP邮箱进行备份"
date: 2015-06-30 8:52:00
---


最近由于想备份一下邮件, 于是申请了另一个Gmail邮箱, 尝试备份. 

之前有写过一篇[《将国内邮箱优雅地迁移到Gmail》](http://scateu.me/2015/03/20/mail-migrate.html), 但是隐约总觉得还是不够优雅. 


先贴最终答案:

环境:

 - 源邮箱: `scateu@mail.example.com`
 - 备份邮箱: `scateu.example@gmail.com`
 - 备份邮箱上不做操作, 完全被动镜像自源邮箱

先装东西:

    $ sudo apt-get install isync

再写配置文件:

    $ cat .mbsyncrc

    Expunge None
    Create Slave  # 只在Slave上创建新文件夹, 不对Master做操作

    IMAPStore scateu.example-source
    Host "imap.mail.example.com"
    User "scateu@mail.example.com"
    Pass "password"
    UseIMAPS yes
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    PipelineDepth 1  #有时候不加这一行, 邮箱并发太大, 会被服务器拒绝掉
    
    IMAPStore scateu.example-gmail
    Host "imap.gmail.com"
    User "scateu.example"
    Pass "password"
    UseIMAPS yes
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    
    Channel backup
    Master :scateu.example-source:
    Slave :scateu.example-gmail:
    Expunge Slave
    Sync Pull
    CopyArrivalDate yes  #将原邮箱的时间信息也同步过来, 否则以拉取的时刻上传, 不方便
    Patterns INBOX *     # 将INBOX和除了INBOX之外的所有(*)文件夹都同步

最后

    $ mbsync backup

首次同步会比较慢, 之后的同步会基于`~/.mbsync/`里面的数据, 再同步就会比较快了. 

另外, 如果你的网络环境里有IPv6, mbsync也是支持的. 

## offlineimap

之前还试过offlineimap, 但是感觉不太稳定, 经常崩溃, 迫不得已要用

    while true;do offlineimap;done

但也在此给出一个示例的配置文件好了:

    $ cat .offlineimaprc

    [general]
    accounts = MailBackup
    
    #ui = Blinkenlights
    
    [Account MailBackup]
    localrepository = scateu.example-gmail
    remoterepository = scateu.example-source
    
    [Repository scateu.example-source]
    type = IMAP
    
    remotehost = imap.mail.example.com
    remoteport = 993
    remoteuser = scateu@mail.example.com
    remotepass = "password"
    readonly = true
    ssl = true
    
    sslcacertfile = /etc/ssl/certs/ca-certificates.crt
    
    #usecompression = yes
    maxconnections = 5
    
    [Repository scateu.example-gmail]
    type = Gmail
    remoteuser = scateu.example
    remotepass = "password"
    
    nametrans = lambda folder: re.sub("^\[Gmail\]/Spam$", "spam",
    re.sub("^\[Gmail\]/Drafts$", "drafts",
    re.sub("^\[Gmail\]/Sent Mail$", "sent",
    re.sub("^\[Gmail\]/Starred$", "pin", folder))))
    
    sslcacertfile = /etc/ssl/certs/ca-certificates.crt
    maxconnections = 2


## 参考

 - <http://stevelosh.com/blog/2012/10/the-homely-mutt/>
 - <http://blog.tshirtman.fr/2013/3/17/mutt-offlineimap-notmuch-nottoomuch>
 - <https://github.com/bigeagle/dotfiles>
 - <http://benfrancom.com/2014/11/24/mutt-offline-with-mbsync/>

## Credit

感谢<https://somevpn.cn>的老板提供了VPN供我同步, 一天用掉了2G多, 搞得像用他的VPN在看毛片似的...
