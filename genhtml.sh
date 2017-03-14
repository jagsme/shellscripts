#!/bin/sh

# Script Name: genhtml.sh
# Author: Jagdish Mehra.
# Date Created: 28/11/2016


for entry in "$1"/*
do
	if [[ $entry == *".jtl"* ]]
		then
  			string=${entry%.jtl*}
  			SUBSTRING=$(echo $string| cut -d'/' -f 2)
  			#echo $SUBSTRING
  	fi
echo ant -f build1.xml -Dtestpath=/root/reports/jtl/$1 -Dtest=$SUBSTRING report
done
