#!/bin/bash
# 管理节点

# 0. 如果已经存在MySql，需要先删除
# manual now 
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64.tar.gz
# 1.2 move
cp -r ./mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64 /usr/local/mysql
# 1.3 chown & chgrp
cd /usr/local/mysql
echo $2 | sudo -S groupadd mysql
echo $2 | sudo -S useradd -g mysql mysql
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
    echo $2 | sudo -S sed -i '$a # PATH=$PATH:/usr/local/mysql/bin' /etc/profile
    echo $2 | sudo -S sed -i '$a # export PATH' /etc/profile
fi 
echo $PATH
# 2. mysql config
echo $2 | sudo -S cp /usr/local/mysql/bin/ndb_mgm* /usr/local/bin
echo $2 | sudo -S mkdir /var/lib/mysql-cluster
# 2.1 config.ini "/var/lib/mysql-cluster/config.ini"
echo $2 | sudo -S sed -i '/NoOfReplicas=/d' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '/ndbd default/a NoOfReplicas=1' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '/DataMemory=/d' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '/NoOfReplicas=1/a DataMemory=200M' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '/IndexMemory=/d' /var/lib/mysql-cluster/config.ini
echo $2 | sudo -S sed -i '/DataMemory=200M/a IndexMemory=20M' /var/lib/mysql-cluster/config.ini
# 2.2 my.cnf
