---
layout: post
title:  "OpenWRT中DHCP推送DNS地址"
date:   2014-11-30 15:42:00
---

如果希望将某一个DHCP的区域, 推送自定义的DNS服务器地址, 可以在`/etc/config/dhcp`里加入最后一行

	config dhcp 'lan'
	  option interface 'lan'
	  option start '100'
	  option limit '150'
	  option leasetime '12h'
	  option dhcpv6 'server'
	  option ra 'server'

	config dhcp 'wall'
	  option interface 'wall'
	  option start '100'
	  option limit '150'
	  option leasetime '12h'
  option dhcp_option '6,8.8.8.8,8.8.4.4'


这样, 凡是在`wall`区域的DHCP客户端就会都分配到`8.8.8.8,8.8.4.4`的DNS服务器地址的推送了. 
