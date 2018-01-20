---
title: "Yubikey OpenPGP Card 略高级折腾手记"
date: 2018-01-20
layout: post
---

由于Yubikey 4部分版本里使用了Infineon生产的Secure Element，有[安全漏洞](https://www.yubico.com/support/security-advisories/ysa-2017-01/)。漏洞细节见[ROCA: Vulnerable RSA generation (CVE-2017-15361)](https://crocs.fi.muni.cz/public/papers/rsa_ccs17)。

于是在一个冬日的早晨，我折腾了一下手里的有问题的Yubikey。

(在我试图把Yubikey 4卡里生成的4096 RSA SSH Key导入到Github的时候，Github提示`Weak SSH Key`，赞一个。)


## 1 GPG Card 作为 SSH 登陆

```bash
gpg-agent --daemon --enable-ssh-support
```
然后把输出的结果(一些环境变量)放到`.bashrc`里。 或者手动source一下。

### 1.1 导出SSH公钥

```bash
ssh-add -L
#或者
gpg2 --export-ssh-key 
```

输出的key就是public key，可以放到远程服务器的`authorized_keys`里面

或者添加到github里。

或者添加到水木里。


### 1.2 跳板

```bash
ssh -A alpha.example.com
```

然后在alpha服务器上:

```bash
ssh bravo.example.com
```

就可以调用本地的yubikey了。

(这本来是ssh-agent的典型用法，用ssh-add把本地私钥加载到内存里。)


## 2 在一台新的机器上怎么使用Yubikey的OpenPGP Card

(假设你已经基本知道怎么用Yubikey的OpenPGP Card功能了)

```
gpg --recv-keys <yourid>
或 card-edit fetch

gpg --card-status
```
结束

`card-status`之后，会在本地机器上留下一个secret key的stub。


## 3 生成一个新的subkey，并迁移到卡里

```bash
gpg2 --expert --edit-key <yourid>
gpg> addkey
gpg> toggle
gpg> key 4 #选中新加的key
gpg> keytocard
```

更详细的见: <https://gist.github.com/ageis/5b095b50b9ae6b0aa9bf>


## 4 Key Signing 的原理解析

```bash
gpg --export <yourkey> > a.gpg
gpgsplit a.gpg
```

会看到有好多小文件，其中就有别人给你签过的签名。


### 4.1 如何un-revoke一个key?

<https://lists.gnupg.org/pipermail/gnupg-users/2007-April/030726.html>

结论就是如果还没有Publish，只要拆开，删掉revoke certificate再组合起来就行。
