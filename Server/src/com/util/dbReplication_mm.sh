#!/bin/bash
echo "Detect parameters"
echo $# " Parameters"
if [ $# -lt 9]; then
	echo "Usage: test.sh \tlocal_IP local_user_passwd local_mysql_passwd/"
	echo "\t\tremote_IP remote_username remote_user_passwd remote_mysql_passwd/"
	echo "\t\t'database1:database2 ...' 'table1:table2:table3...'"
else
	# Output all parameters
	LOCAL_IP=$1
	shift
	LOCAL_USER_NAME=$1
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
	databases=($(echo $8 | tr ':' ' ' | tr -s ' '))
	for v in ${databases[@]}
		do
			echo "database:   " "$v"
		done
	# Output tables
    	tables=($(echo $9 | tr ':' ' ' | tr -s ' '))
	for v in ${tables[@]}
		do
			echo "table:   " "$v"
		done

	function random()
	{
	    min=1;
	    max=4294967290;
	    num=$(date +%s%N);
	    ((retnum=num%max+min));
	    #进行求余数运算即可
	    echo $retnum;
	    #这里通过echo 打印出来值，然后获得函数的，stdout就可以获得值
	    #还有一种返回，定义全价变量，然后函数改下内容，外面读取
	}

	# （1） vim /etc/mysql/my.cnf
	# 在【mysqld】下面填写3句话
	# server-id=1
	# log-bin=/var/log/mysql/mysql-test-bin.log
	# binlong-do-db=yewumasterslave(具体的数据库名，视具体情况而定)
	echo "********************"
	echo $2 | sudo -S cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
	echo "/etc/mysql/my.cnf backup created"
	echo "/etc/mysql/my.cnf mod start"
	sid=$(random)
	logbin="/var/log/mysql/mysql-test-bin.log"
	echo $2 | sudo -S sed -i "/server-id/d" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/log_error/a server-id=$sid" /etc/mysql/my.cnf
	cat /etc/mysql/my.cnf | grep 'server-id'
	
	echo $2 | sudo -S sed -i "/log_bin/d" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/server-id/a log_bin=$logbin" /etc/mysql/my.cnf
	cat  /etc/mysql/my.cnf | grep log_bin
	
	echo $2 | sudo -S sed -i "/bind-address/c #bind-address = 127.0.0.1" /etc/mysql/my.cnf
	
	echo "delete all binlog_do_db"
	echo "delete all replicate_do_db"
	echo $2 | sudo -S sed -i "/binlog_do_db/d" /etc/mysql/my.cnf
	echo $2 | sudo -S sed -i "/replicate_do_db/d" /etc/mysql/my.cnf
	echo "add bin_do_db && replicate_do_db"
	echo $2 | sudo -S sed -i "/log_bin/a binlog_do_db=${databases[0]}" /etc/mysql/my.cnf	
	echo $2 | sudo -S sed -i "/binlog_do_db/a replicate_do_db=${databases[0]}" /etc/mysql/my.cnf
	cat  /etc/mysql/my.cnf | grep ${databases[0]}
	echo "/etc/mysql/my.cnf mod end"
	echo "********************"
	echo $2 | sudo -s service mysql restart
	echo "service mysql restarted"

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
	" 
 }   

 auto_smart_scp () {
    expect -c "set timeout -1;     
	spawn scp $2 $3;  
	expect {
	*assword:* {send -- $1\r;       
	expect {  
	*denied* {exit 2;} 
	eof} 
      }  eof
      {exit 1;} 
	}    
	" 
 }    

	sid=$(random)
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/server-id/d' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/log_error/a server-id=$sid' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat /etc/mysql/my.cnf | grep 'server-id'"
	
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/log_bin/d' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/server-id/a log_bin=$binlog' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat /etc/mysql/my.cnf | grep 'log_bin'"
	
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/bind-address/c #bind-address = 127.0.0.1' /etc/mysql/my.cnf"
	
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/binlog_do_db/d' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/replicate_do_db/d' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/log_bin/a binlog_do_db=${databases[0]}' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S sed -i '/binlog_do_db/a replicate_do_db=${databases[0]}' /etc/mysql/my.cnf"
	auto_smart_ssh $6 $5@$4 "cat /etc/mysql/my.cnf | grep ${databases[0]}"
	
	auto_smart_ssh $6 $5@$4 "echo ${6} | sudo -S service mysql restart"

	auto_smart_scp $6 ./getfileandposition.sh $5@$4:/tmp
	auto_smart_ssh $6 $5@$4 "chmod +x /tmp/getfileandposition.sh"
	auto_smart_ssh $6 $5@$4 "/tmp/getfileandposition.sh"
	auto_smart_scp $6 $5@$4:/tmp/file /tmp
	auto_smart_scp $6 $5@$4:/tmp/position /tmp
	FILE=`cat /tmp/file`
	echo "master 2 File = " $FILE 
	POSITION=`cat /tmp/position`
	echo "master 2 Position = " $POSITION
	
	#(4)grant all privileges on *.* to root@'%' identified by '';
	#孙明明  21:40:57
	#第四条是在mysql下执行
	mysql -uroot <<EOF
	grant all privileges on *.* to root@'%' identified by '';
	exit
EOF
	mysql -uroot -e 'stop slave;'
	CHGCMD="change master to master_host='${4}',master_user='root',master_password='',master_log_file='$FILE',master_log_pos=$POSITION;"
	echo $CHGCMD
	mysql -uroot -e "change master to master_host='${4}',master_user='root',master_password='',master_log_file='$FILE',master_log_pos=$POSITION;"
	mysql -uroot -e 'start slave;'
	echo "MASTER 1 configuration complete"	
	#（5）在master机器上的mysql下：show master status;
	#孙明明  21:42:25
	#会得到类似
	#| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
	#+------------------+----------+--------------+------------------+
	#| mysql-bin.000017 |     8133 |        |                  |的一个表
	#记好file和position
	FILE=`mysql -uroot -e "show master status\G;" | awk '/File/ {print $2}'`
	echo "master 1 File = " $FILE 
	POSITION=`mysql -uroot -e "show master status\G;" | awk '/Position/ {print $2}'`
	echo "master 1 Position = " $POSITION

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
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'stop slave\;'"
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'change master to master_host=\"$LOCAL_IP\",master_user=\"root\",master_password=\"\",master_log_file=\"$FILE\",master_log_pos=$POSITION\;'" 
	auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'start slave\;'" 
	echo -e "\n---Exit Status: $?"
	
	#TEST RESULT
	L_SIR=`mysql -uroot -e "show slave status\G;" | awk '$0 ~/Slave_IO_Running/ {print $2}'`
	L_SSR=`mysql -uroot -e "show slave status\G;" | awk '$0 ~/Slave_SQL_Running/ {print $2}'`
	R_SIR=`auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'show slave status\;'"|awk '$0 ~/3306/ {print $16}'`
	R_SSR=`auto_smart_ssh $6 $5@$4 "mysql -uroot -e 'show slave status\;'"|awk '$0 ~/3306/ {print $17}'`
	echo $L_SIR
	echo $L_SSR
	echo $R_SIR
	echo $R_SSR
	if [ $L_SIR = "Yes" -a $L_SSR = "Yes" -a $R_SIR = "Yes" -a $R_SSR = "Yes" ] ; then 
	echo "SUCCESSFUL!"
	else
	echo "FAILED!"
	fi
fi
