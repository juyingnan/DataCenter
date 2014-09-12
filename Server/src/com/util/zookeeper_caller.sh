#!/bin/bash

PASSWD=$1
shift

#IF_COPY_CLUSTER_FILE=$1
#FILE=$2
#LOCAL_IP=$3
#LOCAL_USER_NAME=$4
#LOCAL_USER_PASSWD=$5
#REMOTE_IP=$6
#REMOTE_IP=$7

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
spawn scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $2 $3;
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

IF_COPY_CLUSTER_FILE=$1
shift
FILE=$1
shift
#LOCAL_IP=$1
#LOCAL_USER_NAME=$2
#LOCAL_USER_PASSWD=$3
#REMOTE_IP=$4
#REMOTE_IP=$5

echo $PASSWD | sudo -S apt-get -y install libaio-dev expect

cd $(cd "$(dirname "$0")"; pwd)
echo $(pwd)

if [ $IF_COPY_CLUSTER_FILE = "True" ] ; then
  echo "copying cluster file."
  auto_smart_scp $3 ./zookeeper-3.4.6.tar.gz $2@$1:/tmp
else
  echo "skipped copying zookeeper file."
fi

auto_smart_scp $3 ./$FILE $2@$1:/tmp
auto_smart_ssh $3 $2@$1 "/tmp/$FILE 1 $*"
auto_smart_scp $3 ./$FILE $2@$4:/tmp
auto_smart_ssh $3 $2@$4 "/tmp/$FILE 2 $*"
auto_smart_scp $3 ./$FILE $2@$5:/tmp
auto_smart_ssh $3 $2@$5 "/tmp/$FILE 3 $*"
