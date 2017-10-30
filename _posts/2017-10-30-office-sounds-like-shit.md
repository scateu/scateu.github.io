---
title: "开放办公区 - 吵喜你"
date: 2017-10-30
layout: post
---

最近实在是被开放办公区吵惨了。戴上耳机也不行，因为有时候并不想听音乐，只想安静地想想事情。

我给你们演示一下...

<script>
var audio = [];
audio.push(new Audio('{{ site.imageurl }}/ringringring/ios_notification.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_note_sms.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_sms_original.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/iphone_ding_ding.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/xiaomi.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/wechat-call.mp3'));
audio.push(new Audio('{{ site.imageurl }}/ringringring/ding_message.mp3'));
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
	    var rand = Math.round(Math.random() * (3000 - 500)) + 500;
	    setTimeout(function() {
		                doSomething();
		                loop();  
		        }, rand);
}();


// https://stackoverflow.com/questions/6962658/randomize-setinterval-how-to-rewrite-same-random-after-random-interval
</script>

<input type="button" value="走你..."  onclick="javascript:loop()">
