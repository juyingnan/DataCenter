#!/bin/sh

if [ $# -lt 9 ]; then
    echo "Usage: test.sh \tlocal_IP local_root_passwd local_mysql_user local_mysql_passwd/"
    echo "\t\tremote_IP remote_root_passwd remote_mysql_user remote_mysql_passwd/"
    echo "\t\tdatabase table1 table2 table3..."
else
    # Output all parameters
    echo "local_IP: \t\t\t" $1
    echo "local_root_passwd: \t\t" $2
    echo "local_mysql_user: \t\t" $3
    echo "local_mysql_passwd: \t\t" $4
    echo "remote_IP: \t\t\t" $5
    echo "remote_root_passwd: \t\t" $6
    echo "remote_mysql_user: \t\t" $7
    echo "remote_mysql_passwd: \t\t" $8
    echo "database: \t\t\t" $9
    # Output tables
    var=10
    while [  $# -ge $var ];
    do
        echo "table " $((var-9)) ": \t\t\t" $(($var))
        var=$((var+1))
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