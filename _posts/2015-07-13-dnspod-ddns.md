---
layout: post
title:  "使用Bash+jq实现了一个简单的DNSPod动态域名(DDNS)"
date: 2015-07-13 11:13:00
---

Gist 见 <https://gist.github.com/4a34b7c032c87c9bc5c8>

{% highlight bash %}

# 1. Generate an API Token from dnspod.cn
# 2. create a record first
# 3. change $TMP_FILE
# 4. get your $DOMAIN_ID
# 5. change $NEW_IP generation method.
# 6. sudo apt-get install jq

 
TOKEN=12345,1234567890abcdef1234567890abcdef  #TODO: change this TOKEN.
TMP_FILE=/tmp/scateu.me.list  #TODO
 
# scateu.me 

DOMAIN_ID=12345678  #TODO: change this ID, you may get your domain ID using the following line.
#DOMAIN_ID=$(curl https://dnsapi.cn/Domain.List -d "login_token=$TOKEN&format=json" | jq ".domains[] | select(.name==\"scateu.me\") .id")
 
# Fetch scateu.me record list. 
curl -s https://dnsapi.cn/Record.List -d "login_token=$TOKEN&format=json&domain_id=$DOMAIN_ID" > $TMP_FILE

function UpdateDDNS {
        _ID=$1
        _OLD_IP=$2
        _NEW_IP=$3
        _DOMAIN_NAME=$4
        _DOMAIN_ID=$5
        _TOKEN=$6
    echo "#### $_DOMAIN_NAME #### "
    echo OLD_IP = $_OLD_IP
    echo NEW_IP = $_NEW_IP
 
    if [[ $_OLD_IP == $_NEW_IP ]]
    then 
        echo "IP didn't change, exit."
    else
        echo "Update IP"
        curl -s -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$_TOKEN&format=json&sub_domain=$_DOMAIN_NAME&domain_id=$_DOMAIN_ID&record_id=$_ID&value=$_NEW_IP&record_line=默认"
    fi
    echo 
    echo 
}
 
## 1. example1.scateu.me
DOMAIN_NAME=example
ID=$(echo $(jq ".records[] | select(.name==\"$DOMAIN_NAME\") .id"  $TMP_FILE) | sed -e 's/^"//' -e 's/"$//')
OLD_IP=$(echo $(jq ".records[] | select(.name==\"$DOMAIN_NAME\") .value"  $TMP_FILE) | sed -e 's/^"//' -e 's/"$//')
NEW_IP=$(/sbin/ifconfig wlan0  |grep Mask | awk '{ print $2;}' |cut -d : -f 2) # TODO: change this line.
 
UpdateDDNS $ID $OLD_IP $NEW_IP $DOMAIN_NAME $DOMAIN_ID $TOKEN
 
## 2  example2.scateu.me
DOMAIN_NAME=example2
OLD_IP=$(echo $(jq ".records[] | select(.name==\"$DOMAIN_NAME\") .value"  $TMP_FILE) | sed -e 's/^"//' -e 's/"$//')
ID=$(echo $(jq ".records[] | select(.name==\"$DOMAIN_NAME\") .id"  $TMP_FILE) | sed -e 's/^"//' -e 's/"$//')
NEW_IP=$(/sbin/ifconfig eth0 |grep Mask | awk '{ print $2;}' | cut -d : -f 2)  # TODO: change this line.
 
UpdateDDNS $ID $OLD_IP $NEW_IP $DOMAIN_NAME $DOMAIN_ID $TOKEN

{% endhighlight %}
