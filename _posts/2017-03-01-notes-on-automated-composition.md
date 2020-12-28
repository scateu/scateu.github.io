---
title: "音频跳频序列搜索:自动作曲导(倒)论"
date: 2017-03-01
layout: post
---


如果以 1 2 3 5 6 五声音阶作曲，其作曲空间是有限的。

若假设8个音符的组合，可以构成一个乐句，那么共有

$$
5^8 = 390625
$$

种可能。

作曲家的工作，就是从这些组合里，尽可能地搜索(暴力破解、遍历)到好的、令人印象深刻的、魔音绕耳三日不绝的跳频序列(Frequency Hopping Pattern)

## 十二平均律

学有余力的同学，建议参考[Yaboo: 《律学》](https://leoyaboo.github.io/2017/03/04/musical-temperament.html)

$$ 
\mathrm{A} = 441 \mathrm{Hz} \\
\mathrm{A\#} = 441 \times 2^{\frac{1}{12}} = 467.223 \mathrm{Hz} \\
\mathrm{B} = 441 \times 2^{\frac{2}{12}} = 495.006 \mathrm{Hz} \\
\vdots \\
\mathrm{a} = 441 \times 2^{\frac{12}{12}} = 882 \mathrm{Hz} 
$$

(在演出前，[吹笙的同学](https://sites.google.com/site/mydtsinghua/dui-wei-jie-shao/xue-yuan-ban)会四处找我们给我们校音，亮出家伙低声道: "要A么?")

**算例:**

([五度相生律](https://zh.wikipedia.org/wiki/%E4%BA%94%E5%BA%A6%E7%9B%B8%E7%94%9F%E5%BE%8B))

设$\mathrm{C}$的频率为$f=262 \mathrm{Hz}$。

则$\mathrm{G}$的频率为:

$$
2^{\frac{7}{12}} f \approx 1.498 f \approx \frac{3}{2} f \approx 392.476 \mathrm{Hz}
$$


| C (Do) | D (Re) | E (Mi) | F (Fa) | G (Sol) | A (La) | B (Si) | c (Do) |
|--------|--------|--------|--------|---------|--------|--------|--------|
| 262    | 294    | 330    | 349    | 392     | 440    | 494    | 524    |

注意看哦:

把 C (Do) 乘一下 $\frac{3}{2}$

$$
262 \times \frac{3}{2} = 393 \mathrm{Hz}
$$

即生成了 G (Sol)。

再继续来:

$$
393 \times \frac{3}{2} = 589.5 \mathrm{Hz}
$$

$589.5$超了，那么除以$2$(即降低八度):

$$
589.5 \times \frac{1}{2} = 294.75 \mathrm{Hz}
$$

即是 D (Re)。

如是往复

$$
294.75 \times \frac{3}{2} = 442 \mathrm{Hz}
$$

生成了 A (La)。


## 功夫熊猫

    | 3 5 6 3 2 1 3 |

    | 3 5 6 i 6 1 2 | 
              . . .

    | 2 3 5 3 21 2  |

    | 2 3 1 2 56 1 | 


## 整点报时

    3 1 2 5 | 5 2 3 1 
          .   .


## 菊次郎的夏天

    5123 211
    .

## 人民军队忠于党 - 2015抗战胜利阅兵

    1 56 12 1 35 56 5 
      ..


## 唱支山歌给党听

    33 3 6 5 3 51 6 2 


## Nightingale - Yanni

    | 35 6 5 3 | 35 35 67 65 | 5653 2 5 3 |

## With an orchid - Yanni

    | 2 3 63 23 12 6i 2 |
    | 2 3 53 53 53 23 5 |


## 西游记

    | 6636 i635 6636 i635 |
    | 6645 i645 6645 i645 | 

## 雨后庭院 - 苏文庆

    | 123 5 |
          .

    | 123 5 35   | 

    | 356 6 5 3 561 2 3 2 | 

## Intel主题

    5 1 5 2 
    .   .

## Windows XP

关机

    i 5 1 2 

开机

    5 52 15 52 
      .   .

## Nokia

    54 6 7 32 4 5 21 3 5 i 

有兴趣的可以参阅这个[Nokia Tune Remake](https://www.audiodraft.com/contests/123-Nokia-Tune-Remake)

## 童年 - 罗大佑


    35 5 3 6 7 6 

（大龄文艺女青年之歌,是不是一样?）

    55 5 3 6 7 6 


## Layla - Eric Clapton

    35 6i65 6

## Viva la vida - Coldplay

    1 1 1 12 2 2 2 2 7 7 7 7 3 3 3 3 3 

## 谭晶: 在那东山顶上

    5 5 56 45 3 21 

由于上述记法无法表述符点及时值... 我们可以将采样率加倍:

    55 55 56 45 33 32 1 


## Positive Outlook

[Positive Outlook](http://music.163.com/#/song?id=27946926)，也就是天朝火箭发射直播用的祖传背景音乐

    5 -  2 - 3 1 2 5 
    .              .

精细化采样率: (时值全展开成4分音符)

    55 52 22 23 11 25 55
    .. .            . ..

## 仙剑奇侠传95版

蝶恋

    33 32 3 - 
    23 22 6 67
    i 21 7 65 6

晨光

    5 1 2 3 | 56 53 1 - |
    6 1 6 5 | 33 55 656 12 |

    656 53 12 12 | 323 53 23 23 |
    535 6i i65 3 - 2 

## 最炫民族风 - 凤凰传奇

    3 6 1 3 | 223 21 21 65 |

## 2002韩日世界杯主题曲 - Anthem - Vangelis

    5 6 5 6 | i 2 3 2 
    5 6 1 2 | 3 2 1 - 

## 冰与火之歌

    3 6 12 3 6 12 7
    2 5 17 2 5 17 6

## BBC神探夏洛克

    咚咚咚咚 3 5 #4 2 | 2 #4 3 | 1 3 2 6 | 67 1 2 7 16|

    63 3 #23 4 3 26 , 26 6 #4 67 6 i

## 蕃社姑娘 - 范宗沛 《望，不忘春风》

    5 65 5i 65 32 32 1 2 3 53 53 2 3 
    6 i6 i6 3 53 5 6 
    1 3 23 1 2 -

## 夏影

[夏影](http://music.163.com/#/song?id=28151024)

    1 512 3 5 2 2 31 2 3 
    32 1 156 5 

## Moves like a Jagger - Maroon 5

    6 1 2 6 53 21 1 3 6
    .                 .

## 段子

高晓松(应该是他)讲的，某天他在一个比赛上，看到我方群众一边按节奏鼓掌，一边大喊加油。
于是他给出了一个建议的节奏型:

    x  x  0x  x
    嘿 嘿 吼嘿

事实上，美国人近期四处流行倒川，也用这个节奏型..

而我们的群众，喊了几次之后，马上就fallback回:

    x x x x x x x x x x x x x x x x x x x x x x 

## 习题

请根据以上信息，制备一个自动作曲人工智能。下周五交给课代表。

## 参考

 - <https://www.youtube.com/watch?v=wxJImbUCyJw&list=PLKDwJGmIffmdWLKsfrpNKyY1QCo653rya>
 - 2005年的[Wolfram Tone](http://tones.wolfram.com/)

<iframe width="560" height="315" src="https://www.youtube.com/embed/SacogDL_4JU" frameborder="0" allowfullscreen></iframe>
