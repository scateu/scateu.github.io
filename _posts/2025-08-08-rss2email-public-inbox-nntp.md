---
title: "再也不见了，RSS阅读器: 用rss2email, public-inbox, nntp"
date: 2025-08-08
layout: post
---

## 缘由

 - RSS一个一个地fetch太累，过于费网络资源
 - 云端RSS阅读器收费，贵
 - RSS获得的消息，需要保留一段时间，本地的阅读器读完马上mark as read/删除，给我的阅读压力很大，总担心点了阅读又没读懂，就没了
 - 不想折腾邮件服务器，包管理器总是装了好多不知道是啥的东西，即使是dovecot这样的IMAP Server

## 解决方案

    rss2email -> maildir -> public-inbox-watch -> .git目录 -> public-inbox-nntpd
                    \                                               \
                     \----> 本地mutt/alpine阅读                      \----> 分享给朋友们，使用thunderbird订阅newsgroup


## public-inbox

是Linux Foundation开发的基于perl的程序，lore.kernel.org里的邮件现在都由public-inbox来提供归档阅读

public-inbox主要的思路是用git仓库来存邮件，每个patch就是一封邮件。

同时有`public-inbox-watch`，从配置文件里监控各个渠道，如有新邮件进来，就把它写进对应的git目录。

后来有V2版本的git目录，增加了epoch分区，从而避免一个目录的邮件太太太太多。

`public-inbox-imapd` `public-inbox-nntpd` `public-inbox-pop3d` `public-inbox-httpd` 如名字所示，就是对应的imap nntp pop3 http服务器。

用git有一个好处，任何人都可以很方便的mirror上游邮件仓库的数据，还可以更新。


## rss2email

由Aaron Swartz发起。可以看看关于他的纪录片 The Internet's Own Boy。特别是片中有Tim Berners-Lee致的悼词。

它取了RSS之后，可以sendmail，可以IMAP，可以SMTP，也可以Maildir。

由于我不想把RSS跟我的主力IMAP电子邮件服务混到一起，Maildir最合适了。



## NNTP

参考我之前的文章: [NNTP/USENET:旧世界的遗产和新世界的大门](https://scateu.me/2018/01/05/nntp.html)

朱令当年的求救邮件在[sci.med](https://groups.google.com/g/sci.med.nutrition/c/PnHC-1Ipr9Q/m/q6hgcOjGcZMJ)里。底下有人上来就回复sound like Thallium。发信IP是162.105.195.2，所在地北京大学力学系。北大救清华，谢谢了。

水木清华BBS站也在USENET里有一个对应的分区。

NNTP就是Newsgroup，可以用Emacs Gnus / alpine / w3m / thunderbird等阅读。
所有人共享一份数据，已读/未读标记是在本地的，存在于`.newsrc`里，里面只标记了从哪到哪读过，很简单。(据说水木的已读/未读也是类似)


## 动手

### 1. Raspberry Pi - SSD

Maildir一封邮件就是一个文件，一定不能用SD卡了。
RPi的较新版本可以直接从SSD引导，卡都不用插。

或许需要`rpi-eeprom`啥的更新一下，就可以了。

用SD卡的话，插个SSD硬盘，在/etc/fstab里配一下。

然后在无线路由器上端口转发一哈，联通不样用80/8080，http服务可以用8888，实测NNTP的110端口不受限。

### 2. 配rss2email

    sudo apt install rss2email

`.config/rss2email.cfg` 配置:

    [DEFAULT]
    from = pi@localhost
    user-agent = rss2email/__VERSION__ (__URL__)
    use-8bit = False
    force-from = False
    use-publisher-email = False
    name-format = {feed-title}: {author}
    to = pi
    proxy = 
    feed-timeout = 60
    same-server-fetch-interval = 0
    active = True
    digest = False
    date-header = True
    date-header-order = modified, issued, created, expired
    bonus-header = 
    trust-guid = False
    trust-link = False
    reply-changes = False
    encodings = US-ASCII, ISO-8859-1, UTF-8, BIG5, ISO-2022-JP
    post-process = 
    digest-post-process = 
    html-mail = True
    multipart-html = False
    use-css = False
    css = h1 {
        font: 18pt Georgia, "Times New Roman";
        }
        body {
        font: 12pt Arial;
        }
        a:link {
        font: 12pt Arial;
        font-weight: bold;
        color: #0000cc;
        }
        blockquote {
        font-family: monospace;
        }
        .header {
        background: #e0ecff;
        border-bottom: solid 4px #c3d9ff;
        padding: 5px;
        margin-top: 0px;
        color: red;
        }
        .header a {
        font-size: 20px;
        text-decoration: none;
        }
        .footer {
        background: #c3d9ff;
        border-top: solid 4px #c3d9ff;
        padding: 5px;
        margin-bottom: 0px;
        }
        border: solid 4px #c3d9ff;
        }
        margin-left: 5px;
        margin-right: 5px;
        }
    unicode-snob = False
    links-after-each-paragraph = False
    inline-links = True
    wrap-links = True
    body-width = 0
    email-protocol = maildir
    sendmail = /usr/sbin/sendmail
    sendmail_config = 
    maildir-path = ~/Maildir
    maildir-mailbox = INBOX
    verbose = info

    [feed.scateu]
    url = http://scateu.me/feed.xml




