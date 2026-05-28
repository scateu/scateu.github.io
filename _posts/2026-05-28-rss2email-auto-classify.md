---
title: "RSS2Email替代RSS Reader: 自动建目录"
date: 2026-05-28
layout: post
---

[上一篇文章](https://scateu.me/2025/08/08/rss2email-public-inbox-nntp.html)里我在家里的RPi4+SSD引导(完全不要SD卡)上跑了一年多，很稳定。但我为了统一已读未读标志，不再使用nntp，而是用dovecot提供的imap。

IMAP的部署手记在此:
```
pi@rpi4:/etc/dovecot $ tree 
.
├── certs
│   └── dovecot.pem
├── conf.d (空哒)
├── dovecot.conf
├── private
│   └── dovecot.key
└── users

pi@rpi4:/etc/dovecot $ cat dovecot.conf 
ssl = required
ssl_cert = </etc/dovecot/certs/dovecot.pem
ssl_key = </etc/dovecot/private/dovecot.key
#    sudo openssl genrsa -out /etc/dovecot/private/dovecot.key 4096
#    sudo openssl req -new -x509 -key /etc/dovecot/private/dovecot.key -out /etc/dovecot/certs/dovecot.pem -days 365
ssl_min_protocol = TLSv1.2
ssl_prefer_server_ciphers = yes
disable_plaintext_auth = yes
protocols = imap
service imap-login {
	inet_listener imap {
		port = 143
	}
	
	inet_listener imaps {
		port = 993
	}
}
passdb {
	driver = passwd-file
	args = scheme=SHA512-CRYPT username_format=%n /etc/dovecot/users
	#doveadm pw -s SHA512-CRYPT
}
userdb {
	driver = passwd-file
	args = username_format=%n /etc/dovecot/users
	#override_fields = uid=vmail gid=vmail home=/home/vmail/%n
}
mail_location = maildir:/home/pi/Maildir/INBOX
```

建一对公私钥，建一个密码文件。办法都在注释里。然后就good to go啦。

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
