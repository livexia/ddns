#!/bin/sh
if [ $# -eq 2 ]
then
    echo "Reading hostname,key and ip from config file: "$2
    HE_HOSTNAME=$(sed -n '1p' $2)
    HE_KEY=$(sed -n '2p' $2)
    OLD_IP=$(sed -n '3p' $2)
    IP=$(ifconfig | grep inet6 | grep -v fe | grep -v ::1 | cut -d' ' -f2|awk '{print $1}')
    if [ "$IP" = "$OLD_IP" ]
    then
        echo "IP is same as before, do nothing"
    else
        sed -i -e '$d' $2
        echo $IP >> $2
        python ddns.py $HE_HOSTNAME $HE_KEY $IP
    fi
else
    echo "Usage ./ddns.sh -c [config.json]"
fi