---
title: "使用Shortcuts糊一个全局Text Capture框+macOS输入法切换提速"
date: 2026-06-04
layout: post
---

# 使用Shortcuts手糊一个全局Text Capture Box

目标: 仿Org Mode的`C-c C-c`全局Capture，任何地方呼出它，把当前脑子里的想法写进去，自动Append到一个文本文件，并打上时间戳

现有方案:
 - iA Writer提供了一个Shortcuts示例
 - Taskpaper用户们使用的usetype.app，好使是好使，快捷键是`Control-Cmd-,`，但是加时间戳收费
 - Emacs的Org Mode是`C-c C-c`
 - Omnifocus的是`Control-Cmd-Space`
 - DEVONthink的是`Option-Space`

做法:
 - 新建一个Shortcuts 快捷指令
 - Ask for `Text` with `记入notes/inbox.txt ⌘↵确认`
 - Append `Current Date` (后面点Insert Variables再加一个) `Ask for Input` to `notes` 这里选一下目录
    - File Path: `inbox.txt`
    - Make New Line: [x]
    - `Current Date`里写成Date-Custom `**** [yyyy-MM-dd EEE HH:mm] ` 最后加个空格
 - 然后把它放进Dock里；或绑快捷键`Control-Cmd-,` 再把`Control-Cmd-.`绑到打开这个文件的快捷指令上

![]({{ site.imageurl }}/shortcuts-app-text-capture.png)

我的链接: <https://www.icloud.com/shortcuts/236b0b3fb0b74d7e9ce1aa43bc4a587e>

# 进一步，Append到Notes.app里

长话短说，有缺点，Notes.app在同步/后台的时候可能会存在不往里面append的情况.

可以考虑同时append到Notes.app和inbox.txt两份。

# 查词-Anki

<https://www.icloud.com/shortcuts/0e53823ae3e548ad9cf76485b258ab47>

```
Ask for  Text with 记入notes/anki.txt Cmd回车确认
Show definition of `Ask for Input`
Append `Ask for Input`
  File Path: `notes
  Make New Line: [x]
Open `Appended File` in `Default App`
```

我绑在了`Control-Cmd-/`

# Emacs Org Mode的Capture绑到Control-Cmd-Shift-C

```
Open URL: org-protocol://capture?template=j
```

> 史称 出门不捡个快捷键就算亏

回车和小写c在某些程序里不响应，只能绑个大写C了。

至此，Control Cmd系列:

 - `,` append to inbox.txt
 - `.` open inbox.txt
 - `/` append to anki.txt
 - `C` org capture

# macOS里切换输入法加速

     Keyboard Shortcuts > Input Sources > Select next source in Input Menu 绑成 `^Space`

>  from xiaq: 输入法我用 hammerspoon 绑了 cmd+1 2 3
