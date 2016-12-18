---
layout: post
title: 使用bash和tmux批量打开程序及重排序号
date: 2014/03/03 18:10:50
---

# 使用bash和tmux批量打开程序 

比如这样
    
    
    tmux new-session -d -s blahblah
    tmux send-key -t blahblah cd\ /home/scateu Enter
    tmux send-key -t blahblah ./01.sh Enter
    tmux split-window -h -t dab
    tmux send-key -t blahblah cd\ /home/scateu Enter
    tmux send-key -t blahblah ./02.sh Enter
    tmux att -t dab
    

其中

  * `-s`表示给新的session命名, 便于后续命令使用`-t`引用
  * `-d`表示建立新的session后马上detach掉, 把控制权交回给bash
  * send-key命令中的空格键需要转义
  
  
# 对tmux混乱不堪的窗口序号重新排序
	
	#!/bin/bash
	i=0
	tmux list-windows | cut -d: -f1 | while read winindex; do
	  if (( winindex != i )); then
				  tmux move-window -d -s $winindex -t $i
					fi
					  (( i++ ))
			  done
