---
layout: post
title: 使用GNU Lilypond 打简谱
date: 2014/03/07 02:12:11
---

# 使用GNU Lilypond 打简谱

<http://people.ds.cam.ac.uk/ssb22/mwrhome/jianpu-ly.html>

提供了一个[Python脚本](http://people.ds.cam.ac.uk/ssb22/mwrhome/jianpu-ly.py), 可以将简谱转换成Lilypond的语法, 并且可以生成Midi

举例:
    
    
    title=晴雯歌(二胡I)
    1=F
    
    R{
    1'  - q7  q6 q3 q5   6 - - -  3 q6. s1' q6 ( q5 q3 q2 )  q3 q5 2 - q2 q3
    
    5 - - q3 q2     q3 ( q5 1 ) - q5 ( q6 )    q7, ( q6, q2 q3 )  q5, ( q6, q7, q2 )        6 - - q5 ( q6 )
    
    q7, ( q6, q2 q3 )  q5, ( q6, q2 q3 )  1 - - -    6. ( q1' ) q6 ( q5 q3 q2 )  1. q3 q2 q3 q1 q7,
    
    6  q3 q5 2. q3   q2 ( q3 q7, q6, ) 5 -     0 q2 ( q3 5 )  q3 ( q5  6 ) 1' 7 6
    
    q5. s6 q5 q2 3 -    0 q7, ( q2 6, ) -   0 q7, ( q2 5, ) -  1. q2 3 q6 q1'  
    
    5. q6 q7 q6  s7 s2' q7  6 - - -   0 q2 ( q3 ) 5 5    0 q3 ( q5 ) 1 q5, ( q6 )
    
    q7, ( q6, q2 q3 ) q5, ( q6, q7, q2 ) 6, s7,( s2 ) q7 q6, ( q1 ) q5, ( q6, )  q7, ( q6, q2 q3 )  q5, ( q6, q2 q3 ) 1. q2 q3 q5 q7 q6 
    
    1' - q7 q6 q3 q5   6. q1' q6 q5 q3 q2  3  q6. ( s1' ) q6 ( q5 q3 q2 )  q3 q5 q2 q5 q3 ( q2 q7 q6 ) 
    
    5, q2 q3 5 5    0 q3 q5 1 q5, ( q6, )  q7, ( q6, ) q2 ( q3 ) q5, ( q6, ) q2 ( q3 ) 6, s7, ( s2 q7, ) q6, ( q1 ) q5 ( q6 )
    
    q7, ( q6, q2 q3 ) q5, ( q6, q2 q3 ) 
    
    }
    
    A{ 1 - - - | 1 - - - 5 3 q5 ( q3 ) 5 6 \> ( - - - 6 ) - - - \! \pp }
    
    

其中有几个需要注意的:

  * 括号()作为连音符, 但是这里面要跟在第一个被连的音符_后面_, 要有空格
  * `\>` 和 `\\!` 用来产生渐弱
  * `\pp` 或 `\fp` `\mf` 之类的可以产生表情记号
  * `R{ 1 2 3 4 } A{ 1 - - - | 2 - - - }` 用作反复, 注意A跟的部分用`|`区分跳房子
  * q代表4分音符, s代表8分音符

出来的效果是这样的:

![]({{ site.imageurl }}/qwg.png)

连小节号都给自动标注了. 

## 参阅

GNU Lilypond的[CheetSheet](http://lilypond.org/doc/v2.18/Documentation/notation/cheat-sheet)

### 这个例子

![](http://people.ds.cam.ac.uk/ssb22/mwrhome/jianpu-ly.png)
    
    
    q1 \mp s3 s5 q1'. sb7 ~ sb7 s6 s4 s#4 5
