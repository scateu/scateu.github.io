---
layout: post
title: Wordpress插件推荐
date: 2014/03/31 15:28:07
---

# Wordpress插件推荐

## **list-category-posts**

在文章里用shortcode嵌入各种各样的文章列表, 首位推荐.  `然后就可以像这样使用shortcode了` ` [catlist date=yes dateformat="Y-m-d " name="news" numberposts=25 template=default] ` **定制显示** 如果你需要把显示的日期放到前面去, 你需要： 

  1. 安装wp-filemanager
  2. 在主题对应的目录里建一个list-catagory-posts目录
  3. 建一个default.php
  4. 把插件目录里的list-category-posts/templates/default.php内容复制过来
  5. 修改你的default.php
就可以自由定制显示方式了.  **table of content** 可以在任意地方加入[toc]来生成目录