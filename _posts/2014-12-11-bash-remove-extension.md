---
layout: post
title:  "Bash中移除扩展名"
date:   2014-12-11 13:57
---

## 问题

要把 a.b.c 文件重命名为 a.b

## 方法1: Bash

    FILE=a.b.c
    mv ${FILE} ${FILE%.b}

## 方法2: sed 与 xargs

    echo a.b.c | sed 'p;s/\.c$//' | xargs -n 2 mv

## 方法3: basename

感谢[@femrat](https://twitter.com/femrat)提供

    FILE=a.b.c; mv $FILE `basename $FILE .c`

