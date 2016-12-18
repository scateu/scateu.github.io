---
layout: post
title:  "将国内邮箱优雅地迁移到Gmail"
date: 2015-03-20 13:29:00
---

国内邮箱在此以腾讯邮箱为例. 

## Gmail的POP3收信导入

有时候会被盾, 另外 QQ 邮箱的IMAP会偷偷改回只同步30天以内的邮件. 

而且 POP3 只能收取原邮箱里的`收件箱`里的邮件, 如果想把`已发邮件`也拖回来的话, 可以去原邮箱 

另外, 过大的附件, Gmail 貌似会自动扔掉, 然后丢给你一个提示邮件说东西太大了老子不给你拖这封信云云. 

> The message "Some Example Message" from Example (example@example.com)) was too big to fetch from your account me@example.com. It has been left on the server.
> Message-ID:
> If you wish to write to Example, just hit reply and send Example a message.
> Thanks,
> The Gmail Team




## 使用 Foxmail 等邮件客户端

由于 IMAP 协议是支持上传邮件的, 我们可以把原邮箱的信都下载到本地, 然后再导入 Gmail 邮箱对应的文件夹, 然后同步(收取)一下就好了. 

国内的邮箱的话, 推荐直接用 Foxmail 糙快猛就搞定. 

同步的时候, 一定要先在Foxmail里面把原来的邮箱下线, 否则容易不小心删除邮件. 


最好是用邮件导出功能, 而不是直接在Foxmail里面进行拖动. 因为这样有可能造成原邮箱邮件被删除(尽管现在的国内邮箱提供防删功能, 但只针对POP. 如果是IMAP删除了, 虽然在邮箱里还能看到邮件, 但是IMAP里面就被清空了)

由于POP3只收取`收件箱`里面的邮件, 所以万一你像我一样手欠通过IMAP把邮件都清空了, 而又想把所有的`已发邮件`都备份下来的话, 可以用POP3, 然后在网页邮箱里面, 把`已发邮件`整个移动到`收件箱`里面. 

貌似遇到上述情况之后, 耐心等一阵, IMAP 里的邮件就又会回来. 怀疑是腾讯邮件的 IMAP 防删队列需要比较长的时间来处理. 

哦对, 有人会说你费那劲干啥, 直接再注册一个QQ邮箱, 傻大傻大的, 速度还快. 嗯我的确是注册了一个, 但尼玛发现新注册的邮箱是不能够开启 IMAP 和 POP3 的, 要等个半个月才行. 


