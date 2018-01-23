---
layout: post
title: ranger初始配置
date: 2014/03/01 23:29:54
---

# ranger初始配置

ranger是一个基于Python的, vim风格键绑定的, 命令行基础的文件管理器

## 安装
    
    sudo apt-get install ranger
    # cp /etc/ranger/data/scope.sh ~/.config/ranger/
    ranger --copy-config=scope
    # 如果想定制rc.conf
    ranger --copy-config=rc

## 配置

### 增加pdf预览功能
    
    
    sudo apt-get install poppler-utils
    

### 增加Highlight预览
    
    
    sudo apt-get install highlight
    

## Tips

  * 预览状态下, 按`i`键可以滚动预览窗口
  * 按V选中多个文件, 然后`:bulkrename`可以用vim进行批量重命名

## iTerm2 中显示图片

*update: 2018-01-23*

参见: <https://github.com/ranger/ranger/wiki/Image-Previews>

iTerm2实现了一种类似于`w3mimagedisplay`的图片显示协议:

例如，在iTerm2里: (SSH也可以哦~ 但在tmux里没试成)

```bash
wget https://iterm2.com/utilities/imgcat -O imgcat
chmod +x imgcat
./imgcat blahblah.jpg
```

而Ranger也内建了对iTerm2的这种图像显示协议的支持。

只需要:

 - Add the line set `preview_images true` to your `~/.config/ranger/rc.conf`.
 - Add the line set `preview_images_method iterm2` to your `~/.config/ranger/rc.conf`.

更多参见`man ranger`的`PREVIEWS`一节。

## See Also 

 - <https://github.com/ranger/ranger/wiki/Official-user-guide>
 - <https://wiki.archlinux.org/index.php/ranger>
