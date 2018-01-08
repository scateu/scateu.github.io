---
title: "一点微小的密码学知识"
date: 2016-11-25
layout: post
mathjax: true
---

<details markdown="1"><summary>目录</summary>
* TOC
{:toc}
</details>

## RSA 算法

参见[Wikipedia:RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem))

一言以蔽之, 记住以下定义, $d$是私钥:

$$ (m^e)^d \equiv m  \mod n $$

其中: 

$$ 
n = pq \\
ed \equiv 1 \mod (p - 1)(q - 1) 
$$

Encryption:

$$ c = m^e \mod n $$

Decryption:

$$ m = c^d \mod n $$


### RSA 中各参数

 - Modulus: $n$ of length $b$ bits
 - Public Exponent: $e$ 
   - (通常取3或65537, 但[取3被认为不安全](http://crypto.stackexchange.com/questions/3110/impacts-of-not-using-rsa-exponent-of-65537))
 - Private Exponent: $d$
 - Prime1: $p$
 - Prime2: $q$
   - $n = pq$
 - Exponent1: $d_p = d \mod p-1$
 - Exponent2: $d_q = d \mod q-1$
 - Coefficient: $q_{inv} = q^{-1} \mod p$
 - Private key: $PR = (n, e, d, p, q, d_p, d_q, q_{inv})$
 - Public Key: $PU = (n, e)$

私钥中的这些$d_p$ $d_q$ $q_{inv}$用以基于中国剩余定理进行计算优化:

$$ m_1 = c^{d_p} \mod p $$

$$ m_2 = c^{d_q} \mod q $$

$$ h = q_{inv} (m_1 - m_2) \mod p $$

$$ m = m_2 + hq $$

### 习题: 以ssh-keygen为例, 看一下公私钥pem文件里有些什么

```bash
$ ssh-keygen
$ ssh-keygen -y -f ~/.ssh/id_rsa # 根据私钥生成公钥
$ openssl rsa -in ~/.ssh/id_rsa -text -noout
$ openssl rsa -in ~/.ssh/id_rsa -out pubkey.pem -pubout # 根据私钥生成公钥. 注意, 直接看~/.ssh/id_rsa.pub是无效的, 格式不对
$ openssl rsa -in pubkey.pem -pubin -text -noout # 看一下公钥, 里面只有输出 modulus 和 e
```

**NOTE:** 在多数密码系统里, 可以根据Private Key生成Public Key. 

### 习题: RSA算例

$p=11, q=7, e=13$, 私钥是什么? 若明文$m=3$, 那么密文是什么? 

<details><summary>解:(点击展开)</summary>

$$n=pq=77$$ 

由于要满足: 

$$ ed \equiv 1 \mod (p - 1)(q - 1) $$

即:

$$ ed = 13d \equiv 1 \mod 60$$

解得:

$$ d = 37 $$

密文:

$$ c = m^e = 3^{13} \mod 77 = 38 $$

解密:

$$ c^d = 38^{37} \mod 77 = 3 = m $$

</details>

以上计算过程可以在:

 - <https://www.cs.drexel.edu/~jpopyack/IntroCS/HW/RSAWorksheet.html>

体验RSA算法的各参数. 

### mod 运算的形象比喻

日本人的《图解密码技术》一书中, 把mod计算比喻为"在一个时钟上转圈", 也很有意思, 有助于理解. 举例: 对于 mod 12 来说,

 - 加法: $+3$
   - 把指针向前拨3
 - 数乘: $4 \times 3$
   - 即是"把针向前拨3,再把针向前拨3,再把针向前拨3,再把针向前拨3"
 - 乘方: $3^4$
   - 把 '把 "把 (把针向前拨3) 这个操作 做3遍" 做3遍' 做3遍

减法、除法、对数的定义留做思考题. (喂喂明明就是你偷懒不想写好么! )

RSA 算法中, 相当于有一个刻度为 $N$ 的大圆盘, 在上面不停地转啊转啊转圈圈. 转得你记几都不认识记几的时候, 就算是加密了. 

### 习题: 根据Google HTTPS证书的公钥, 手算出私钥

> During his own Google interview, Jeff Dean was asked the implications if P=NP were true. He said "P = 0 or N = 1." Then, before the interviewer had even finished laughing, Jeff examined Google's public certificate and wrote the private key on the whiteboard.

喂喂, 停下笔, 这是个[段子](https://www.quora.com/What-are-all-the-Jeff-Dean-facts)啦. (笔者写到这里才明白, 数学家们的书, 一般都会把重要的信息以习题的形式给出. 想当年年少轻狂死活不肯做[习题](https://www.quora.com/What-is-the-most-ridiculous-example-of-the-proof-is-left-as-an-exercise-to-the-reader-in-a-mathematics-book), 认为刷题那是弱者的行为.... 像我这样的强者应该死啃文字就能理解.... 你们不要学我..)

### RSA 算法的简要证明

参考[Wikipedia](https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Proof_using_Fermat.27s_little_theorem)

**注:** 以下扔掉了很多的细节和限定条件, 只为让大家能够对整个证明过程有一个大体的认识. 


#### 1. 已知

$$ n = pq $$

$$ ed \equiv 1 \mod \phi(pq) $$

$$ \phi(pq) = (p - 1)(q - 1) $$


#### 2. 求证

$$ (m^e)^d \equiv m \mod pq $$

#### 3. 依赖的定理


**费马小定理:**

([这里](https://mp.weixin.qq.com/s?__biz=MzA3OTgzMzUzOA==&mid=2651227431&idx=1&sn=8a249975b3b754b062a9f998eb111338&chksm=845f558ab328dc9c200db932866abd363a5b284e35f72c7317aa2329c9d7b003339724cbe735&mpshare=1&scene=1&srcid=02155ICQJ3eATKwRpgHvufkN&pass_ticket=9%2F4JlZH6VGedHYRK2ggZ1a04q%2FglG9kWCUNTWLKKdauf91Rr3tjyz8UPyKamAyJS#rd)有一个很有趣的证明，物理学家给出的，使用伊辛自旋(Ising spin)证明，但实际上不理解这个概念也无所谓，用小学几何知识就够了。证明出自: H. Gutfreund and W. A. Little, Am. J. Phys.50(3), 1982., A. Zee “Group Theory in a Nutshell for Physicists”第153页)

($p$为素数, 且$p$不整除$a$. )

$$ a^{p-1} \equiv 1 \mod p $$ 

**中国剩余定理(CRT: Chinese Remainder Theorem):**

简言之, 给出了同余方程组的解:

> 今有物不知其数, 三三数之剩二, 五五数之剩三, 七七数之剩二, 问物几何? 

详细可参考[Wiki](https://zh.wikipedia.org/wiki/%E4%B8%AD%E5%9B%BD%E5%89%A9%E4%BD%99%E5%AE%9A%E7%90%86).

#### 4. 证明

由同余的定义, 可写为:

$$
ed - 1 = h\phi(pq) = h(p - 1)(q - 1)
$$

不考虑 $m^{ed} \equiv 0 \mod p$ 和 $m^{ed} \equiv 0 \mod q$ 等特殊情况(证明略去)下:

$$
m^{ed} = m^{ed-1}m = m^{h(p-1)(q-1)}m  \\
    = (m^{p-1})^{h(q-1)}m \equiv 1^{h(q-1)}m \equiv m \mod p \\
    = (m^{q-1})^{h(p-1)}m \equiv 1^{h(p-1)}m \equiv m \mod q  
$$

后两行分别用了费马小定理. 

然后将这两行组成同余方程组:

$$
m^{ed} \equiv m \mod p  \\
m^{ed} \equiv m \mod q 
$$

大部分书籍在这里, 下一步就直接由中国剩余定理证得:

$$
m^{ed} \equiv m \mod pq 
$$

<details> <summary>我思考了一下: </summary>

由于$p$和$q$互素, 由中国剩余定理得出唯一解为:

$$ m^{ed} \equiv qq^{-1}m + pp^{-1}m \mod pq $$

其中:

$$
qq^{-1} \equiv 1 \mod p  \\
pp^{-1} \equiv 1 \mod q 
$$

我们写成:

$$ 
qq^{-1} = 1 - k_1p ,  (k_1 \in \mathbb{Z}) \\
pp^{-1} = 1 - k_2q ,  (k_2 \in \mathbb{Z}) 
$$

由Bézout等式(辗转相消), 由于$p$, $q$互素, 则一定存在:

$$ k_1p + k_2q = 1 $$

于是:

$$
 m^{ed} \equiv qq^{-1}m + pp^{-1}m  \\
   = (1 - k_1p)m + (1 - k_2q)m  \\
   = 2m - (k_1p+k_2q)m = m \mod pq 
$$

</details>


#### 5. 后记

我发现证明RSA算法所需要的所有数学知识, 在大一第一学期的[张贤科老师](http://faculty.math.tsinghua.edu.cn/~xzhang/resume.html)的《高等代数学》课上, 前7页(1,2,3,...7)就都讲完了. 想我一个刚入学的萌新, 从小山沟沟到大学里上的第一堂课看到的头七页书, 足以用来证明RSA, 真不能怪我学渣啊..... 

当时, 我们几堂课听下来, 觉得吃不消, 课间就跑去前面讲台, 问能不能提供一些"参考书". 张老师他当时似乎受到了极大的冒犯, 激动地说:"你们是觉的我的书太简单了吗?" 后来才明白, 我们指的, 是啥黄冈模拟啥高考几年之类的"教辅"; 而张老师认为的辅导书, 是"学有余力""深入内容"的"参考"书. 估计这也是考试难的原因之一吧. [一个悲伤的表情]


## 证书, 签名

```
签名 = 私钥作用于(计算哈希(消息))
证书 = 被签名了的公钥              //指一般情况, 有时候证书里也有私钥
```

注意, 公钥并不是只能用于加密, 私钥并不是只能用于解密. 加密/解密都是一种操作. 公钥也可以用于"解"密(私钥也可以用于"加"密). 
因此, 我更倾向于称"把密钥作用在...上". 

## Diffie-Hellman 密钥交换

是为了在不可靠信道上协商出一个共享密钥的方法:

公开分发:

 - P, 非常大的质数
 - G, 与P相关的数, 称为生成元(generator)

共享密钥生成过程:

1. Alice生成随机数$A \in [1, P-2]$, 然后计算 $G^A \mod P$ , 并将其发给Bob. (计算结果不需要保密)
2. Bob生成随机数$B \in [1, P-2]$, 然后计算: $G^B \mod P$, 并将其发给Alice. (计算结果不需要保密)
3. Alice收到$G^B \mod P$后, 由自己手中的保密的随机数$A$, 计算得 $G^{A \times B} \mod P$
4. Bob收到$G^A \mod P$后, 由自己手中的保密的随机数$B$, 计算得 $G^{A \times B} \mod P$

至此, 协商完成.


<details markdown="1"><summary> 讨论: 保密性 </summary> 

即使知道了$G^A \mod P$和$G^B \mod P$, 不能直接生成$G^{A \times B} \mod P$

已知 $G^A \mod P$ 求 $A$ 的有效算法到现在还没有出现, 这个问题被称为有限群(finite group)的离散对数问题.

</details>

## 椭圆曲线密码学

关于椭圆曲线密码学(Elliptic Curve), 可以见
 - [Certicom公司的教程](https://www.certicom.com/index.php/ecc-tutorial)
 - <https://097.io/understand-ecc/>
 - <http://www.pediy.com/kssd/pediy06/pediy6014.htm>
 - [Youtube](https://www.youtube.com/watch?v=dCvB-mhkT0w)
 - [OpenSSL Wiki](https://wiki.openssl.org/index.php/Elliptic_Curve_Cryptography)
 - 这篇[签名算法DSA和ECDSA-阅微堂](http://zhiqiang.org/blog/it/das-and-ecdsa-rsa.html)写的也非常不错
 - <http://www.johannes-bauer.com/compsci/ecc/>
 - <https://blog.cloudflare.com/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography/>

![](https://blog.cloudflare.com/content/images/image01.gif)

### 准备知识: 连续情况的椭圆曲线

简言之:

$$ y^2 = x^3 + ax + b $$

Abel群, 定义加法为: 

$$ P + Q = R $$

$P$ $Q$两点连线交于曲线的另一点$R'$, 然后与$x$轴垂直, 交于曲线另一点得到$R$. 

$2P$的定义是$P$点切线(下略). 于是便有了数乘的定义. 


### 离散情况

$$
K = kG 
$$ 

(条件略)

 - G 为基点 (Generator)
 - k 为私钥
 - K 为公钥

通信过程举例:

**加密:**

 - 生成 M(essage)
 - 生成随机整数 r 
 - $C_1 = M + rK$
 - $C_2 = rG$
 - 发送 $C_1$,$C_2$

**解密:**

 - 收到 $C_1$,$C_2$
 - $C_1 - kC_2 = M + rK - krG = M + rK - rkG = M$

ECC 的好处是快(同样加密强度比RSA快500倍), 且无法破解(啊啊啊....谁信啊). 

据说:

```
160 bits ECC == 1024 bits RSA
256 bits ECC == 3072 bits RSA
384 bits ECC == 7680 bits RSA
```

384 bits ECC 的强度被美国当成`Top Secret`的标准了. 

### 习题: OpenSSL 操作

U2F-Zero里用的是prime256v1的椭圆曲线. 

```bash
openssl ecparam -genkey -name prime256v1 -out key.pem
openssl ecparam -list_curves
man ecparam
```

另外, 可以参考这个[sample-ecdsa](https://kjur.github.io/jsrsasign/sample-ecdsa.html)页面. 

## OpenSSL 教程

### PEM / DER 格式

简言之, PEM是ASCII格式的密钥/证书文件; DER是二进制的密钥/证书文件. 

openssl 命令行工具可以对二者进行转换. 


### 习题: 使用 openssl digest 来签名/加密/核验/解密

```bash
$ openssl dgst -sha256 message.txt
$ openssl rsa -in ~/.ssh/id_rsa -pubout -out pubkey.pem
$ openssl dgst -binary  -sha256 -sign ~/.ssh/id_rsa  message.txt   > signature.bin
$ openssl dgst -binary -sha256 -verify pubkey.pem  -signature signature.bin  message.txt 
```

### 打个岔: HMAC 又是个啥

MAC 被称为消息认证码, 是双方都有一个相同的共享密钥的情况下, 对发出的消息进行验证的方法. (但这种认证码, 不能"向第三方验证消息由谁发出", 也不能"防否认")

```
HMAC = 哈希(密钥与消息放在一起)
```

精确定义为: (摘自[Wikipedia:HMAC](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code))

$$
\textit{HMAC}(K, m) = H \Bigl( (K' \oplus opad) \;||\; H \bigl( (K' \oplus ipad) \;||\; m \bigr) \Bigr)
$$

哈希(hash)字面的意思是:"剁碎". 

### CSR: Certificate Signing Requests 

感觉上就是一个自己的公钥, 发给证书签发机构去签一下. 

 - Distinguised Name (DN)
 - Common Name (CN)
 - Fully Qualified Domain Name (FQDN)

### 习题: 生成自签名的证书

```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

## 习题: 使用Let's Encrypt做一个HTTPS服务器

建议直接看<https://letsencrypt.org/>上面的文档, 其次才是参考这篇[中文博客](https://imququ.com/post/letsencrypt-certificate.html). 

HTTPS的相关概念, 可以参考[blink.moe的博客](https://blog.blink.moe/2016/11/30/https/). 

Let's Encrypt 建议使用[EFF的certbot](https://certbot.eff.org/)来进行自动签发. 但是自动签发过程中, certbot会配合Let's Encrypt的验证请求做一些应答, 以验证你对域名的所有权, 因此服务器在内网中不可使用. 你可以参考[手动方式](https://certbot.eff.org/docs/using.html#manual). 

以上还是过于自动化, 可以参考[acme-tiny](https://github.com/diafygi/acme-tiny)项目来理解Let's Encrypt的工作过程. 

```bash
man openssl
man req
man x509
```

可以用[SSL Checker](https://www.sslshopper.com/ssl-checker.html)来调试检查. 

### Let's Encrypt 用的 ACME 协议 

全称是: Automatic Certificate Management Environment

<https://github.com/ietf-wg-acme/acme>

基本上, 就是以被私钥SHA256 sign过的json请求来交互. 

有以下几种Key:

 - Domain Key
   - Domain Public Key (通过CSR请求被Let's Encrypt签成证书)
   - Domain Private Key
 - Account Key (用于续签, 以及与Let's Encrypt服务器通信)

### DNS-01 验证方式

<https://github.com/jbjonesjr/letsencrypt-manual-hook>

注意, 需要生成 dhparam

```bash
$ openssl dhparam -out server.dhparam 4096 
```

也有[针对DNSPod的Hook](https://github.com/ftao/letsencrypt-dnspod-hook)



### OpenSSL相关参考链接

 - [Youtube: How to Use OpenSSL to Create RSA Public/Private Key Pair, Sign And Encrypt Messages](https://www.youtube.com/watch?v=V_tPxYcEX0g)
 - [Gary C. Kessler: An Overview of Cryptography](http://www.garykessler.net/library/crypto.html)
 - [Digital Ocean: OpenSSL Essentials](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)

## See Also: NaCl项目

```bash
sudo apt-get install nacl-tools
```

## 趣闻: EFF DES 破解机

 - [Wikipedia: EFF DES 破解机](https://zh.wikipedia.org/wiki/EFF_DES%E7%A0%B4%E8%A7%A3%E6%9C%BA)

## 趣闻: 素数

使用OpenSSL来测试一个数是否为素数:

```
$ openssl prime 15
```

几个有趣的素数:

ed25519中用的素数就是$2^{255} - 19$

### 费马素数

[Wikipedia: Fermat Number](https://en.wikipedia.org/wiki/Fermat_number):

$$
2^n + 1
$$

如$3, 5, 17, 257, 65537$

RSA算法中的$e$常取$65537$. 

### 梅森素数 

> 1772年, 有"数学英雄"美名的瑞士数学大师欧拉在双目失明的情况下, 靠心算证明了 $2^{31}-1$ (即2147483647)是第8个梅森素数. 

1903年10月, 纽约的数学家科尔做了一次不讲话的学术报告:


$$
2^{67} - 1 = 193707721 \times 761838257287
$$


台下<del>几百个教授一致通过</del>一片掌声. 据说他用了三年来的全部星期天. 

另外, 这事用 [WolframAlpha](http://www.wolframalpha.com/input/?i=FactorInteger(2%5E67-1)) 也能马上算出来. 科技进展真是神速啊. 

做素性测试(Primality Test)和分解大数(Integer Factorization)的难度是不一样的, 前者可以做到很快. 

> 1963年6月2日晚上8点, 当第23个梅森素数 $2^{11213}-1$ 通过大型计算机被找到时, 美国广播公司(ABC)中断了正常的节目播放, 在第一时间发布了这一重要消息. 而发现这个素数的美国伊利诺伊大学数学系全体师生感到无比骄傲, 为了让全世界都分享这一重大成果, 以至把所有从系里发出的信封都盖上了" $2^{11213}-1$ 是个素数"的邮戳. 

刚刚在我的笔记本电脑上, 用`openssl prime`素性检测了一下$2^{11213}-1$, 花了12秒...

又拿下面的Python脚本跑了一下.... (已经跑了433个小时还没跑出来... 放弃了...)

<details markdown="1"><summary>Python脚本: 判别$2^{12213}$的素性</summary>
```python
def isprime(n):
    """Returns True if n is prime."""
    if n == 2:
        return True
    if n == 3:
        return True
    if n % 2 == 0:
        return False
    if n % 3 == 0:
        return False

    i = 5
    w = 2

    while i * i <= n:
        if n % i == 0:
            return False

        i += w
        w = 6 - w

    return True

print isprime(2**11213 - 1)
```
</details>

后面就被大家玩坏了, 例如1996年"互联网梅森素数大搜索"(GIMPS, the Great Internet Mersenne Prime Search)项目. 

<details markdown="1"><summary>2008年的新闻</summary>

> 2008年8月23日, 美国加州大学洛杉矶分校的计算机专家埃德森·史密斯发现了迄今已知的最大梅森素数 $2^{43112609}-1$, 该数也是目前已知的最大素数. 这个素数有12978189位; 如果用普通字号将它连续写下来, 长度可超过50公里! 这一重大成就被著名的《时代》杂志评为"2008年度50项最佳发明"之一. 前不久, 史密斯获得了EFF 颁布的10万美元大奖. 不过, 史密斯是私自利用学校的75台计算机参加GIMPS项目的; 本来这种行为应该被处罚, 但鉴于他为学校争了光, 因而还受到了校方的表彰. 

( *以上引自[凤凰新闻](http://tech.ifeng.com/discovery/detail_2011_10/14/9855566_0.shtml)* )
</details>

[2016年1月7日](http://www.mersenne.org/), 上述新闻又成为老黄历啦. 

<details markdown="1"><summary>Largest Known Prime, 49th Known Mersenne Prime Found!!</summary>

> January 7, 2016 — GIMPS celebrated its 20th anniversary with the discovery of the largest known prime number,  $2^{74207281}-1$. Curtis Cooper, one of many thousands of GIMPS volunteers, used one of his university's computers to make the find. The prime number, also known as M74207281, is calculated by multiplying together 74,207,281 twos then subtracting one. It has 22,338,618 digits -- almost 5 million digits longer than the previous record prime number. 
</details>

 - [List of known Mersenne prime numbers](http://www.mersenne.org/primes/)

See Also:

```
mlucas - program to perform Lucas-Lehmer test on a Mersenne number, 2 ^ p - 1
```

### DeCSS

 - <https://news.ycombinator.com/item?id=16084731>
 - <http://fatphil.org/maths/illegal1.html>
 - <http://decss.zoy.org/>

## 参考书

 - Handbook of Applied Cryptography
 - 图解密码技术
 - OpenSSL Cookbook

