#!/bin/bash
# 管理节点

MYID=$1
shift

echo "LOCALIP=$1"
echo "LOCALUSERNAME=$2"
echo "LOCALPASSWD=$3"
echo "REMOTE_IP=$4"
echo "REMOTE_IP=$5"

PASSWD=$3

# 0. 安装expect
echo $PASSWD | sudo -S apt-get -y install libaio-dev expect
# 1. install MySql Cluster
cd /tmp
# 1.1 extract
tar -zxvf zookeeper-3.4.6.tar.gz
# 1.2 move
echo $PASSWD | sudo -S mv ./zookeeper-3.4.6 /usr/local/zookeeper
# 1.3 config
cd /usr/local/zookeeper/conf
cp zoo_sample.cfg zoo.cfg
echo $PASSWD | sudo -S sed -i "/dataDir=/c dataDir=/usr/local/zookeeper" /usr/local/zookeeper/conf/zoo.cfg
echo $PASSWD | sudo -S sed -i '$a server.1='"$1:2888:3888" /usr/local/zookeeper/conf/zoo.cfg
echo $PASSWD | sudo -S sed -i '$a server.2='"$4:2888:3888" /usr/local/zookeeper/conf/zoo.cfg
echo $PASSWD | sudo -S sed -i '$a server.3='"$5:2888:3888" /usr/local/zookeeper/conf/zoo.cfg
cd ..
echo $PASSWD | sudo -S touch /usr/local/zookeeper/myid
echo $PASSWD | sudo -S chmod 666 /usr/local/zookeeper/myid
echo $PASSWD | sudo -S echo "" >/usr/local/zookeeper/myid
echo $PASSWD | sudo -S sed -i '$a '"$MYID" /usr/local/zookeeper/myid
echo $PASSWD | sudo -S sed -i '1d' /usr/local/zookeeper/myid
# shutdown firewall
echo $PASSWD | sudo -S iptables -F 
# 2. start
echo $PASSWD | sudo -S ./bin/zkServer.sh start
