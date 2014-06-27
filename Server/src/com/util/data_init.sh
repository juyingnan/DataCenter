#!/bin/bash
# 数据节点

auto_smart_scp () {
expect -c "set timeout -1;
spawn scp $2 $3;
expect {
*assword:* {send -- $1\r;
expect {
*denied* {exit 2;}
eof}
} eof
{exit 1;}
}
"
 }

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"
echo "REMOTEIP=$4"
echo "REMOTEUSERNAME=$5"
echo "REMOTEPASSWD=$6"

PASSWD=$3

# 0. 如果已经存在MySql，需要先删除
# manual now
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64.tar.gz
# 1.2 move
echo $PASSWD | sudo -S cp -r ./mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64 /usr/local/mysql
# 1.3 chown & chgrp
cd /usr/local/mysql
echo $PASSWD | sudo -S addgroup mysql
echo $PASSWD | sudo -S adduser --ingroup mysql mysql
echo $PASSWD | sudo -S chown -R root .
echo $PASSWD | sudo -S chown -R mysql ./data
echo $PASSWD | sudo -S chgrp -R mysql .
# 1.4 install
cd scripts/
echo $PASSWD | sudo -S ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
# 1.5 auto start config
cd /usr/local/mysql
echo $PASSWD | sudo -S cp support-files/mysql.server /etc/init.d/mysqld
echo $PASSWD | sudo -S mkdir -p /var/mysql/data
echo $PASSWD | sudo -S mkdir -p /var/mysql/logs
if [ `cat /etc/profile | grep -c 'PATH=$PATH:/usr/local/mysql/bin'` != 0 ] ;then
    echo "/etc/profile needs no change"
else
    echo "/etc/profile needs changes"
    echo $PASSWD | sudo -S sed -i '$a PATH=$PATH:/usr/local/mysql/bin' /etc/profile
    echo $PASSWD | sudo -S sed -i '$a export PATH' /etc/profile
fi
echo $PATH
# 2. mysql config
# 2.1 my.cnf
auto_smart_scp $6 $5@$4:/etc/my.cnf /tmp
echo $PASSWD | sudo -S cp /tmp/my.cnf etc/my.cnf
