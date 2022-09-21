#!/bin/sh
/usr/bin/find /home/www/html/sarg -mtime +5 | xargs /bin/rm -rf
export TERM=linux
clear
dia=`date +%d/%m/%Y`
periodo=`echo $dia`
/usr/bin/sarg -d $periodo
