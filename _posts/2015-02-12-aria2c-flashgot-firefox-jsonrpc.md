---
layout: post
title:  "使用 Aria2 实现离线下载"
date: 2015-02-12 16:38:00
---


百度云盘虽然好, 但是保不齐哪天东西就被删除了. 所以打算搭一个自己的离线下载工具

虽然有Windows电脑可以一直开着, 用百度云客户端来实现推送. 但是如果想在Raspberry Pi或OpenWRT等小设备上跑的话, 还是需要用Linux. 


## 1 Aria2 安装

在Linux下可以装aria2跑成daemon方式, 监听jsonrpc

{% highlight bash %}
sudo apt-get install aria2
aria2c --enable-rpc --rpc-listen-all --rpc-allow-origin-all --dir ./storage -D
{% endhighlight %}

顺便提一句, aria2也是可以独立运行的, 特别值得使用`-i`参数, 可以从一个URL列表里批量下载. 


### 1.1 安装 webui-aria2

由于默认的aria2是不带GUI的, 所以需要一个WEB UI. 

{% highlight bash %}
git clone https://github.com/ziahamza/webui-aria2
python -m SimpleHTTPServer 7777 #也可以使用Apache
{% endhighlight %}

然后访问这台机器的7777端口就可以了, 注意需要设置一下aria2的地址. 

如果需要临时使用的话, 可以直接访问<http://ziahamza.github.io/webui-aria2/>, 配置数据是存在本地浏览器的, 不需要注册. 

#### 1.1.1 或者 YAAW  (不推荐,但有Chrome插件)

{% highlight bash %}
git clone https://github.com/binux/yaaw
python -m SimpleHTTPServer 7777 #也可以使用Apache
{% endhighlight %}

另外, 可以使用<http://aria2c.com/>, 反正数据是存在浏览器上的, 可以应急用一用. 


### 1.2 OpenWrt 上挂载 NAS 提供服务

参考<http://wiki.openwrt.org/doc/howto/cifs.client>

{% highlight bash %}
opkg install kmod-fs-cifs kmod-nls-utf8 kmod-nls-base kmod-crypto-hmac kmod-crypto-md5 kmod-crypto-misc cifsmount
{% endhighlight %}

然后可以这样挂载Samba

{% highlight bash %}
mount -t cifs //cifs-server/share /localfolder -o user=username,password=password

mount -t cifs '\\cifs-server\share' /localfolder -o guest,iocharset=utf8,file_mode=0777,dir_mode=0777,nounix,noserverino

mount -t cifs '\\cifs-server\share' /localfolder -o user=username,password=password,iocharset=utf8,file_mode=0777,dir_mode=0777,nounix,noserverino

{% endhighlight %}

### 1.3 jsonrpc 密码验证

使用 `--rpc-secret=xxxxxx` 

 - URL: `http://token:xxxxxx@host:port/jsonrpc`

使用 `--rpc-user=user --rpc-passwd=pwd` 

 - URL: `http://user:pwd@host:port/jsonrpc`

v1.18.4新增了 `--rpc-secret` ,设置的RPC授权令牌,  取代 `--rpc-user` 和 `--rpc-passwd` 选项

### 1.4 在OpenWrt上部署示例 

{% highlight bash %}
mkdir /etc/aria2/
touch /etc/aria2/aria2.session
{% endhighlight %}
    
把以下内容添加到`/etc/rc.local`的`exit 0`之前:

{% highlight bash %}
aria2c --enable-rpc \
--rpc-listen-all \
--rpc-allow-origin-all \
--dir /mnt/ \
--continue=true \
--disable-ipv6=true \
--input-file=/etc/aria2/aria2.session \
--save-session=/etc/aria2/aria2.session \
--save-session-interval=60 \
--rpc-listen-port=6800 \
--rpc-secret=<your_secret_here> \
--max-tries=0 \  #用于处理如百度云盘不时挂掉的情况
--max-concurrent-downloads=3 \
-D
{% endhighlight %}

然后jsonrpc的URL即是`http://token:<your_secret_here>@host:6800/jsonrpc`


