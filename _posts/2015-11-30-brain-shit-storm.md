---
layout: post
title:  "最近开的几个脑洞"
date: 2015-11-30
---


## Slidecast

2019-07-22: See [Id3](http://id3.org/id3v2-chapters-1.0) and [overcast](https://overcast.fm/forecast)

As we know, podcast is a very convenient way to use your commute time to get some useful information.

Recently, we have published a non-commercial podcast called [Tunight](https://podcast.tuna.moe/), which collects interesting lectures and talks, aiming to provide a fast and easy way for those who cannot attend those activities to get an update.

For now, it runs well. 

Soon we found out that some lectures cannot be easily understood without slides from lecturer. So we managed to get slides from them afterwards, [like this lecture](https://podcast.tuna.moe/podcast/2015/11/LaTeX/).

But we are not satisfied still. There is no sync mechanism between audio and slides.

In fact, slideshare.net once provided a service called **Slidecast**, but it [died at year 2014](https://blog.slideshare.net/2014/02/07/slidecasts-to-be-discontinued/).

So, what I need now, is a good video encoder optimized for **Slidecast**.

It takes `Timestamps` , `PDF Slides`  and `Audio`, generates `Video` file to publish via podcast.

Why video? Because the best format podcast supports for 'Slidecast' is video. If we defined another standard just for 'Slidecast', I don't think it will get popular in short time. Plus, there are plenty of podcast clients on PC, Android, and iOS. 

What is `Timestamps`? I don't know yet. But my recorder seems to support T-Mark function when recording. I can press the T-Mark button when speakers flip over their slides. Basically `Timestamps` are pure text files.

The most important part is encoder. We need to find a effcient video encoder optimized for slides. We have to tune the   key frames distance of video encoder, so as to decrease video file size and increase video  quality. File size can be a big problem when podcasting. No one wants to subscribe a podcast episode with a 400MB video file with a fuzzy image. For example, [Camtasia](https://www.techsmith.com/camtasia.html) seems to have a customized video encoder for screencast. Maybe we can get some hints from them.


In summary:

    Timestamps (TXT) -+
    PDF Slides       -+----- Optimized Encoder (eg. in form of FFmpeg) --> Video  --> Publish via Podcast
    Audio            -+ 



## iCalendar Render Library for Javascript

I often attend open source activities offline, but remembering the date and location of those activities is not easy. 
In China, I just collect those information from mailing list, WeChat or Telegram, then add them to Calendar.app on my iPhone manually. 

There **is** a method to publish your activities on Internet, and it is called iCalendar, which is defined by RFC 2445. I can easily publish a public calendar using my iPhone via iCloud or via Google Calendar.  Though it is not very GNU, but so far so good, at least it works.

Then I want to display it on my blog or website.

After a few google clicks, I found out that there is already an ugly service called 'zetabee'.

You simply add a few lines of javascript, then you can render a public iCalendar subscription in your web page:

    <link rel="stylesheet" type="text/css" href="https://zetabee.com/icaljs/res/embed.css" />
    <div id="icjs"></div>
    <script>(function() {
     // Customize these as you wish
     var pastdays   = 0;       // # of past days to show (0 to 30)
     var futuredays = 60;      // # of future days to show (0 to 365)
     var cachemins  = 10;      // # of minutes to wait before refreshing calendar data (2 to 1440)
     var container  = "icjs";  // ID of div to embed calendar into
     // Do not change anything below this
     var s = document.createElement("script"); s.type = "text/javascript"; s.async = true; s.src = "https://zetabee.com/icaljs/embed?calid=RDU1a2ZIWlVyY0xzRDh0dHdWR1oxQT09&offset=-8&cachemins=" + cachemins + "&futuredays=" + futuredays + "&pastdays=" + pastdays + "&container=" + container;
     (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(s);
    })();</script>


But still you have to rely on the service provided by zetabee, and it is far from simple and beautiful.

What I propose is that we create a standalone javascript iCalendar render library to display published iCalendar links.


## Markdown extension for Jianpu (Numbered musical notation)

As we know, we have ABC notation or GNU Lilypond for music staff.
It takes ASCII as input and generates music scores and even MIDI format, which is very convenient for people to type music in computer. 

For example:

    X:1
    T:The Legacy Jig
    M:6/8
    L:1/8
    R:jig
    K:G
    GFG BAB | gfg gab | GFG BAB | d2A AFD |
    GFG BAB | gfg gab | age edB |1 dBA AFD :|2 dBA ABd |:
    efe edB | dBA ABd | efe edB | gdB ABd |
    efe edB | d2d def | gfe edB |1 dBA ABd :|2 dBA AFD |]


generates

![](https://upload.wikimedia.org/score/j/e/je0b6w9rgv4me8z70wxihq3pjvzpqt6/je0b6w9r.png)


However, most music amateurs use Jianpu, which use numbers as music notation. It is very handy and very fast to write Jianpu down to memorize popular songs. For now, there is no available Jianpu notation syntax.

So, what I would like to propose is a markdown syntax extension for Jianpu.

I will show a simple syntax protocol below.


    | 1 13 5 5 | 6 i6 5 5 | 3 3 53 1 | 6 13 5 - |
        --         --           --     . --

Hopefully it will generates a beautiful Jianpu format.


