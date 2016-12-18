---
title: "RAID演习记"
date: 2016-11-28
layout: post
---

## 背景

 - Buffalo LS-WVL
 - RAID1
 - 两块盘
 - 各1TB

## 检查

```bash
root@ubuntu:~/mnt# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Fri Dec 14 14:36:06 2012
     Raid Level : raid1
     Array Size : 961748840 (917.20 GiB 984.83 GB)
  Used Dev Size : 961748840 (917.20 GiB 984.83 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Mon Nov 28 21:41:47 2016
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : LS-WVL9BE:2
           UUID : 94d65994:7f391a0e:b959e3cc:407963fb
         Events : 6617621

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       38        1      active sync   /dev/sdc6
```

```bash
root@ubuntu:~/mnt# mdadm --examine /dev/sdc5
/dev/sdc5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : f245bd1b:956cf823:2c2f8665:629c2eec
           Name : LS-WVL-EM9BE:10
  Creation Time : Fri Dec 14 14:20:07 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 2000872 (977.15 MiB 1024.45 MB)
     Array Size : 1000436 (977.15 MiB 1024.45 MB)
    Data Offset : 24 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f5f2f22d:b1144de0:9a190acb:5c808f34

    Update Time : Mon Nov 28 21:11:40 2016
       Checksum : d2c31913 - correct
         Events : 40287


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

```

```bash
root@ubuntu:~/mnt# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md2 : active raid1 sdc6[1]
      961748840 blocks super 1.2 [2/1] [_U]
      
md10 : active raid1 sdd5[0] sdc5[1]
      1000436 blocks super 1.2 [2/2] [UU]
      
md1 : active raid1 sdc2[1]
      4999156 blocks super 1.2 [2/1] [_U]
      
md0 : active raid1 sdc1[1]
      1000384 blocks [2/1] [_U]
      
unused devices: <none>
```

```bash
root@ubuntu:~# mdadm --detail --scan
ARRAY /dev/md0 metadata=0.90 spares=1 UUID=6664ed44:3a6468f0:fc4e250d:63bd81ed
ARRAY /dev/md/1 metadata=1.2 spares=1 name=LS-WVL-EM9BE:1 UUID=915ffb58:2777fdc1:e33a57b8:b0a1cd76
ARRAY /dev/md/10 metadata=1.2 name=LS-WVL-EM9BE:10 UUID=f245bd1b:956cf823:2c2f8665:629c2eec
ARRAY /dev/md/2 metadata=1.2 spares=1 name=LS-WVL9BE:2 UUID=94d65994:7f391a0e:b959e3cc:407963f
```

## 正常情况: 插两块盘挂载

```bash
mdadm --assemble --scan
mkdir mnt/{0,1,10,2}

mount /dev/md0 mnt/0/
mount /dev/md1 mnt/1/
mount /dev/md2 mnt/2/
mount /dev/md10 mnt/10/ #挂载不上去
```

## 异常情况: 两个RAID1, 只插一块盘, 挂载

```bash
mdadm --stop /dev/md{0,1,10,2}
mdadm --assemble --scan
mount -o rw /dev/md2 mnt/2/
```


## 再插回来两块盘

由于上一步往里写了一些数据, 两块盘插回来状态已经是`degraded`了. 

```bash
root@ubuntu:~/mnt# mdadm -A --scan
mdadm: /dev/md0 is already in use.
mdadm: /dev/md/1 is already in use.
mdadm: /dev/md/2 has been started with 1 drive (out of 2).
mdadm: /dev/md0 is already in use.
mdadm: /dev/md/1 is already in use.
```

```bash
root@ubuntu:~/mnt# mdadm -D /dev/md2                                                                                                                                                                                                         
/dev/md2:
        Version : 1.2
  Creation Time : Fri Dec 14 14:36:06 2012
     Raid Level : raid1
     Array Size : 961748840 (917.20 GiB 984.83 GB)
  Used Dev Size : 961748840 (917.20 GiB 984.83 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Mon Nov 28 21:41:47 2016
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : LS-WVL9BE:2
           UUID : 94d65994:7f391a0e:b959e3cc:407963fb
         Events : 6617621

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed <---这里
       1       8       38        1      active sync   /dev/sdc6
```