## 2 Firefox/Chrome+百度云配置


 - 原作者: <http://www.v2ex.com/t/121976>
 - GitHub: <https://github.com/acgotaku/BaiduExporter>
 - [Chrome App Store](https://chrome.google.com/webstore/detail/baiduexporter/mjaenbjdjmgolhoafkohbhhbaiedbkno)
 - [Firefox插件](https://raw.githubusercontent.com/acgotaku/BaiduExporter/master/firefox/baidu-exporter.xpi)


## 3 Firefox 配置

安装Flashgot.


在Flashgot里新建一个Download Manager, 比如叫aria2rpc, 调用自己写的aria2rpc程序(代码见下面), 然后URL模板如下:

    [--cookie COOKIE] [--output FNAME] --rpc http://<URL_TO_aria2_Server>:6800/jsonrpc [URL]

当然, 如果本地电脑上可以装aria2的话, 貌似Flashgot是直接支持的, 内嵌有模板. 


配置好之后, 在需要下载的链接上右键, 使用FlashGot下载即可. 快捷键是`Alt+Click`. 
 
### 3.1 aria2rpc

以下代码的出处见[此页面](http://appwen.com/read.php?tid=3393), 以下搬运Python和Bash版本, 原文中还提供Go版本. 

#### 3.1.1 Python版 

{% highlight python %}

#!/usr/bin/env python2
   
import json, urllib2, sys
from argparse import ArgumentParser
   
parser = ArgumentParser()
parser.add_argument('-c', '--cookie', help='use cookies', type=str,
                    default='', metavar='COOKIES', dest='cookies')
parser.add_argument('-o', '--output', help='output name', type=str,
                    default='', metavar='NAME', dest='output')
parser.add_argument('-d', '--dir', help='dest dir', type=str,
                    default='', metavar='DIR', dest='dir')
parser.add_argument('-r', '--rpc', help='aria2 rpc (http://localhost:6800/jsonroc)',
                    type=str, default='http://127.0.0.1:6800/jsonrpc',
                    metavar='URL', dest='rpc')
parser.add_argument('URIs', nargs='+', help='URIs', type=str,
                    default='', metavar='URI')
opts = parser.parse_args()
   
jsondict = {'jsonrpc':'2.0', 'id':'qwer',
        'method':'aria2.addUri','params':[opts.URIs]}
   
aria2optsDefault={
        'continue'                  :'true',
        'max-connection-per-server' :'15',
        'split'                     :'15',
        'min-split-size'            :'10M'}
   
aria2opts = {}
aria2opts.update(aria2optsDefault)
   
if opts.output:
    aria2opts['out'] = opts.output
if opts.dir:
    aria2opts['dir'] = opts.dir
if opts.cookies:
    aria2opts['header'] = ['Cookie: {0}'.format(opts.cookies)]
   
jsondict['params'].append(aria2opts)
   
jsonreq = json.dumps(jsondict)
print jsonreq
urllib2.urlopen(opts.rpc, jsonreq)

{% endhighlight %}

#### 3.1.2 Bash版 

{% highlight bash %}

#!/bin/bash
usage='Usage: aria2rpc.sh [-c COOKIE] [-d DIR] [-o NAME] URL [URL..]'
  
while [[ -n "$1" ]];do
  case "$1" in
    -c|--cookie) shift; cookie="$1" ;;
    -d|--dir) shift; dir="$1" ;;
    -o|--out) shift; output="$1" ;;
    -r|--rpc) shift; rpc="$1" ;;
    -h|--help) echo "$usage"; exit ;;
    *) uris[$((i++))]="$1" ;;
  esac
  shift
done
  
if ((${#uris[@]}==0));then
  echo "$usage"
  exit
fi
URIs=$(IFS=, ;echo "${uris[*]}"|sed 's/,/","/g;s/^/"/;s/$/"/')
  
if [[ -z "$rpc" ]];then
  rpc='http://127.0.0.1:6800/jsonrpc'
fi
  
Options="{"
if [[ -n "$cookie" ]];then
  Options="$Options"'"header":["Cookie: '"$cookie"'"],'
fi
if [[ -n "$dir" ]];then
  Options="$Options"'"dir":"'"$dir"'",'
fi
if [[ -n "$output" ]];then
  Options="$Options"'"out":"'"$output"'",'
fi
Options="${Options%,}"
Options="$Options""}"
  
jsonTemplate='{"jsonrpc":"2.0","id":"qwer","method":"aria2.addUri","params":[['"$URIs"'],'"$Options"']}'
  
curl -X POST -d "$jsonTemplate" --header "Content-Type:application/json" "$rpc"

{% endhighlight %}


## 4 参考

 - <http://appwen.com/read.php?tid=3393>
 - <https://github.com/binux/yaaw>
 - [一篇博客](http://pagebrin.com/2014/04/raspberry-pi%E6%8A%80%E6%9C%AF%E7%AC%94%E8%AE%B0%E4%B9%8B%E5%9B%9B%EF%BC%9A%E4%BD%BF%E7%94%A8aria2%E6%89%93%E9%80%A0%E4%B8%8B%E8%BD%BD%E5%88%A9%E5%99%A8/)
 - [UserScript导入百度云链接至Aria2](http://www.whjxp.com/?p=920)
 - [SyncY:实时同步百度云](http://syncyhome.duapp.com/)
 - <http://aria2c.com/usage.html>

### 4.1 推荐的电影站

 - <http://zydh123.net/>
 - <http://6vhao.com/>
 - <https://eztv.ch/>
 - <http://bt.shousibaocai.com/>
 - <http://www.ttmeiju.com/>


## TODO

 - FlashGot不依赖脚本, 直接工作
 - OpenWrt 同步 Dropbox
