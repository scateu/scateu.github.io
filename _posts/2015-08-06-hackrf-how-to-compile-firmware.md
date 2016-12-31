---
layout: post
title:  "HackRF固件更新及编译环境搭建"
date: 2015-08-06 18:42:00
---

## 1 HackRF Host 软件更新

```bash
git pull
cd host
mkdir build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
```


## 2 HackRF固件更新

如果不想自己编译固件, 可以直接从<https://github.com/mossmann/hackrf/releases>把最新打好的包下载下来, 解压, 里面有`firmware-bin`目录, 是已经编译好的固件. 

更新Flash:

```bash
hackrf_spiflash -w hackrf_one_usb_rom_to_ram.bin
```

更新CPLD:

```bash
hackrf_cpldjtag -x hackrf_cpld_default.xsvf
```


## 3 HackRF固件编译环境搭建

dfu-util: 需要从代码中checkout编译安装, 由于兼容性问题, 目前只能使用0.7版本的dfu-util, 见[Issue](https://github.com/mossmann/hackrf/issues/117)

```bash
git clone https://github.com/rad1o/dfu-util.git
git log --grep "Release 0.7"
git checkout 4e312c5567a84f76654295c267ec35f71727fe5a
./autogen.sh
./configure
make
sudo make install
```

安装yaml

```bash
sudo apt-get install python-yaml
```

由于gcc-arm-none-eabi是i386架构的, 所以需要i386运行时

```bash
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libgcc1:i386 gcc-4.6-base-i386 libstdc++5:i386 libstdc++6:i386
```

从Launchpad上下载[gcc-arm-none-eabi](https://launchpad.net/gcc-arm-embedded/+download), 解压到任意的路径中. 注意, Debian源里的`gcc-arm-none-eabi`貌似不能用. 

然后在`.bashrc`里加入路径:

```bash
export PATH=$PATH:/path/to/gcc-arm-none-eabi-4_9_2015q2/bin
```


接下来就可以编译了, 记得要先把libopencm3拉下来编译. 参阅[此处](https://github.com/mossmann/hackrf/blob/master/firmware/README). 

```bash
git submodule init
git submodule update
cd firmware/libopencm3
make
```

编译固件并写入

```bash
cd firmware/hackrf_usb
mkdir build
cmake .. -DBOARD=HACKRF_ONE
make
hackrf_spiflash -w hackrf_usb.bin
```

### 3.1 DFU 测试

```bash
cmake .. -DBOARD=HACKRF_ONE -DRUN_FROM=RAM
cd hackrf/firmware/build/blinky
dfu-util --device 1fc9:000c --alt 0 --download blinky.dfu
```

Tips: DFU mode.  If cannot find

```
1fc9:000c NXP Semiconductors
```

You may need to power the board up with `DFU` key pressed down, then press `reset` with `DFU` on.

## 4 参考

1. <https://github.com/mossmann/hackrf/wiki/Updating-Firmware>
2. [jiaoxianjun的博客](http://sdr-x.github.io/Notes%20on%20DFU%20mode%20and%20firmware%20of%20hackrf/)


## 片尾广告

如果想来阿里移动安全一起玩软件无线电, 欢迎扔简历给我. 
