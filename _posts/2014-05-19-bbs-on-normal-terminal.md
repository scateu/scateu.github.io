---
layout: post
title: 在UTF8的终端里逛水木
date: 2014/05/19 00:23:00
---

# 在UTF8的终端里逛水木

	luit -encoding gbk ssh <id>@newsmth.net  #newsmth最近已经支持了ssh v2了, 不需要再加`-1`参数

## 防发呆

```bash
$ cat ~/.ssh/config 
Host *
    TCPKeepAlive yes
    ServerAliveInterval 15
    ServerAliveCountMax 3
```
[来源链接](https://blog.huiyiqun.me/2016/10/21/openssh-freeze-inactive-session.html)

(貌似效果没有那么显著, 但也有一部分改善. )

## Fix 1

有时候 luit 1.1.1 版本会报 `Segmentation fault (core dumped)`

根据[这篇文章](http://lenguyenthedat.com/luit-segmentation-fault/):

    $ wget http://invisible-island.net/datafiles/release/luit.tar.gz
    $ tar -xvf luit.tar.gz
    $ cd luit-*; ./configure; make; sudo make install

装一个新版本的luit就好了. 

## Fix 2

~~新版本的ssh已经不支持ssh1了. ~~ [2016-11-04: KCN已经更新了水木, 增加了SSH2支持](http://www.newsmth.net/nForum/article/BBSMan_Dev/85355?s=85355)

但是有一个legacy的包还支持. 

    $ sudo apt-get install openssh-client-ssh1

    $ luit -encoding gbk ssh1 -1 <id>@newsmth.net

## Fix 3: gnome-terminal 字符宽度问题

在 `Profile -> Compatibility -> Ambiguous-width characters:` 选成 `Wide`

否则 ASCII 字符对不齐. 

## 自动输入密码

    $ sudo apt-get install sshpass
    $ alias newsmth="luit -encoding gbk sshpass -p <yourpassword> ssh1 -1 <id>@newsmth.net"

### 用gpg加密一下

```bash
echo <yourpassword> | gpg -c > ~/.newsmthpassword && chmod 600 ~/.newsmthpassword

# 在~/.bashrc里加入下面一行
alias newsmth="eval \"luit -encoding gbk sshpass -p \$(cat ~/.newsmthpassword | gpg) ssh scateu@bbs.newsmth.net\""
```

### 或者用 openssl 来加密

```bash
echo <yourpassword> | openssl aes-128-cbc -e -a
# 在~/.bashrc里加入下面一行
alias newsmth="eval env SSHPASS=\$(echo <那一串hash> | openssl aes-128-cbc -d -a) luit -encoding gbk sshpass -e ssh scateu@newsmth.net"  
```

之所以用`eval`, 是为了避免一开bash就执行那个解密操作. 

不建议`sshpass`用`-p`参数, 因为可以在`top`或`ps`里看到明文密码. 用`env`可以把`$SSHPASS`限制在这一行命令中而不泄漏. 

## w3m 看带图的十大

在fbterm的下面，用w3m也不错，只看十大的话。
还能看图:

```bash
sudo apt install w3m-img jfbterm

alias w3m='TERM=jfbterm w3m' #否则在fbterm里不显示中文
#如果没有jfbterm这个包的话，可以去找个jfbterm的termcap文件，放到~/.terminfo/j/jfbterm里

alias newsmth-shida="w3m -N m.newsmth.net m.newsmth.net/hot/{1..9}"
```

`{` `}` 切换标签页, `C-q`关标签页，`C-t`打开链接到新标签页。

## See Also

 - <http://www.newsmth.net/nForum/article/BBSMan_Dev/85311?s=85343>
