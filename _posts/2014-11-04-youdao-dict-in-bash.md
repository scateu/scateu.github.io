---
layout: post
title:  "命令行里查字典"
date:   2014-11-04 00:28:13
---

*Update: 2018-01-27*

## RFC 2229: dict

很古老的协议，端口号为2628

```
telnet dict.org dict
nc dict.org 2628
```

```
apt install dict
dict <word>
```

本地使用可以装个dictd，起个服务(只监听在localhost，且会自动放弃掉root权限，感觉上略安全)

```
apt install dict dictd dict-wn dict-gcide
```

在w3m里默认按下`Esc-w`或`Alt-w`就可以查字典啦。

缺点是没找到中文字典。 (据说有 `dict-stardict` 和`dict-xdict` 两个包，我还没找着..)


*参考:* [1](http://ju.outofmemory.cn/entry/148511) [2](http://blog.cathayan.org/item/1715) [3](http://www.cnblogs.com/bamanzi/archive/2011/06/26/emacs-dict.html) [4](https://www.mdbg.net/chinese/dictionary?page=cedict)


## ici

金山版 <https://github.com/Flowerowl/ici>

    sudo pip install ici

### vim

在`.vimrc`里加入:

    nmap <Leader>y :!ici <C-R><C-W><CR>

在单词上按`\ y`就可以查单词了


### tmux

```
set-window-option -g mode-keys vi
bind -t vi-copy 'v' begin-selection
bind -t vi-copy y copy-pipe "xargs -I{} tmux split-window 'ici {};echo "... Press any key to exit ...";read'"
```

### Bash留个记录

我的习惯是放在`.bashrc`:

```bash
ici() {
        echo `date +%F` $1 >> ~/words
        /usr/local/bin/ici $1
}
```

## ydcv

肥猫写的`ydcv`也很不错:

```
wget https://raw.githubusercontent.com/felixonmars/ydcv/master/ydcv.py
```

## 有道版

以下代码不是原创, 转载自哪里我给忘记了. 

我的用法是, 把下面的代码放在`/usr/local/bin/y`里面

```python
#! /usr/bin/python
import re
import urllib
import urllib2
import sys

GREEN = "\033[1;32m"
DEFAULT = "\033[0;49m"
BOLD = "\033[1m"
UNDERLINE = "\033[4m"
NORMAL = "\033[m"
RED = "\033[1;31m"

textre = re.compile("\!\[CDATA\[(.*?)\]\]", re.DOTALL)

def debug():
    xml = open("word.xml").read()
    print get_text(xml)
    print get_elements_by_path(xml, "custom-translation/content")
    #print_translations(xml, False, False)

def get_elements_by_path(xml, elem):
    if type(xml) == type(''):
        xml = [xml]
    if type(elem) == type(''):
        elem = elem.split('/')
    if (len(xml) == 0):
        return []
    elif (len(elem) == 0):
        return xml
    elif (len(elem) == 1):
        result = []
        for item in xml:
            result += get_elements(item, elem[0])
        return result
    else:
        subitems = []
        for item in xml:
            subitems += get_elements(item, elem[0])
        return get_elements_by_path(subitems, elem[1:])

def get_text(xml):
    match = re.search(textre, xml)
    if not match:
        return xml
    return match.group(1)

def get_elements(xml, elem):
    p = re.compile("<" + elem + ">" + "(.*?)</" + elem + ">", re.DOTALL)
    it = p.finditer(xml)
    result = []
    for m in it:
        result.append(m.group(1))
    return result


def crawl_xml(queryword):
    return urllib2.urlopen("http://dict.yodao.com/search?keyfrom=dict.python&q="
        + urllib.quote_plus(queryword) + "&xmlDetail=true&doctype=xml").read()

def print_translations(xml, with_color, detailed):
        #print xml
    original_query = get_elements(xml, "original-query")
    queryword = get_text(original_query[0])
    custom_translations = get_elements(xml, "custom-translation")
    print BOLD + UNDERLINE + queryword + NORMAL
    translated = False
    
    for cus in custom_translations:
        source = get_elements_by_path(cus, "source/name")
        
        print RED + "Translations from " + source[0] + DEFAULT
        contents = get_elements_by_path(cus, "translation/content")
        if with_color:
            for content in contents[0:5]:
                print GREEN + get_text(content) + DEFAULT
        else:
            for content in contents[0:5]:
                print get_text(content)
        translated = True

    yodao_translations = get_elements(xml, "yodao-web-dict")
    printed = False

    for trans in yodao_translations:
        webtrans = get_elements(trans, "web-translation")

        for web in webtrans[0:5]:
            if not printed:
                print RED + "Translations from yodao:" + DEFAULT
                printed = True
                keys = get_elements(web, "key")
            values = get_elements_by_path(web, "trans/value")
            summaries = get_elements_by_path(web, "trans/summary")
            key = keys[0].strip()
            value = values[0].strip()
            #summary = summaries[0].strip()
            #lines = get_elements(summary, "line")

            if with_color:
                print BOLD +  get_text(key) + ":\t" +DEFAULT + GREEN + get_text(value) + NORMAL
                #for line in lines:
                #        print GREEN + get_text(line) + DEFAULT
                #print get_text(summary) + DEFAULT
            else:
                print get_text(value)
                #print get_text(summary)
                #translated = True
                #if not detailed:
                #break
    
def usage():
    print "usage: dict.py word_to_translate"

def main(argv):
    if len(argv) <= 0:
        usage()
        #debug()
        sys.exit(1)
    xml = crawl_xml(" ".join(argv))
    print_translations(xml, True, False)

if __name__ == "__main__":
    main(sys.argv[1:])

```
