---
title: "AppleTV 折腾记"
date: 2017-05-18
layout: post
---

## 体验

非常高贵。可以从[闲鱼](https://www.baidu.com/s?wd=%E9%97%B2%E9%B1%BC%E6%98%AF%E5%82%BB%E9%80%BC)入一个300多，Apple TV 3。最不济，它是一个异常稳定的macbook / iPhone 的原生投屏器。我认为 Apple TV 3的价值在二手市场上被严重低估，建议各位投资者把握投资时机，及早建仓。

另外，据[惠老师](https://blog.huiyiqun.me)说，[乐播投屏](http://www.hpplay.com.cn/)异常靠谱，把Apple的投屏协议逆的非常好，从SDK上看，小米盒子似乎也用了他们的技术。

> NSBlink: Apple TV是点对点投屏，怪不得比乐播流畅，电脑只要开了WiFi和蓝牙，不需要在一个网络里。

## 材料 

- Apple TV 3
- Raspberry Pi
- macOS  (用于更新Apple TV)



## 代理配置

AppleTV的UI里没有办法直接配置代理，macOS 上装 Apple Configurator 2: Proxy 

插入USB连电脑，先升级至最新版本的tvOS。然后新建一个Config，配置好全局http代理。拖进去。

由于Apple TV只支持HTTP代理(或PAC)，于是找一台Raspberry Pi，装上polipo，上联Shadowsocks。



```bash
pi@raspberrypi:~ $ cat /etc/polipo/config 
# This file only needs to list configuration variables that deviate
# from the default values.  See /usr/share/doc/polipo/examples/config.sample
# and "polipo -v" for variables you can tweak and further information.

logSyslog = true
logFile = /var/log/polipo/polipo.log
proxyAddress = "0.0.0.0"                
proxyPort = 5678
socksParentProxy = "127.0.0.1:1080" 
socksProxyType = socks5
```

```bash
$ cat /etc/rc.local
/usr/local/bin/sslocal -c /home/pi/ss/current.json -d start
```

## One more thing: Homebridge

```bash
pi@raspberrypi:/etc/systemd/system $ cat homebridge.service 
[Unit]
Description=Node.js HomeKit Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=pi
#EnvironmentFile=/etc/default/homebridge
# Adapt this to your specific setup (could be /usr/bin/homebridge)
# See comments below for more information
ExecStart=/usr/local/bin/homebridge -U /home/pi/.homebridge
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target

$ sudo systemctl daemon-reload
$ sudo systemctl enable homebridge
$ sudo systemctl start homebridge
```

[参考](https://github.com/nfarina/homebridge/wiki/Running-HomeBridge-on-a-Raspberry-Pi)



