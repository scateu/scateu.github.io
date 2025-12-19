---
title: "便捷的Vim大纲写作状态"
date: 2025-12-18
layout: post
---

有时候还是想写一些大纲，带有缩进。

但Tab或4空格的缩进太浪费空间，很容易把屏幕占满。

发现MIT的一些课程的[Syllabus](https://css.csail.mit.edu/6.5660/2023/lec/l01-intro.txt)使用了双空格缩进，很科学，很紧凑。

不像Markdown或Org mode的井号、星号那样看起来令人惊恐。Omni Outliner或Bike.app那样又太重，数据格式乱七八糟。

所以可以这样做:

```
:set tabstop=2 expandtab shiftwidth=2
```


或者使用Vim的Modeline技术，在文件首行或末行加上

```
# vim: tabstop=2 expandtab shiftwidth=2:
```

这样就可以用`>>`或`<<`来改变缩进状态了。

如果Modeline因为安全问题被Disable掉了，可以在`.vimrc`里加上:

```
autocmd FileType text setlocal tabstop=2 shiftwidth=2 expandtab
```

来对所有`.txt`文件生效。
