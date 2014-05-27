#!/bin/bash

#echo "Usage: test.sh \tlocal_IP local_user_name local_user_passwd local_mysql_passwd/"
#echo "\t\tremote_IP remote_username remote_user_passwd remote_mysql_passwd/"
#echo "\t\t'database1 database2 ...' 'tablecount table1 table2 table3...'"
#LOCAL_IP=$1
#LOCAL_USER_NAME=$2
#LOCAL_USER_PASSWD=$3
#LOCAL_MYSQL_PASSWD=$4
#REMOTE_IP=$5
#REMOTE_USER_USERNAME=$6
#REMOTE_USER_PASSWD=$7
#REMOTE_MYSQL_PASSWD=$8



auto_smart_ssh () {
expect -c "set timeout -1;
spawn ssh -o StrictHostKeyChecking=no $2 ${@:3};
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

auto_smart_scp $3 ./call.sh $2@$1:/tmp
auto_smart_ssh $3 $2@$1 "/tmp/call.sh $*"
