---
layout: post
title: 使用xchat+bip实现IRC的不间断工作
date: 2014/06/03 00:46:17
---

# 使用xchat+bip实现IRC的不间断工作

参考这一篇文章 https://wiki.linaro.org/Resources/HowTo/BIP 
    
    
    mkdir ~/.bip && cd ~/.bip
    openssl req -new -newkey rsa:4096 -nodes -x509 -keyout bip.pem -out bip.pem
    chmod 600 bip.pem

    ip = "0.0.0.0"; 
    port = 7778; 
    client_side_ssl = true; 
    log_level = 3;
    
    network {
        name = "freenode";
        server { host = "irc.freenode.net"; port = 6667; };
    };
    
    user {
        name = "_你的名字_";
        password = "<使用bipmkpw生成bip密码>"; 
        admin = true;
        ssl_check_mode = "none";
        ssl_check_store = "/home/_你的名字_/.bip/trustedcerts.txt";
    
        default_nick = "_你的名字_";
        default_user = "_你的名字_";
        default_realname = "_你的名字_";
    
        backlog = true;     # enable backlog
        backlog_lines = 0;      # number of lines in backlog, 0 means
        backlog_always = false;     # backlog even lines already backlogged
    
        backlog_msg_only = true;
    
        connection { name = "freenode";     # used by bip only
            network = "freenode";   # which ircnet to connect to 
            channel { name = "#hackrf,#bladerf,#tuna,#fedora-zh,#ubuntu-cn,#gnuradio,#ubuntu-devel,#debian-devel"; };
        };
    };

 
    
    
    $ tail .xchat2/servlist_.conf 
    
    N=BIP-Freenode
    P=scateu:密码:freenode
    B=Freenode的密码 #此行可省
    E=IRC (Latin/Unicode Hybrid)
    F=47
    D=0
    S=<服务器地址>/7778

然后可以在xchat的频道上右键, 把Join信息给Hide掉. 