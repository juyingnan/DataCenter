#!/bin/bash
# 管理节点

# 0. 如果已经存在MySql，需要先删除
# manual now 
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64.tar.gz
# 1.2 move
echo $2 | sudo -S cp -r ./mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64 /usr/local/mysql
# 1.3 chown & chgrp
cd /usr/local/mysql
echo $2 | sudo -S addgroup mysql
echo $2 | sudo -S adduser --ingroup mysql mysql
echo $2 | sudo -S chown -R root .
echo $2 | sudo -S chown -R mysql ./data
echo $2 | sudo -S chgrp -R mysql .
# 1.4 install
cd scripts/
echo $2 | sudo -S ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
# 1.5 auto start config
echo $2 | sudo -S chmod +x /etc/rc.d/init.d/mysqld
echo $2 | sudo -S chkconfig --add mysqld
if [ `cat /etc/profile | grep -c 'PATH=$PATH:/usr/local/mysql/bin'` != 0 ] ;then
    echo "/etc/profile needs no change"
else
    echo "/etc/profile needs changes"
    echo $2 | sudo -S sed -i '$a PATH=$PATH:/usr/local/mysql/bin' /etc/profile
    echo $2 | sudo -S sed -i '$a export PATH' /etc/profile
fi 
echo $PATH
# 2. mysql config
echo $2 | sudo -S cp /usr/local/mysql/bin/ndb_mgm* /usr/local/bin
echo $2 | sudo -S mkdir /var/lib/mysql-cluster
# 2.1 config.ini "/var/lib/mysql-cluster/config.ini"
echo $2 | sudo -S touch /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [ndbd default]' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a NoOfReplicas=1' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a DataMemory=200M' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [ndb_mgmd]' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a NodeId=1' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i "$a hostname=$1" /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a datadir=/var/lib/mysql-cluster/' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [ndbd]' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a NodeId=2' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i "$a hostname=$1" /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a datadir=/usr/local/mysql/data/' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i "$a hostname=$1" /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '$a [mysqld]' /var/lib/mysql-cluster/config.ini
# 2.2 my.cnf