对应的systemd配置:

    pi@rpi4:~ $ cat /etc/systemd/system/rss2email.service 
    [Unit]
    Description=Fetches RSS feeds and send them to email
    Wants=rss2email.timer

    [Service]
    ExecStart=/usr/bin/proxychains4 /usr/bin/r2e run
    Environment = PATH=/usr/local/bin:/usr/bin:/bin
    User = pi

    [Install]
    WantedBy=multi-user.target

    pi@rpi4:~ $ cat /etc/systemd/system/rss2email.timer
    [Unit]
    Description=calling rss2email peridically
    Requires=rss2email.service

    [Timer]
    Unit=rss2email.service
    OnCalendar=*-*-* 00/8:00:00

    [Install]
    WantedBy=timers.target

然后

```
sudo systemctl enable rss2email.timer
sudo systemctl enable rss2email.service
```

proxychains4是用来保持与国际互联网的通信用的。
本机可以起一个socks5信道。



### 3. public-inbox

    sudo apt install public-inbox
    public-inbox-init  -V2 RSS /home/pi/RSS  http://192.168.1.31/RSS pi@localhost

在配置里指定好上游maildir目录，在watch字段:

    pi@rpi4:~/.public-inbox $ cat config
    [publicinbox "RSS"]
            address = pi@localhost
            url = http://192.168.1.31/RSS
            inboxdir = /home/pi/RSS
            newsgroup = RSS
            watch = maildir:/home/pi/Maildir/INBOX/
            address = pi@localhost

然后执行

    public-inbox-watch

就会从maildir里把邮件塞进public-inbox的git目录(在这里是`RSS/`)了，可惜这个程序没啥输出

可以进到目录里敲`git status`来看，或者用`tig`。但一定要进到对应的目录里先。

比如:

    cd RSS/git/0.git
    git log
    tig

示例输出:

    commit 509a34ca40cb884846bdb740c31dba79b1150fd6 (HEAD -> master)
    Author: New Projects : Kickstarter: author <pi@localhost>
    Date:   Wed Aug 6 13:26:57 2025 +0000

        Dream Fighters Children's Book: A–Z of Black STEM Pioneers by Shemeka Foster

    commit 3c0e1bb5eae2915a5574dfc937c2e1379ae28c2a
    Author: Newsshooter: Matthew Allard ACS <pi@localhost>
    Date:   Fri Aug 8 00:27:20 2025 +0000

        LumaTouch 5.3 for iOS enables support for 3rd party editing and VFX plugins

    commit 2187aea6c05ec5387b822fec93adef63a0da8e6c
    Author: New Projects : Kickstarter: author <pi@localhost>
    Date:   Fri Aug 8 06:45:13 2025 +0000

        The Stories of Tanith Lee by John Betancourt

    commit a825201c2387c8b53449b4ea0bc1b593caeb776c
    Author: Newsshooter: Matthew Allard ACS <pi@localhost>
    Date:   Fri Aug 8 00:44:34 2025 +0000

        Ikan Aura PT419W-NDI– world’s first teleprompter that combines full NDI streaming with PoE++ power delivery



systemd的配置文件们:

    pi@rpi4:~ $ cat /etc/systemd/system/public-inbox-nntpd.service 
    [Unit]
    Description=public-inbox-nntpd
    After=network.target

    [Service]
    Type=simple
    Environment = PI_CONFIG=/home/pi/.public-inbox/config \
    PATH=/usr/local/bin:/usr/bin:/bin
    ExecStart = /usr/bin/public-inbox-nntpd
    Restart=always
    User=root
    Group=root

    [Install]
    WantedBy=multi-user.target

    pi@rpi4:~ $ cat /etc/systemd/system/public-inbox-watch.service 
    [Unit]
    Description = public-inbox Maildir watch
    After = spamassassin.service

    [Service]
    Environment = PI_CONFIG=/home/pi/.public-inbox/config \
    PATH=/usr/local/bin:/usr/bin:/bin
    ExecStart = /usr/bin/public-inbox-watch

    ExecReload = /bin/kill -HUP $MAINPID
    # this user must have read access to Maildirs it watches
    User = pi
    KillMode = process

    [Install]
    WantedBy = multi-user.target

然后

    sudo systemctl enable public-inbox-watch.service
    sudo systemctl enable public-inbox-nntpd.service
    sudo systemctl start public-inbox-watch.service
    sudo systemctl start public-inbox-nntpd.service

如果想提供imap服务，同理

## 使用

    w3m nntp://pi.example.net/RSS
    alpine -url nntp://pi.example.net/RSS
    w3m nntp://news.public-inbox.org/inbox.comp.mail.public-inbox.meta
    alpine -url nntp://news.public-inbox.org/inbox.comp.mail.public-inbox.meta

Thunderbird里添加Newsgroup账号先，服务器就是你的公网IP对应的域名，然后Subscribe里面的RSS频道。


## tip: RSS去重 - r2e-dedup.sh
```bash
#!/bin/bash
# simple bash script to remove duplicated RSS items from rss2email

r2e list > r2e-list.txt
cat r2e-list.txt |cut -d'(' -f2 |awk '{print $1'} |sort |uniq -c | grep '2 http' > a
while read line; do cat r2e-list.txt |grep `echo $line |cut -d/ -f3` | tail -n1; done < a > b
cat b |cut -d: -f1|sort |uniq | xargs r2e delete
rm -i a b r2e-list.txt
```