```bash
root@ubuntu:~/mnt# mdadm --manage /dev/md2  -a /dev/sdd6
mdadm: added /dev/sdd6
```

```bash
root@ubuntu:~/mnt# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Fri Dec 14 14:36:06 2012
     Raid Level : raid1
     Array Size : 961748840 (917.20 GiB 984.83 GB)
  Used Dev Size : 961748840 (917.20 GiB 984.83 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Nov 28 22:03:55 2016
          State : clean, degraded, recovering 
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 0% complete

           Name : LS-WVL9BE:2
           UUID : 94d65994:7f391a0e:b959e3cc:407963fb
         Events : 6617623

    Number   Major   Minor   RaidDevice State
       2       8       54        0      spare rebuilding   /dev/sdd6
       1       8       38        1      active sync   /dev/sdc6
```

估计要重建很久. 

看一下速度:

```bash
root@ubuntu:~/mnt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md2 : active raid1 sdd6[2] sdc6[1]
      961748840 blocks super 1.2 [2/1] [_U]
      [>....................]  recovery =  0.5% (4856512/961748840) finish=1132.9min speed=14076K/sec
      
md10 : active raid1 sdd5[0] sdc5[1]
      1000436 blocks super 1.2 [2/2] [UU]
      
md1 : active raid1 sdc2[1]
      4999156 blocks super 1.2 [2/1] [_U]
      
md0 : active raid1 sdc1[1]
      1000384 blocks [2/1] [_U]
      
unused devices: <none>
```

此部分参考: <https://www.thomas-krenn.com/en/wiki/Mdadm_recover_degraded_Array>


## 番外篇: RAID5 演练

留作习题. 以下给出一些提示. 


观察所有的状态

```
watch lsblk
watch cat /proc/mdstat
watch sudo mdadm -D /dev/md0
```

```
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --spare-devices=1 /dev/sde1
mdadm --assemble --scan
# 也可以加个 --no-degrade开关

mdadm -D --scan >> /etc/mdadm/mdadm.conf #先备份一下组合的UUID什么的
```

比如RAID5, 一共3个U盘, 插了2个, 可以工作在degrade模式, 照常读写. 插上第3个之后, 要重新 

```
mdadm --manage --add /dev/md0 /dev/sdX
```

RAID5, 3个, 再加一个, 第4个可以成为热备, 拔掉其中一个, 过不久就会自动进行spare rebuild


还可以把某一个用`mdadm --manage --replace /dev/md0 /dev/sdX`标记为replace, 这样就会先去在热备的盘上进行rebuild, 完了之后就把标记为replace的盘, 标记成failed. 接着再把它remove就行. 

详见:

```
mdadm --manage --help
```


反正感觉上就是那个mdadm的daemon得一直活着. 如果要把整个阵列拿下去的话, 要

```
mdadm --stop /dev/md0
```

再物理拔掉. 

找几个U盘试一下就踏实多了... 以前一直小心翼翼的不敢动

PS: 我是拿4G/4G/16G组RAID5, 阵列可用8G.  试图向里面加一个2G的盘, 提示容量过小不可添加. 

## See Also

 - [macOS上使用RAID](http://www.macworld.com/article/3095835/storage/how-to-configure-a-software-raid-in-macos-sierra-s-disk-utility.html)
   - `diskutil list`
   - `diskutil AppleRAID create stripe MyBigNewRaid JHFS+ disk4 disk5`
   - 第三方的[SoftRAID](http://www.softraid.com/pages/quicklinks/#ar-orphan)操作更友好一些, 可惜收費
 - [Kernel.org的Wiki](https://raid.wiki.kernel.org/index.php/RAID_setup#XFS)

