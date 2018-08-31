---
title: "基于拖延的排序"
date: 2018-08-31
layout: post
ruby_notation: true
---

之前看到过这样的排序..

```bash
#!/bin/bash

# Sleep sort
# http://dis.4chan.org/read/prog/1295544154


function f() {
    sleep "$1"
    echo "$1"
}
while [ -n "$1" ]
do
    f "$1" &
    shift
done
wait

# example usage:
# ./sleepsort.bash 5 3 6 3 6 3 1 4 7
```

突然想到一件事，如果作为一个[资源分配者]{老板}，面对一堆人提出来的[资源]{经费}申请，拖延着什么都不批。一部分人真着急就整天催，就批;另一部分人不催，就彻底拖黄了。诶这不就是按闹分配么...


## 外一则

突然理解[高管们]{Steve Jobs}为什么用不需要键盘了 -- 因为只需要回一个"Approved" "No." "Yes." "Good job." 就可以了.. 触屏足够啦
