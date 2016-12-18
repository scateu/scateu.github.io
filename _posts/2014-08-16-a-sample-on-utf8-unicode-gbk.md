---
layout: post
title: 简单分析了一下UTF8/GBK/Unicode(UTF16/UCS2)
date: 2014/08/16 17:04:55
---

# 简单分析了一下UTF8/GBK/Unicode(UTF16/UCS2)

### 一

	Unicode: u'\u4e00'
	UTF-8: '\xe4\xb8\x80'
	GBK: '\xd2\xbb'



### 龥

	Unicode: u'\u9fa5'
	UTF-8: '\xe9\xbe\xa5'
	GBK: '\xfd\x9b'



### 烫

	Unicode: u'\u70eb'
	UTF-8: '\xe7\x83\xab'
	GBK: '\xcc\xcc'



### 锟

	Unicode: u'\u951f'
	UTF-8: '\xe9\x94\x9f'
	GBK: '\xef\xbf'



### 斤

	Unicode: u'\u65a4'
	UTF-8: '\xe6\x96\xa4'
	GBK: '\xbd\xef'



### 拷

	Unicode: u'\u62f7'
	UTF-8: '\xe6\x8b\xb7'
	GBK: '\xbf\xbd'



### 锟斤拷

	Unicode: u'\u951f\u65a4\u62f7'
	UTF-8: '\xe9\x94\x9f\xe6\x96\xa4\xe6\x8b\xb7'
	GBK: '\xef\xbf\xbd\xef\xbf\xbd'



### 鐜

	Unicode: u'\u941c'
	UTF-8: '\xe9\x90\x9c'
	GBK: '\xe7\x8e'



### 嬪

	Unicode: u'\u5b2a'
	UTF-8: '\xe5\xac\xaa'
	GBK: '\x8b\xe5'

### 悍

	Unicode: u'\u608d'
	UTF-8: '\xe6\x82\x8d'
	GBK: '\xba\xb7'

### 鐜嬪悍

	Unicode: u'\u941c\u5b2a\u608d'
	UTF-8: '\xe9\x90\x9c\xe5\xac\xaa\xe6\x82\x8d'
	GBK: '\xe7\x8e\x8b\xe5\xba\xb7'

### 王

	Unicode: u'\u738b'
	UTF-8: '\xe7\x8e\x8b'
	GBK: '\xcd\xf5'

### 康

	Unicode: u'\u5eb7'
	UTF-8: '\xe5\xba\xb7'
	GBK: '\xbf\xb5'

### 王康

	Unicode: u'\u738b\u5eb7'
	UTF-8: '\xe7\x8e\x8b\xe5\xba\xb7'
	GBK: '\xcd\xf5\xbf\xb5'

### 王康

	UTF-8 misdecode as GBK:
	鐜嬪悍
	u'\u941c\u5b2a\u608d'

	GBK misdecode as UTF-8:
	>_<



生成的代码见gist: [https://gist.github.com/scateu/faa03c167066bf40d388]()

<script src="https://gist.github.com/scateu/faa03c167066bf40d388.js"></script>