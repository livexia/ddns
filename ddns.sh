#!/bin/sh
if [ $# -eq 2 ]
then
    echo "Reading hostname,key and ip from config file: "$2
    HE_HOSTNAME=$(sed -n '1p' $2)
    HE_KEY=$(sed -n '2p' $2)
    OLD_IP=$(nslookup -query=AAAA $HE_HOSTNAME | grep -i addr | grep -v \# | awk '{print $NF}')
    IP=$(ifconfig | grep inet6 | grep -v fe | grep -v ::1 | awk '{print $2}')
    echo $OLD_IP 
    echo $IP
    if [ "$IP" = "$OLD_IP" ]
    then
        echo "IP is same as before, do nothing"
    else
        python ddns.py $HE_HOSTNAME $HE_KEY $IP
    fi
else
    echo "Usage ./ddns.sh -c [config.json]"
fi