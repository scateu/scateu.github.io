---
layout: post
title: ranger初始配置
date: 2014/03/01 23:29:54
---

# ranger初始配置

ranger是一个基于Python的, vim风格键绑定的, 命令行基础的文件管理器

## 安装
    
    
    sudo apt-get install ranger
    cp /etc/ranger/data/scope.sh ~/.config/ranger/
    

## 配置

### 增加pdf预览功能
    
    
    sudo apt-get install poppler-utils
    

### 增加Highlight预览
    
    
    sudo apt-get install highlight
    

## Tips

  * 预览状态下, 按`i`键可以滚动预览窗口
  * 按V选中多个文件, 然后`:bulkrename`可以用vim进行批量重命名