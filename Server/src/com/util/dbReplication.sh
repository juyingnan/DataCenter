#!/bin/bash

if [ $# -lt 7 ]; then
    echo "Usage: test.sh \tlocal_IP local_root_passwd local_mysql_passwd/"
    echo "\t\tremote_IP remote_root_passwd remote_mysql_passwd/"
    echo "\t\t'database1 database2 ...' 'tablecount table1 table2 table3...'"
else
    # Output all parameters
    LOCAL_IP=$1
    LOCAL_ROOT_PASSWD=$2
    LOCAL_MYSQL_PASSWD=$3
    REMOTE_IP=$4
    REMOTE_ROOT_PASSWD=$5
    REMOTE_MYSQL_PASSWD=$6
    echo "local_IP: \t\t\t" $LOCAL_IP
    echo "local_root_passwd: \t\t" $LOCAL_ROOT_PASSWD
    echo "local_mysql_passwd: \t\t" $LOCAL_MYSQL_PASSWD
    echo "remote_IP: \t\t\t" $REMOTE_IP
    echo "remote_root_passwd: \t\t" $REMOTE_ROOT_PASSWD
    echo "remote_mysql_passwd: \t\t" $REMOTE_MYSQL_PASSWD
    # Output databases
    databases=($7)
	for v in ${databases[@]}
	do
		echo "database: \t\t\t" "$v"
	done
    # Output tables
    tables=($8)
	for v in ${tables[@]}
	do
		echo "table: \t\t\t" "$v"
	done

    # （1） vim /etc/mysql/my.cnf
    # 在【mysqld】下面填写3句话
    # server-id=1
    # log-bin=/var/log/mysql/mysql-test-bin.log
    # binlong-do-db=yewumasterslave(具体的数据库名，视具体情况而定)

    echo "********************"
    echo $2 | sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
    echo "/etc/mysql/my.cnf backup created"
    echo "/etc/mysql/my.cnf mod start"
    echo $2 | sudo sed -i "/#server-id/c server-id=1" /etc/mysql/my.cnf
    echo $2 | sudo sed -i "/server-id/c server-id=1" /etc/mysql/my.cnf
    cat /etc/mysql/my.cnf | grep 'server-id'
    echo $2 | sudo sed -i "/#log_bin/c log_bin=/var/log/mysql/mysql-test-bin.log" /etc/mysql/my.cnf
    echo $2 | sudo sed -i "/log_bin/c log_bin=/var/log/mysql/mysql-test-bin.log" /etc/mysql/my.cnf
    cat  /etc/mysql/my.cnf | grep log_bin
    echo $2 | sudo sed -i "/binlog_do_db/a/1 binlog_do_db=$9" /etc/mysql/my.cnf
    cat  /etc/mysql/my.cnf | grep $9
    echo "/etc/mysql/my.cnf mod end"
    echo "********************"

    # root
    # echo "L1admin" | sudo -S touch /test
fi