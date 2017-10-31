---
title: "开放办公吵喜你"
date: 2017-10-30
layout: post
disable_disqus: true
---

最近实在是被开放办公区吵惨了。戴上耳机也不行，因为有时候并不想听音乐，只想安静地想想事情。

> 人的一切痛苦，本质上都是对自己无能的愤怒。

扔掉降噪耳机[^1]，打开这个，你就不痛苦了。

我给你们演示一下...

<script>
var audio = [];
_ios = new Audio('{{ site.imageurl }}/ringringring/ios_notification.mp3');
audio.push(_ios);
audio.push(_ios);
audio.push(_ios);
audio.push(_ios);
_ding_message = new Audio('{{ site.imageurl }}/ringringring/ding_message.mp3');
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(_ding_message);
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_note_sms.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_sms_original.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_ding_ding.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/xiaomi.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/wechat-call.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/ding.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/ding_voip.mp3'));

function choose(choices) {
	  var index = Math.floor(Math.random() * choices.length);
	  return choices[index];
}

function doSomething() {
	var _audio = choose(audio)
	_audio.volume = Math.random();
	_audio.play();
}

function loop() {
	    var rand = Math.round(Math.random() * (6000 - 1000)) + 1000;
	    setTimeout(function() {
		                doSomething();
		                loop();  
		        }, rand);
};

function start() { 
	doSomething();
	loop();
}


// https://stackoverflow.com/questions/6962658/randomize-setinterval-how-to-rewrite-same-random-after-random-interval
</script>

<input type="button" value="走你..."  onclick="start()">  &larr; 多点几下有惊喜

进一步，在使用过程中为了避免被溯源，我们推出了蓝牙版本。

实测效果，办公区寸草不生。

---

[^1]: 请扔到: 中国北京市朝阳区望京东园四区9号楼 绿地中心C座B1层小邮局 100102 
