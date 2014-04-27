#!/bin/bash
echo "Detect parameters"
echo $# " Parameters"
if [ $# -lt 10]; then
	echo "Usage: test.sh \tlocal_IP local_user_passwd local_mysql_passwd/"
	echo "\t\tremote_IP remote_username remote_user_passwd remote_mysql_passwd/"
	echo "\t\t'database1 database2 ...' 'tablecount table1 table2 table3...'"
else
	# Output all parameters
	LOCAL_IP=$1
	LOCAL_USER_PASSWD=$2
	LOCAL_MYSQL_PASSWD=$3
	REMOTE_IP=$4
	REMOTE_USER_USERNAME=$5
	REMOTE_USER_PASSWD=$6
	REMOTE_MYSQL_PASSWD=$7
	echo "local_IP:   " $LOCAL_IP
	echo "LOCAL_USER_PASSWD:   " $LOCAL_USER_PASSWD
	echo "local_mysql_passwd:   " $LOCAL_MYSQL_PASSWD
	echo "remote_IP:   " $REMOTE_IP
	echo "remote_username:   " $REMOTE_USER_USERNAME
	echo "REMOTE_USER_PASSWD:   " $REMOTE_USER_PASSWD
	echo "remote_mysql_passwd:   " $REMOTE_MYSQL_PASSWD
	# Output databases
	databases=($8)
	for v in ${databases[@]}
		do
			echo "database:   " "$v"
		done
    	# Output tables
    	tables=($9)
	for v in ${tables[@]}
		do
			echo "table:   " "$v"
		done

	# （1） vim /etc/mysql/my.cnf
	# 在【mysqld】下面填写3句话
	# server-id=1
	# log-bin=/var/log/mysql/mysql-test-bin.log
	# binlong-do-db=yewumasterslave(具体的数据库名，视具体情况而定)
	echo "********************"
	echo $2 | sudo -S cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
	echo "/etc/mysql/my.cnf backup created"
	echo "/etc/mysql/my.cnf mod start"
	echo $2 | sudo -S sed -i "/#server-id/c server-id=1" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/server-id/c server-id=1" /etc/mysql/my.cnf
	cat /etc/mysql/my.cnf | grep 'server-id'
	echo $2 | sudo -S sed -i "/#log_bin/c log_bin=/var/log/mysql/mysql-test-bin.log" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/log_bin/c log_bin=/var/log/mysql/mysql-test-bin.log" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/bind-address/c #bind-address = 127.0.0.1" /etc/mysql/my.cnf
	cat  /etc/mysql/my.cnf | grep log_bin
	echo $2 | sudo -S sed -i "/max_binlog_size/a binlog_do_db=${databases[0]}" /etc/mysql/my.cnf
	cat  /etc/mysql/my.cnf | grep ${databases[0]}
	echo "/etc/mysql/my.cnf mod end"
	echo "********************"

	#（3）service mysql restart
	echo $2 | sudo -s service mysql restart
	echo "service mysql restarted"
	
	#(4)grant all privileges on *.* to root@'%' identified by '';
	#孙明明  21:40:57
	#第四条是在mysql下执行
	mysql -uroot <<EOF
	grant all privileges on *.* to root@'%' identified by '';
	exit
EOF
	echo "grant all privileges on *.* to root@'%'"	
	#（5）在master机器上的mysql下：show master status;
	#孙明明  21:42:25
	#会得到类似
	#| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
	#+------------------+----------+--------------+------------------+
	#| mysql-bin.000017 |     8133 |        |                  |的一个表
	#记好file和position
	FILE=`mysql -uroot -e "show master status\G;" | awk '/File/ {print $2}'`
	echo "File = " $FILE 
	POSITION=`mysql -uroot -e "show master status\G;" | awk '/Position/ {print $2}'`
	echo "Position = " $POSITION
	
	#英男，在第五步后面应该有添加
	#在slave机器上 vi /etc/mysql/my.cnf
	#在mysqld下面添加
	#server-id=2
	#replicate-do-db=yewumasterslave(具体的数据库名)
	#replicate-do-table=yewumasterslave.dili1(需要部分同步的表名)
	#replicate-do-table=yewumasterslave.dili2（有几个表需要同步就添加几条）
	#service mysql restart
	#mysql下 grant all privileges on *.* to root@'%' identified by '';
auto_smart_ssh () {
    expect -c "set timeout -1;     
	spawn ssh -o StrictHostKeyChecking=no $2 ${@:3};  
	expect {
	*assword:* {send -- $1\r;       
	expect {  
	*denied* {exit 2;} 
	eof} 
      }  eof
      {exit 1;} 
	}    
	"      return $? 
 }  

	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup"    
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/#server-id/c server-id=2' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/server-id/c server-id=2' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat /etc/mysql/my.cnf | grep 'server-id'"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i 's/#log_bin/log_bin/g' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/bind-address/c #bind-address = 127.0.0.1' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat  /etc/mysql/my.cnf | grep log_bin"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/max_binlog_size/a replicate-do-db=${databases[0]}' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat  /etc/mysql/my.cnf | grep ${databases[0]}"

	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/#binlog_ignore_db/a replicate-do-table=${databases[0]}.${tables[0]}' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat  /etc/mysql/my.cnf | grep ${tables[0]}"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/#binlog_ignore_db/a replicate-do-table=${databases[0]}.${tables[1]}' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat  /etc/mysql/my.cnf | grep ${tables[1]}"

	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S service mysql restart" 
	echo -e "\n---Exit Status: $?"	

	#（6）在slave机器上的mysql下
	#stop slave;
	#mysql> change master to master_host='192.168.1.113',master_user='slave',master_password='slave',master_log_file='mysql-bin.000017',master_log_pos=8133
	#这里的master_log_file,master_log_pos的值配置为刚才的那张表里面对应的值
	#孙明明  21:47:15
	#master_host的值是主从同步的主的IP地址
	#然后start slave；
	#show slave status\G
	#孙明明  21:51:21
	#图里面的slave_IO_Running和Slave_SQL_Running都为yes表示配置成功
	MYSQLCMD="change master to master_host=${1},master_user=root,master_password=,master_log_file=$FILE,master_log_pos=$POSITION" 
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'stop slave\;'" 
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'change master to master_host=\"${1}\",master_user=\"root\",master_password=\"\",master_log_file=\"$FILE\",master_log_pos=$POSITION\;'" 
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'start slave\;'" 
	echo -e "\n---Exit Status: $?"	
fi