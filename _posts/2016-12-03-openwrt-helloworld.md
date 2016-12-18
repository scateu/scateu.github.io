---
title: "OpenWrt上用C来写一个Helloworld"
date: 2016-12-03 22:44:00
layout: post
---

陆续用OpenWrt已经有5年多了, 一直以来都没有勇气用OpenWrt写原生的C程序. 

OpenWrt本身是维护了一些菜谱(recipe), 表现形式是Makefile. 它里面定义了包名/描述/类别/上游等等信息.

`make menuconfig`的时候, 会先把`package/`目录里的所有包都扫描一遍, 生成总体的Makefile.

想单独编译这个包, `make package/your_package/compile`即可, 会生成到`bin/ar71xx/packages/base/your_package_blahblah.ipk`



## 一个最小的例子

最好在与目标固件在同一个编译树下面做以下事情, 否则可能会因为libc版本不一致导致程序无法运行. 

目录结构:

```
openwrt/package/helloworld
├── Makefile
└── src
    ├── helloworld.c
    └── Makefile
```

### 外层的 Makefile

```makefile
include $(TOPDIR)/rules.mk

PKG_NAME:=helloworld
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/helloworld
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Helloworld
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/helloworld/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/
endef

$(eval $(call BuildPackage,helloworld))
```

### src/helloworld.c

```c
#include <stdio.h>

int main(void)
{ 
	printf("hello world!\n");
	return 0;
}
```

### src/Makefile

```makefile
helloworld: helloworld.o
	$(CC) $(LDFLAGS) helloworld.o -o helloworld
helloworld.o: helloworld.c
	$(CC) $(CFLAGS) -c helloworld.c

clean:
	rm *.o helloworld
```

### 编译

```bash
make menuconfig 
# 把Utilities里的helloworld要么打M, 要么打*
make package/helloworld/compile
ls bin/ar71xx/packages/base/helloworld*.ipk

### 然后部署
scp bin/ar71xx/packages/base/helloworld*.ipk root@192.168.1.1:/tmp/
opkg install helloworld*.ipk
```

**注意**: `package/helloworld/src/`里的`.o`文件要被清理掉, 我之前有一次是在电脑上执行了`package/helloworld/src/`里的`make`, 结果报了一个`libc`相关的错误. 原因就是OpenWrt的make(mips)复用了里面的`.o`(x86_64).

## 用SDK来编译

用SDK编译的好处是不用把整个代码树clone下来, 省事, 优雅.

### 首先要选对SDK版本

注意一定要用对应的SDK版本, 否则`libc`的版本或者其它库的版本对不上, 尽管编译出ipk包, 扔上去会执行不了, 提示

```
# ./helloworld
 - ash: no file helloworld found
```

去[SDK](https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk)页面上下载, 例如: <https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2>

(或者用[TUNA的镜像: 示例](https://mirrors.tuna.tsinghua.edu.cn/openwrt/chaos_calmer/15.05.1/ar71xx/generic/OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2))

每个snapshot都会有对应的SDK可以下载, 同时, 也可以自己`make menuconfig`的时候生成一份SDK. 
(想必大家被坑过: 用snapshot版本, 结果后面snapshot更新了, 新的包拿下来无法使用....)

### 要装 gawk

```
sudo apt-get install gawk
```

否则会报错:

```
awk: include/scan.awk: line 21: function asort never defined
```

### feed update以及编译

以下摘自[shadowsocks-openwrt](https://github.com/shadowsocks/openwrt-shadowsock):

```bash
tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
cd OpenWrt-SDK-ar71xx-*

./scripts/feeds update packages
./scripts/feeds install libpcre

git clone https://github.com/shadowsocks/openwrt-shadowsocks.git package/shadowsocks-libev
make menuconfig
make package/shadowsocks-libev/compile V=99
```

### See also

 - <https://github.com/mwarning/openwrt-example-program.git>
 - <http://cn.wrtnode.com/w/?p=315>
 - 可以看一看[shadowsocks-openwrt](https://github.com/shadowsocks/openwrt-shadowsock)项目的Makefile写法
 - <http://stackoverflow.com/questions/29934574/how-to-cross-compile-a-c-file-for-openwrt>
 - <http://techfindings.one/archives/1487>
 - <https://wiki.openwrt.org/doc/devel/packages>
