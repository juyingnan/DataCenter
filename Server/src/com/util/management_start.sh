#!/bin/bash
# 管理节点

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"
PASSWD=$3

# 启动管理节点
echo $PASSWD | sudo -S /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --initial --ndb-nodeid=1

# 启动数据节点
echo $PASSWD | sudo -S /usr/local/mysql/bin/ndbd --initial

# 启动SQL节点
echo $PASSWD | sudo -S echo $PASSWD | sudo -S 
