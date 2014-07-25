#!/bin/bash
# 管理节点

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"
echo "REMOTEIP=$4"
echo "REMOTEUSERNAME=$5"
echo "REMOTEPASSWD=$6"

PASSWD=$3

NUM=`/usr/local/bin/ndb_mgm -e "show;"|grep mysqld|awk '{print $2}' `
let NDBDID=$NUM*2-2

echo $PASSWD | sudo -S sed -i '$d' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$d' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [ndbd]' /var/lib/mysql-cluster/config.ini
# echo $PASSWD | sudo -S sed -i '$a NodeId='"$NDBDID" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a hostname='"$4" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a datadir=/usr/local/mysql/data/' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a hostname='"$4" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini

echo $PASSWD | sudo -S /usr/local/bin/ndb_mgm -e "1 stop;"
echo $PASSWD | sudo -S /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --reload
# echo $PASSWD | sudo -S /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --reload --ndb-nodeid=1
