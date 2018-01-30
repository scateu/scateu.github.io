---
layout: post
title:  "从1987年一直运行到现在的SDF.org"
date: 2016-09-25
ruby_notation: true
---

今天在网上[闲逛](https://www.youtube.com/watch?v=V5GpP5Eu1hA), 发现了一个很古老的UNIX公共服务器. 

SDF Public Access UNIX System - <http://sdf.org>

SDF 是 Super Dimension [Fortress]{要塞、堡垒} 的缩写. 

又名

<http://freeshell.org>

![](https://upload.wikimedia.org/wikipedia/commons/1/10/Bye-bye-leenox.png)

上面有MUD, 还有PINE(实际上是一个mutt的alias). 

机房的照片:

![](https://upload.wikimedia.org/wikipedia/commons/8/8d/SDF_Heart.jpg)

系统是NetBSD:

    faeroes:/> uname -a
    NetBSD faeroes 7.0.1_PATCH NetBSD 7.0.1_PATCH (GENERIC.201607220540Z) amd64


```
faeroes:/> help
SDF psh Version 8 - *PREVALIDATED SHELL ACCOUNT*

 what         - what can I use this account for?
 unix         - a listing of UNIX commands available to you NOW
 how          - information on increasing membership
 teach        - using SDF in a classroom setting
 dialup       - information about SDF dialup service
 arpa         - about lifetime arpa membership
 bboard       - sdf user message boards
 commode      - chat with other users online
 ysm          - chat on the ICQ network
 bsflite      - chat on the AIM network
 msnre        - chat on the MSN network
 ttytter      - listen to Twitter tweets anonymously
 lynx         - browse the WWW textually or access GOPHER
 bksp         - set your BACKSPACE key
 software     - display software programs installed on the system
 quote        - get a real time stock quote
 games        - a listing of available games
 thxmoo       - connect to the THXMOO
 mud          - connect to the SDFmud
 validate     - gain additional shell access (also try 'user' for details)
 
 
 faeroes:/> unix
UNIX command summary

 cd         {dir}  - Change Directory
 pwd               - print working (current) directory
 ls                - LiSt directory  (try ls -la)
 cat        {file} - conCATenate (view) a file
 mkdir      {name} - create a directory
 rm         {file} - remove a file or directory
 mv         {file) - move a file or directory
 chmod perm {file} - set permission bits for a file or directory
 edit       {file} - edit a file in your directory
 ps                - Process Status (try ps -aux)
 passwd            - Change your password
 disk              - show current disk usage
 uptime            - show system status
 df                - print system storage
 freeirc           - IRC access is free on Sundays
 profiles          - Join the ASCII social network
 dict       {word} - query the online dictionary
 cal               - calendar (try 'cal 1752')
 finger     {user} - show info about a user (try who or w)
 chfn              - change your full name
 chsh              - change your shell
 ping       {host} - test network connectivity to a host
 traceroute {host} - view the route to a remote host
 man         {cmd} - read a manual page for a command.
 dig / host        - DNS utilities
 geoip             - Country lookup on an IP
 expire            - calculate your account expiration
 domains           - list domains available for use on SDF
 mkhomepg          - manage your own webpage space
 mkgopher          - manage your own gopherspace
 upload            - upload a file using ZMODEM (works w/ TeraTERM)
 com               - multiuser online chat
 msg        {user} - send a message to another user online
 bboard            - bulletin board
 faq               - frequently asked questions
 mail              - read/send email (also try http://webmail.freeshell.org)
 lynx        {url} - browse webpages
 links       {url} - browse webpages (w/ frames support)
 gopher      {url} - browse gopherspace
 talk       {user} - talk to another user
 url        {user} - look up a user's URL
 ysm               - chat on the ICQ network
 pkg_info          - list ported/installed software packages
 whois    {domain} - query the INTERNIC WHOIS database
 logout            - logoff
```
 
 试了一下, 上面的电子邮件和外界居然还是互通的. 
 
 在上面的bboard里还找到了一个gopher讨论区, 标题是Who needs HTTP..
 


## 欢迎邮件

```
Date: Sun, 25 Sep 2016 08:08:59 GMT
From: SDF newuser <new@sdf.org>,
To: scateu@sdf.org
Subject: Welcome to the Super Dimensional Fortress - READ THIS

[24-Jul-96]

          ---------------------------------------------------------
                 SDF Public Access UNIX System Starter Guide
          ---------------------------------------------------------

   First, Welcome to the only all 64bit public access super computing center!

       To connect SDF via TELNET/SSH use the 'tty.sdf.org' address

   Here are some tips for getting around in your new UNIX shell environment.
   It is IMPORTANT that you read this email in order to make full use of the
   computing facilities here.  You may want to save this in your directory
   on the SDF-1 for future reference.  Also, if you'd like a FREESHELL bumper
   sticker, checkout http://sdf.lonestar.org (click on the 'tour' link)

     IN THE EVENT OF AN OUTAGE CHECK http://www.lonestar.org FOR UPDATES
     Also, you can read about scheduled maintenance on bboard:<ANNOUNCE>
  
   ALSO NO OTHER, NOT EVEN AN ADMINISTRATOR SHOULD EVER NEED YOUR PASSWORD!

          ---------------------------------------------------------

"maint"   This is the maintenance shell which allows you to manage your
          password, set up automatic password recovery, reset your mysql
          database password, reset your webmail preferences, change your
          shell, change your user information .. just about everything!

"arpa"    Prints information about becoming a permanent 'ARPA' member
          of SDF allowing you to use irc, lynx, increased space and more!

"help"    Runs a program that will allow you to access files containing 
          descriptive listings for standard and non-standard UNIX commands.

"com"     Chat with other SDF users in 'COM MODE'.

"bboard"  SDF-1 hosts an Electronic Bulletin Board which allows its users to
          communicate with each other.  Here you will find news regarding the
          system and whatever the users choose to talk about. 
         
"faq"     Frequently Asked Questions.  This program will allow you to access
          files containing more detailed help.  If you don't find an answer
          there, you may submit your own questions if you feel that it should
          be addressed in the FAQ.  You will be answered by an SDF-1 System  
          Administrator.

"freeirc" IRC access is available to all users on Weekends.

"online"  Online can tell you the amount of time a user (or yourself) has
          spent online for the day.  (Logs are stored and reset at 00:00:00).

"disk"    This utility will give you a pretty summary of how much space you
          are currently using.

          ---------------------------------------------------------
                     Files and Directories of Importance
          ---------------------------------------------------------

/etc/motd  This file's contents are listed every time you execute the login
           program when you login to your account.  It will be empty normally.
           It is used to broadcast time critical important information from
           the SDF-1 System Administrators that can't wait for the bboard.

~ftp/pub   Public files are stored here.  Text, source and binaries for all
           sorts of computers, including newer microprocessor style machines.

/usr/pkg   All user contributed executable programs and scripts can be found
           here.  If you want to compile a program for use of the entire 
           user group, please contact a System Administrator for details.

          ---------------------------------------------------------

  Usage statistics are logged and are made available to all users.  We hope
  that this open system will encourage users to help this resource grow.

          ---------------------------------------------------------
```

```
Date: Sun, 25 Sep 2016 08:08:59 GMT
From: SDF newuser <new@sdf.org>,
To: scateu@sdf.org
Subject: What is the Super Dimensional Fortress - READ THIS

[01] WHAT IS SDF?  (QUICK SUMMARY)

  Welcome to the only all 64bit public access supercomputing center!

  The Super Dimension Fortress is a networked community of free software
  authors, teachers, students, researchers, hobbyists,  enthusiasts and
  the blind.  It is operated as a federally recognised non-profit 501(c)7
  and is supported by its members.

  Our mission is to provide remotely accessible computing facilities for
  the advancement of public education, cultural enrichment, scientific
  research and recreation.  Members can interact electronically with each
  other regardless of their location using passive or interactive forums.
  Further purposes include the recreational exchange of information
  concerning the Liberal and Fine Arts.

  Members have access to games, email, usenet, chat, bboard, gopherspace,
  webspace, programming utilities, archivers, browsers, and more. The SDF
  community is made up of caring, highly skilled people who operate behind
  the scenes and in the underground to maintain a non-commercial INTERNET.

  While we did initially start out on a single computer in 1987, the
  SDF is now a network of 8 64bit enterprise class servers running
  NetBSD realising a combined processing power of over 21.1 GFLOPS!

  Our mass storage configuration is comprised of 60 spindles of mostly
  36.4gb and a few 9.1gb SCA LVD SCSI drives using DIGITAL Storage Works
  hotswap disk arrays.  We have roughly 2 terabytes of storage online.

  We are networked via two sprintlink T1s and a T1 to savvis.  We do BGP
  peering and try out best to load balance between the links via a CISCO
  7xxx router/switch.  We are using a 'swamp' class C 192.94.73 which has
  basically been assigned to our site admin along with his class C back 
  when you could request one from the INTERNIC without much fuss.

  The userbase is comprised of two major user groups:  USERS and ARPA

  'user' accounts are free and offer many features.
  'arpa' accounts are permanent members and can vote on SDF features.

  Supplemental ARPA privilidges include:

    MetaARPA  ('trusted' member privs (cron, tcp port forwarding))
    TWEAK     (tweakable and additional disk quota)
    VPM       (Virtual POP3 mailboxes)
    DNS       (Domain Name Service)
    DBA       (MySQL database access)
    VHOST     (Virtual Web hosting - includes VPM, DNS and DBA)
    SERVER    (Server process (mud, nameserver, et cetera))
    MDNS      (Dynamic DNS)
    MLIST     (Mailing List service)
    DIALUP    (over 10,000 numbers in the USA + Canada)

  Sponsorship information can be found on our website or in the FAQ.

```


## See Also

 - 2006年对创始人的采访: <http://bsdtalk.blogspot.com/2006/03/bsdtalk021-interview-with-stephen.html>
 - Wikipedia: <https://en.wikipedia.org/wiki/SDF_Public_Access_Unix_System>
 - NPR All Things Considered: [In Noisy Digital Era, 'Elegant' Internet Still Thrives](http://www.npr.org/2012/04/17/150817325/in-noisy-digital-era-elegant-internet-still-thrives)
   - [生词表](http://daixy.me/2012/04/17/all-things-considered-in-noisy-digital-era-elegant-internet-still-thrives.html)
 - BBS历史纪录片: <https://archive.org/details/bbsdocumentary>
 - [IEEE: The history of the BBS shows that pre-Internet social media was pretty great](http://spectrum.ieee.org/computing/networks/social-medias-dialup-ancestor-the-bulletin-board-system)
 - [Youtube: TWO TELETYPE MODEL 37s LINK FOR RELAY CHAT AT 150 BAUD](https://www.youtube.com/watch?v=MikoF6KZjm0)
 - [Youtube: Using a TTY Model 43 as a console on Linux]( https://www.youtube.com/watch?v=-Ul-f3hPJQM)

## TODO

 - [ ] 做个{SSH,TTY} over {RTTY, AFSK, DTMF, PSK31}
