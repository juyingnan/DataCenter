#!/bin/bash
mysql -uroot -e "grant all privileges on *.* to root@'%' identified by '';"
FILE=`mysql -uroot -e "show master status\G;" | awk '/File/ {print $2}'`
echo "master 1 File = " $FILE 
echo $FILE > /tmp/file
POSITION=`mysql -uroot -e "show master status\G;" | awk '/Position/ {print $2}'`
echo "master 1 Position = " $POSITION
echo $POSITION > /tmp/position
