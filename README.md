## My extra customization


### MathJax

```yaml
---
title: "Some Title" 
mathjax: true
---
```

eg:

```
$$ c = m^e \mod n $$
```

```
$$
 m^{ed} \equiv qq^{-1}m + pp^{-1}m  \\
   = (1 - k_1p)m + (1 - k_2q)m  \\
   = 2m - (k_1p+k_2q)m = m \mod pq 
$$
```

### Ruby Notation

```yaml
---
title: "Some Title"
ruby_notation: true
---
```

which converts

```
[someword]{释义}
```

to:

```
<ruby><rb><a href="http://www.thefreedictionary.com/someword"> someword </a> </rb><rp>(</rp><rt>释义</rt><rp>)</rp></ruby>
```

<ruby><rb><a href="http://www.thefreedictionary.com/someword"> someword </a> </rb><rp>(</rp><rt>释义</rt><rp>)</rp></ruby>

### Collapsible Table of Contents

Currently, can't exist as a switch of YAML frontmatter. (TODO)

```html
<details markdown="1"><summary>目录</summary>
* TOC
{:toc}
</details>
```

### Collapsible Block

	<details markdown="1"><summary>详细点此展开</summary>
	```python
	import sys
	print "hello"
	```
	</details>

<details markdown="1"><summary>详细点此展开</summary>
```python
import sys
print "hello"
```
</details>


### diagram

```yaml
---
title: "Some Title"
diagram: true
---
```

sequence语法见: <https://bramp.github.io/js-sequence-diagrams/>
	
	```sequence
	participant Device
	participant Browser
	participant Server
	Browser->Server: username and password
	Note over Server: verify password
	Note over Server: generate challenge
	Server->Browser:  challenge
	Browser->Device: challenge
	Note over Device: user touches button
	Device-->Browser: response
	Browser->Server: response
	Note over Server: verify response
	```

flowchart语法见: <http://flowchart.js.org/>

	```flowchart
	st=>start: Start:>http://www.google.com[blank]
	e=>end:>http://www.google.com
	op1=>operation: My Operation
	sub1=>subroutine: My Subroutine
	cond=>condition: Yes
	or No?:>http://www.google.com
	io=>inputoutput: catch something...

	st->op1->cond
	cond(yes)->io->e
	cond(no)->sub1(right)->op1
	```

### fix-punctuation.sh

用`sed`把中文全角符号转换成`, ` `. ` `; ` `! ` `"` 这样的半角符号. (张贤科老师的教材中多用`. `号)
