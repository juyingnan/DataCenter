#!/bin/bash
# 管理节点

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"

PASSWD=$3

# 0. 如果已经存在MySql，需要先删除
echo $PASSWD | sudo -S apt-get -y purge mysql-*
echo $PASSWD | sudo -S apt-get -y install libaio-dev expect
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64.tar.gz
# 1.2 move
echo $PASSWD | sudo -S mv ./mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64 /usr/local/mysql
# 1.3 chown & chgrp
cd /usr/local/mysql
echo $PASSWD | sudo -S addgroup mysql
echo $PASSWD | sudo -S useradd -g mysql mysql
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
    echo $PASSWD | sudo -S PATH=$PATH:/usr/local/mysql/bin
    echo $PASSWD | sudo -S export PATH
fi 
echo $PATH
# 2. mysql config
echo $PASSWD | sudo -S cp /usr/local/mysql/bin/ndb_mgm* /usr/local/bin
echo $PASSWD | sudo -S mkdir /var/lib/mysql-cluster
# 2.1 config.ini "/var/lib/mysql-cluster/config.ini"
echo $PASSWD | sudo -S touch /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S chmod 666 /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S echo "" >/var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [ndbd default]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '1d' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a NoOfReplicas=1' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a DataMemory=200M' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a IndexMemory=20M' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [ndb_mgmd]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a NodeId=1' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a hostname='"$1" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a datadir=/var/lib/mysql-cluster/' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [ndbd]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a NodeId=2' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a hostname='"$1" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a datadir=/usr/local/mysql/data/' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a hostname='"$1" /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $PASSWD | sudo -S chmod 644 /var/lib/mysql-cluster/config.ini
# 2.2 my.cnf
echo $PASSWD | sudo -S touch /etc/my.cnf
echo $PASSWD | sudo -S chmod 666 /etc/my.cnf
echo $PASSWD | sudo -S echo "" >/etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a [mysqld]' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '1d' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a ndbcluster' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a datadir=/usr/local/mysql/data' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a basedir=/usr/local/mysql' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a port=3306' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a [mysql_cluster]' /etc/my.cnf
echo $PASSWD | sudo -S sed -i '$a ndb-connectstring='"$1" /etc/my.cnf
echo $PASSWD | sudo -S chmod 644 /etc/my.cnf
