---
title: "新时代对全Terminal办公的新要求"
date: 2018-01-28
layout: post
---

<script src="https://asciinema.org/a/wfdo7K8RyNxIys4kvh5ouPVj5.js" id="asciicast-wfdo7K8RyNxIys4kvh5ouPVj5" async></script>

*(无图言锤)*

## 引言

计算机的性能提升，并没有带来人的生产力的相应提升。反而被<del>互联网思维的产品经理们</del>用来造出了一个又一个时间黑洞，把人的创造力吞噬。

> Andy gives, Bill takes away.  -- 安迪-比尔定理 Andy and Bill's Law 
> (Andy是Intel当时的CEO, Bill姓门)

我认为现在的状况是: 

> CPU gives, FLAG takes away.
> CPU gives, BAT takes away.
> GPU gives, WangZheRongYao takes away.
> GPU gives, bitcoin takes away.

在互联网时代，人的记忆只有8秒，比金鱼还少1秒。

> According to a much-referenced study, we humans are worse at 
> concentrating than a goldfish. Humans today lose their concentration after 
> eight seconds. In the year 2000 it was 12 seconds, while the goldfish, 
> rather far beneath us on the food chain, averaged nine. - [HN: Life in the age of noise](https://news.ycombinator.com/item?id=16154841)

不用Todo list根本活不了。 特别是在电脑前。

最近发现两个事实:

1. 把手机调成黑白模式，的确使人安静了不少。有种把互联网产品经理关在了制度的笼子里的意思。
2. 我已经忘了... (果然7秒) 啊想起来了，用电子墨水屏当VT100终端，在上面用JuiceSSH连服务器收邮件看NNTP，似乎使我最近能安定下来看文章。
3. w3m是个好浏览器。 (喂不会数数)

说回来，我[从Omnifocus到Todo.txt再到Taskpaper再到A4纸打印、打孔，最后又回到Omnifocus](http://scateu.me/2017/01/11/todo-txt.html)，又一个轮回，Omnifocus收件箱爆掉，生产力再度破产之际........  当然是再研究出来一种Todo list啦!

## GTD over IMAP

要求:

1. 跨平台: Windows/Linux/macOS, iOS/Android都能用
2. 协议开放: Future Proof
3. 简单
4. 最好不要钱


结论:

一种基于IMAP的待办事项列表。

体验非常好。当你能处理几千封邮件的时候，回头看已经堆了上千条的待办事项，似乎不是特别大的事情。

### 如何写

#### 手机

 - 建一个新身份 `todo@example.com` 写草稿
 - 或者干脆给自己发邮件好了


#### Alpine:

用草稿:
 - 按`#`以新的Role写信，发信人设置为`todo@example.com`
 - 设置一个Rule: Drafts目录里, 来自`todo@example.com`的，移动到`TODO`目录

或者设置一个Role:
 - 按`#`以新的Role写信，发信人设置为`todo@example.com`
 - FCC到`TODO`目录
 - 好处是不至于在邮件里找到两封一模一样的


或者你干脆再申请一个单独的邮箱好了。

### 好处

 - 天生跨平台同步，替代了Dropbox/iCloud Drive
 - 有旗标

### 我当前的工作流

 - 收集
   - 以todo@example.com的身份写一封无收件人的邮件，FCC到TODO目录。(通过Alpine的Role和Rule实现)
   - 写个草稿。发信人是 todo@example.com
   - 给i+todo@example.com写邮件
 - Review: 手动分发到各`@context`目录 或 `+project` 目录
 - 每周Review

<details markdown="1"><summary> 我当前的IMAP目录结构 </summary>

```
INBOX                      # IMAP的INBOX
	Archive
	Lists
	TODO               # GTD的INBOX，初步收集。同时具备@next的功能
		@DONE
		@buy
		@home
		@idea
		@kindle
		@movie
		@office
		@someday
		@try
		@tsinghua
		@waiting
		@youtube
		Archive
```
</details>

我写了一个[脚本](https://gist.github.com/scateu/a0a3a724b67b1f72dacd907ee3a09bbb)用以导入之前的Todo.txt或Taskpaper。

### Future Work

 - Alpine似乎支持外部过滤器， 实现一个`t:` `due:`的解析器，从而能够更GTD的拖延。
 - 把IMAP当成文档管理系统?

#### 如何改?

目前还没想好，直觉上两种方法:

 - 不改了，有更新就通过同主题回复的方式
 - IMAP `/Draft` 使之可编辑

#### 如何Review?

需要写个脚本，每周把所有事项重新标为未读

### See Also

 - [tickle-me-email](https://github.com/lamby/tickle-me-email)


## tmux里办公

当上**网**越来越**难**的时候，不如换一种思路，全在主机上远程工作。

### 穿梭

穿梭是一种BBS时代的说法。那时候大家为了从校外穿梭到校内BBS，或者为了隐藏IP，会使用一些穿梭BBS站。例如李卓桓的zixia.net。

现在也可以!

```bash
ssh -tA user@ServerA.example.com ssh -t user@ServerB.example.com tmux attach
```
 - `t` 是

如果网络条件不好，经常掉线的话，比如在高铁上，或者在飞机上用卫星，推荐使用<https://mosh.mit.edu>

### 聊天: weechat

Pro Tip:
 - <https://github.com/tuna/scripts>
 - 类似于UCDOS的[五笔输入法](http://scateu.me/2016/03/11/vim-im.html)

### 看RSS

由于我在macOS上买了Reeder，在iOS上买了Reeder for iOS，同时又想在[Chromebook](http://scateu.me/2016/10/09/chromebook-rocks.html)里偶尔看新闻(Web或Android都可以)，还想重回BBS时代的荣耀使用newsboat(是newsbeuter的活跃开发分支)。

找了一圈，省事的办法是买Inoreader。newsboat已经支持了Inoreader。但试了两天，发现 a) Inoreader 免费版内嵌广告  b) newsboat因为同步的原因略卡

最终的解决方案是tinytinyrss。

 - 安装方案可以参考[这个](https://sspai.com/post/41302)
    - 不想用Docker的话，可以参考[Digital Ocean的教程](https://digitalocean.com/community/tutorials/how-to-install-ttrss-with-nginx-for-debian-7-on-a-vps)
    - 后台更新建议用systemd跑`update_daemon2.php`，是多进程的，效率高不少
 - 如果有需要可以[配置proxy](https://binfalse.de/2015/05/06/ttrss-with-proxy/)
 - 安装[Feedly风格的主题](https://github.com/levito/tt-rss-feedly-theme)以使你的心情愉悦(赚到了)
 - 打开API接口以使newsboat可以访问
 - 安装[Fever API插件](https://github.com/DigitalDJ/tinytinyrss-fever-plugin)以使Reeder可以访问
    - Fever API似乎只能看，不改subscribe/unsubscribe
 - [配置Let's Encrypt证书](https://certbot.eff.org)
 - 安装[Mercury Reader插件](https://github.com/WangQiru/mercury_fulltext)，记得去设置一下API Key才能用。
    - 在单独的订阅设置的`Plugins`选项卡，勾上，即可把不带全局RSS输出的转换好

Pro Tips:
 - `Ctrl-/` 快捷键帮助
 - `g P` 进入设置
 - `f e` 编辑当前订阅
 - 在单独的订阅设置里可以勾上`Cache Media`以把所有图片下载回来


#### newsboat 

如果想让newsboat用起来更像BBS的话:

```bash
useradd -m blahblah -s /usr/bin/newsboat
```

密码可以用

```
echo <yourpassword> | openssl aes-128-cbc -e -a
```

生成，放到`.newsboat/config`里:

```
ttrss-passwordeval "echo '那一串base64'| openssl aes-128-cbc -d -a"
```

<details markdown="1"><summary> 我目前的配置 </summary>

```
bind-key k up
bind-key j down
bind-key L toggle-show-read-feeds
bind-key - pageup
unbind-key SPACE
bind-key SPACE pagedown

unbind-key l 
bind-key l open
bind-key RIGHT open

bind-key , quit
bind-key h quit
bind-key LEFT quit

bind-key J next-feed 
bind-key K prev-feed

download-retries 5
download-timeout 90
auto-reload yes
reload-time 90
reload-threads 15

always-display-description yes

keep-articles-days 500

refresh-on-startup yes

confirm-exit yes
show-read-feeds no
show-read-articles yes

highlight article "^Feed: .*$" color3 default
highlight article "^Title: .*$" color13 default bold
highlight article "^Author: .*$" color5 default
highlight article "^Link: .*$" color6 default
highlight article "^Date: .*$" color4 default

urls-source "ttrss"

ttrss-login "example"
ttrss-url "https://example.com/ttrss/"
ttrss-passwordeval "echo 'example' | openssl aes-128-cbc -d -a"
```

</details>

### w3m

好处:

1. 聚精会神
2. 省内存
3. 开在tmux里，实现Read It <del>Never</del> Later (自带阅读位置记录及同步哦，是吧Kindle同学)
4. 多标签页支持也不错
5. 开在远程的机器上省得配置科学上网手段了
6. 自带[Handoff特性](https://support.apple.com/en-us/HT204681)
7. 甚至可以看图: (keyword: `w3mimgdisplay`) [参考](http://scateu.me/2014/03/01/ranger-init-configure.html)
8. 可以[查单词](http://scateu.me/2014/11/04/youdao-dict-in-bash.html)


Pro tips for w3m:

 - `H` Help
 - `B` Back
 - `c` 当前URL
 - `U` Goto URL
 - `T` 克隆一份当前页面到新Tab
 - `Ctrl-t` 在新Tab里打开光标下面的URL
 - `{` `}` 切换Tab
 - `Ctrl-q` 关闭Tab
 - `Alt-W` 查光标下面的单词 需要[装RFC2229 dict](http://scateu.me/2014/11/04/youdao-dict-in-bash.html)
 - `w3m -N a.com b.com c.com` 同时开启多标签页，类似于`vim -p fileA fileB fileC`


