#!/bin/bash

SVN=/usr/bin/svn
ROOT=/xxx/xxx/xxx
SERVER=xxx.xxx.xxx.xxx
REPOS=$ROOT/scripts/xxx.xxx.xxx.xxx.txt
LOG=$ROOT/logs/$SERVER/_subversion.log
LOGERROR=$ROOT/logs/$SERVER/_error.log
USERNAME=XXXXXXXXXX
PASSWORD=XXXXXXXXXX

wget --quiet -O $REPOS $SERVER/$SERVER.txt

for REPO in $(cat $REPOS); do
if [ -d "$ROOT/Fontes/$SERVER/$REPO" ]; then
	LOGREPOS="$ROOT/logs/$SERVER/$REPO.log"
	echo -e "Directory ${REPO} Found\n" >> $LOGREPOS
	echo -e "$(date '+%d/%m/%y %H:%M') - Starting Update repository http://${SERVER}/${REPO}" >> $LOGREPOS
	echo -e "$(date '+%d/%m/%y %H:%M') - Starting Update repository http://${SERVER}/${REPO}" >> $LOG
	$SVN update --username $USERNAME --password $PASSWORD $ROOT/Fontes/$SERVER/$REPO >> $LOGREPOS
  
if [ $? -ne 0 ]; then
	echo -e "Error found\n" >> $LOGREPOS
	echo -e "Retrying http://${SERVER}/${REPO} with SVN cleanup" >> $LOGREPOS
	$SVN cleanup $ROOT/Fontes/$SERVER/$REPO >> $LOGREPOS
	$SVN update --username $USERNAME --password $PASSWORD $ROOT/Fontes/$SERVER/$REPO >> $LOGREPOS
fi

if [ $? -ne 0 ]; then
    echo -e "Update Failed for repository http://${SERVER}/${REPO}" >> $LOGERROR
fi

	echo -e "$(date '+%d/%m/%y %H:%M') - Finish Update repository http://${SERVER}/${REPO}\n" >> $LOGREPOS
	echo -e "$(date '+%d/%m/%y %H:%M') - Finish Update repository http://${SERVER}/${REPO}\n" >> $LOG
   
else
	LOGREPOS="$ROOT/logs/$SERVER/$REPO.log"
	echo -e "Directory $REPO not Found" >> $LOGREPOS
    echo -e "$(date '+%d/%m/%y %H:%M') - starting Checkout repository http://${SERVER}/${REPO}\n" >> $LOGREPOS
    echo -e "$(date '+%d/%m/%y %H:%M') - starting Checkout repository http://${SERVER}/${REPO}\n" >> $LOG
    $SVN checkout --username $USERNAME --password $PASSWORD --revision HEAD http://${SERVER}/$REPO $ROOT/Fontes/$SERVER/$REPO >> $LOGREPOS


if [ $? -ne 0 ]; then
	echo -e "$(date '+%d/%m/%y %H:%M') - Checkout Failed for repository http://${SERVER}/${REPO}" >> $LOGERROR
fi

	echo -e "$(date '+%d/%m/%y %H:%M') - Finish Checkout repository http://${SERVER}/${REPO}\n" >> $LOGREPOS
	echo -e "$(date '+%d/%m/%y %H:%M') - Finish Checkout repository http://${SERVER}/${REPO}\n" >> $LOG
fi

done

if test -f "$LOGERROR"; then

LISTA_MAIL_LOG="xxx@xxx"
SMTP_SERVER="xxxxxxxxx:587"
SMTP_USER="xxx@xxxxxxxxxxxx"
SMTP_PASS="XXXXXXXXXX"
SMTP_FROM="xxx@xxxxxxxxxxxx"
ASSUNTO="[ xxx DLP - Subversion Task Error ]"

envia_email(){
for m in $LISTA_MAIL_LOG
do
echo -e "$(cat $LOGERROR)"|s-nail -S from=$SMTP_FROM -S smtp=$SMTP_SERVER -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASS -S ssl-verify=ignore -s "$ASSUNTO"  $m
done
}
 
envia_email

fi

### Clean ###
rm $LOGERROR
