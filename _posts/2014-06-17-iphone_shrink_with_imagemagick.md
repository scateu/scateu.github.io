---
layout: post
title: 把iPhone里的照片批量缩小以节约空间
date: 2014/06/17 22:43:01
---

# 把iPhone里的照片批量缩小以节约空间

苹果绝对是想以这种方式强制你卖更大空间的iPhone

在Linux下面, 数据线插上

	sudo apt-get install ifuse imagemagick

	mkdir mnt

	ifuse ./mnt

	cd mnt/DCIM/100APPLE

	mogrify -resize 1024 *.JPG

结束