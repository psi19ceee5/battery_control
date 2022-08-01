#!/bin/bash

INSTALLPATH=/usr/local/sbin
EXECNAME=battery_control.sh
IMG1=battery_low.svg
IMG2=battery_verylow.svg
IMG3=battery_empty.svg

if [[ $USER != 'root' ]]; then
  echo 'Please execute with script as root'
  exit
fi

if [[ -f $INSTALLPATH/$EXECNAME ]] ||
     [[ -f $INSTALLPATH/$IMG1 ]] ||
     [[ -f $INSTALLPATH/$IMG2 ]] ||
     [[ -f $INSTALLPATH/$IMG3 ]]; then
  echo -n 'Previous installation exists. Overwrite files? (Y/n) '
  read userinp
  if [[ $userinp == 'n' ]]; then
    echo 'bye'
    exit
  fi
fi

echo 'Installing files...'

cp -v $EXECNAME $IMG1 $IMG2 $IMG3 $INSTALLPATH

echo 'Installing crontab...'

CRONTABLINE="* * * * * /usr/local/sbin/$EXECNAME"

if [[ $(less /var/spool/cron/crontabs/root | grep "$CRONTABLINE") ]]; then
  echo '  ...crontab already installed.'
elif [[ $(less /var/spool/cron/crontabs/root | grep $EXECNAME) ]]; then
  echo -e "\033[33m[WARNING]: an entry containing $EXECNAME already exists in your crontab, but it seems to be misconfigured. Please inspect this line manually (sudo crontab -e).\033[0m"
else
  echo '' >> /var/spool/cron/crontabs/root
  echo "$CRONTABLINE" >> /var/spool/cron/crontabs/root
fi

echo 'Done.'
      
       


