---
layout: post
title: Linux编译FFmpeg, 支持x264和x265(HEVC) 
date: 2014/03/06 00:57:35
---

# Linux编译FFmpeg, 支持x264和x265(HEVC) 

[参考](http://www.linuxidc.com/Linux/2014-02/97266.htm) 

[Stackoverflow 参考](http://stackoverflow.com/questions/19634453/ffmpeg-how-to-generate-a-mp4-with-h-265-codec)

## 注意

cmake要升级要2.8.8 yasm要升级到1.2.0

## Stackoverflow的说法

http://stackoverflow.com/questions/19634453/ffmpeg-how-to-generate-a-mp4-with-h-265-codec

> FFmpeg supports encoding HEVC/H.265 since 2-12-2014 with libx265. Now you can use ffmpeg directly to encode HEVC or use another encoder than manually mux that into .mp4 using FFmpeg. Of course you can still use some patched FFmpeg build, but it is not recommended. To make matters more confusing, there are two independent projects both named "x265", one by a Chinese college student and is practically dead, and another by a commercial company called MulticoreWare. Although the former started out first, it is practically dead now, and the latter is under active development and is supported by VideoLAN (the developer of x264). Anyways, these are a complete set of current possibilities of encoding HEVC in order of my recommendation: Directly using MulticoreWare libx265 with FFmpeg. This means with the latest Zeranoe build you can now do this: ffmpeg -i INPUT -x265-params crf=25 OUT.mov Using standalone MulticoreWare x265 and then mux the resulting file with FFmpeg.
> 
> Using DivX HEVC Encoder and then mux it. Using standalone Chinese x265 then mux the resulting file with FFmpeg. Using patched FFmpeg with Chinese x265 support. Update: FFmpeg has HEVC encoding support using MulticoreWare libx265 now.

## 官方说明

<http://ffmpeg.org/general.html>

> External libraries x265 FFmpeg can make use of the x265 library for HEVC encoding. Go to http://x265.org/developers.html and follow the instructions for installing the library. Then pass --enable-libx265 to configure to enable it. x265 is under the GNU Public License Version 2 or later (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.html for details), you must upgrade FFmpeg’s license to GPL in order to use it.

## yasm 1.2.0
    
    
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
    tar zxvf yasm-1.2.0.tar.gz
    autoreconf -i 
    make
    sudo make install
    sudo ldconfig
    

## 安装x264
    
    
	git clone git://git.videolan.org/x264.git
	cd x264
	./configure --enable-static --disable-opencl --disable-avs 
	--disable-cli --disable-ffms --disable-gpac --disable-lavf
	--disable-swscale
	make
	sudo make install
	sudo ldconfig
    

## 安装x265
    
    
<https://bitbucket.org/multicoreware/x265/wiki/Home>
	
	sudo apt-get install mercurial cmake cmake-curses-gui build-essential
	# Note: if the packaged yasm is older than 1.2, you must download
	yasm-1.2 and build it

	hg clone https://bitbucket.org/multicoreware/x265
	hg checkout 0.8
	cd x265/build/linux
	./make-Makefiles.bash
	# 这里将 LOG_CU_STATISTICS　设置为ON, 然后, 按下"c", 实现configure, 按下"q"退出
	make
	sudo make install
	sudo ldconfig
    

## ffmpeg

<http://ffmpeg.org/download.html>
    
    
	./configure --enable-libx264 --enable-libx265 --enable-gpl
	make
	make install