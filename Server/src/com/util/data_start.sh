#!/bin/bash
# 数据节点

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"
PASSWD=$3

# 启动管理节点
# echo $PASSWD | sudo -S /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --initial --ndb-nodeid=1

# 启动数据节点
echo $PASSWD | sudo -S /usr/local/mysql/bin/ndbd --initial

# 启动SQL节点
echo $PASSWD | sudo -S service mysqld start

# 返回结果
#RESULT=`/usr/local/bin/ndb_mgm -e "show;" | grep -c "$1" `
#if [ $RESULT != 4 ] ;then
#     echo "FAILED!"
#else
#     echo "SUCCESSFUL!"
#fi 
