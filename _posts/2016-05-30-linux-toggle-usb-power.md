---
layout: post
title:  "Linux里控制USB口的供电"
date: 2016-05-30
---

偶然间获得一个USB LED灯. 正好家里有OpenWrt的路由器. 插上去可以亮. 于是想看看能不能通过shell来控制它的亮灭. 

居然还真[行](https://wiki.openwrt.org/doc/howto/usb.overview). 

以我的TP-Link WR720N为例:

    echo 1 > /sys/class/gpio/gpio8/value #亮
    echo 0 > /sys/class/gpio/gpio8/value #灭


以后说不定可以在`make`或其它什么比较耗时的命令结束之后, blink一下灯. 或者把消息用Morse Code闪出来. 感觉会很好玩的样子. 

看来要买一批这样的小灯啦. 

![]({{ site.imageurl }}/Linux-LED-01.jpg)

## HTTP 访问

把以下几行放到`/www/cgi-bin/led`:

```bash
#!/bin/sh

echo "Content-type: text/html"
echo ""

if [ $(cat /sys/class/gpio/gpio8/value) -eq 0 ]
then
echo 1 > /sys/class/gpio/gpio8/value
echo "<html> <body bgcolor="white">  <div style="text-align:center"><font color="black"><h2>Light is </h2><h1>ON</h1> </font> </div> </body> </html>"                        
else
echo 0 > /sys/class/gpio/gpio8/value
echo "<html> <body bgcolor="black">  <div style="text-align:center"><font color="white"><h2>Light is </h2><h1>OFF</h1> </font> </div> </body> </html>"
fi
```

这样, 你就可以通过`http://example.com/cgi-bin/led`来控制灯了. 

还可以很方便的用bash来控:

```bash
alias blink='for i in 1 2 3 4;do curl -s -o /dev/null http://192.168.11.1/cgi-bin/led;sleep 0.3;done'
alias led='curl -s -o /dev/null http://192.168.11.1/cgi-bin/led'
```

这样, 就可以优雅地:

```bash
wget http://example.com/somemovie.mp4 && blink
make -j12 && blink
```

最棒的是, 你可以装一个我厂的[阿里钱盾](http://qd.alibaba.com), 使用钱盾快启功能, 加一个自定义URL到iOS的全局下拉框中. 非常方便. 
(以前用京东的WIFI插座, 拖了一个充电头, 再拖了一个USB LED小灯, 作为夜灯. 要打开手机, 解锁, 打开APP, 等广告, 找到开关, 点. 特别费劲, 而且还费电.  )

![]({{ site.imageurl }}/Linux-LED-02.jpg)


## 与Siri HomeKit集成

<iframe width="560" height="315" src="https://www.youtube.com/embed/lR6hN6Lh_Is" frameborder="0" allowfullscreen></iframe>

```bash
sudo npm install -g homebridge
sudo npm install -g homebridge-http
```

在`~/.homebridge/config.json`里加入

```json
{
    "bridge": {
        "name": "HomebridgePI",
        "username": "CD:22:3D:E3:CE:30",
        "port": 51826,
        "pin": "031-45-156"
    },
    
    "description": "The Onion!",

    "platforms": [],

    "accessories": [ 
    {
        "accessory": "Http",
        "name": "康神的灯的灯灯等等灯",
        "switchHandling": "realtime",
        "http_method": "GET",
        "on_url":      "http://192.168.1.117/cgi-bin/led-on",
        "off_url":     "http://192.168.1.117/cgi-bin/led-off",
        "service": "Light",
        "brightnessHandling": "no",
        "brightness_url":     "http://localhost/controller/1707/%b",
        "brightnesslvl_url":  "http://localhost/status/100054",
        "sendimmediately": "",
        "username" : "",
        "password" : ""					    
          } 
       ]
}

```

就可以大喊一声"Hey Siri, 开灯"



## 闪Caps Lock

Linux 下可以: 

```bash
#turn on
xset led named "Scroll Lock"

#turn off
xset -led named "Scroll Lock"
```

Mac OS X:

 - <https://github.com/busyloop/maclight>

貌似还有闪Morse Code:

 - <http://www.psychicorigami.com/2009/03/01/5k-morse-code-app-using-capslock-led/>


以及还有Pidgin新消息到来, 闪Thinkpad的键盘灯(好感人..):

 - [pidgin-blinklight](https://packages.debian.org/sid/net/pidgin-blinklight)

Thinkpad的键盘灯可以直接被操作:

 - <http://www.thinkwiki.org/wiki/ThinkLight>

```bash
# cd /sys/devices/platform/thinkpad_acpi/leds
# ls
tpacpi::power  tpacpi::standby  tpacpi::thinklight  tpacpi::thinkvantage
# cd "tpacpi::power"
# while true;do echo 0 > brightness;sleep 0.1;echo 1 >brightness;sleep 0.1;done
```

 - `power`对应的是电源按钮的灯
 - `standby`对应的是机器后背的月亮待机灯
 - `thinklight`对应的是Thinkpad的键盘灯, 可惜在x230上支持有问题, 只能关不能开
 - `thinkvantage`未知, 应该是在其它Thinkpad机型上有

以上的支持是由`thinkpad_acpi`这个Kernel module来支持. 

## 参考

 - 可以与IFTTT相联的开源USB LED灯: <http://blink1.thingm.com/>
