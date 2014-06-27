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


# 0. 如果已经存在MySql，需要先删除
# manual now
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64.tar.gz
# 1.2 move
echo $5 | sudo -S cp -r ./mysql-cluster-gpl-7.3.5-linux-glibc2.5-x86_64 /usr/local/mysql
# 1.3 chown & chgrp
cd /usr/local/mysql
echo $5 | sudo -S addgroup mysql
echo $5 | sudo -S adduser --ingroup mysql mysql
echo $5 | sudo -S chown -R root .
echo $5 | sudo -S chown -R mysql ./data
echo $5 | sudo -S chgrp -R mysql .
# 1.4 install
cd scripts/
echo $5 | sudo -S ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
# 1.5 auto start config
echo $5 | sudo -S chmod +x /etc/rc.d/init.d/mysqld
echo $5 | sudo -S chkconfig --add mysqld
if [ `cat /etc/profile | grep -c 'PATH=$PATH:/usr/local/mysql/bin'` != 0 ] ;then
    echo "/etc/profile needs no change"
else
    echo "/etc/profile needs changes"
    echo $5 | sudo -S sed -i '$a PATH=$PATH:/usr/local/mysql/bin' /etc/profile
    echo $5 | sudo -S sed -i '$a export PATH' /etc/profile
fi
echo $PATH
# 2. mysql config
# 2.1 my.cnf
auto_smart_scp $3 $2@$1:/etc/my.cnf /tmp
echo $5 | sudo -S cp /tmp/my.cnf etc/my.cnf
