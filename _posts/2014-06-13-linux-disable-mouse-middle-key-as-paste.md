---
layout: post
title: Linux中禁用中键粘贴
date: 2014/06/13 23:08:45
---

# Linux中禁用中键粘贴

Thinkpad的中键加小红冒用来做滚轮非常好用, 

但是GTK的中键默认的行为是粘贴, 所以在剪贴板里有东西的时候, 经常会误触发粘贴出来一大堆文字. 

  


然后找到了这篇文章

<http://blogs.bu.edu/mhirsch/2013/06/disabling-middle-mouse-paste-linux/>

  


大致意思就是

xmodmap -pp

	There are 10 pointer buttons defined. `` Physical Button  
	Button   Code  
	1        1  
	2        2  
	3        3  
	4        4  
	5        5  
	6        6  
	7        7  
	8        8  
	9        9  
	10      10`

然后把最后一个和第2个调个个儿
 
写到.Xmodmap里

`pointer = 1 10 3 4 5 6 7 8 9 2`

然后滚动功能依然可以用, 而中键就不会再触发成为粘贴了. 