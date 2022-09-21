==== Subversion Checkout-Update ====

<code powershell>
$SVN = "C:\Program Files\TortoiseSVN\bin\"
$ROOT = "D:\_temp\DLP"
$SERVER = "xxxxxxxxxxxxxxxx"
$REPOS = "$ROOT\scripts\xxxxxxxxxxxxxxxx.txt"
$LOG = "$ROOT\logs\subversion.log"
$LOGERROR = "$ROOT\logs\error.log"
$USERNAME = "xxxxxxxxxxxxxxxx"
$PASSWORD = "xxxxxxxxxxxxxxxx"
$USER_PASS_ENCRYPTED = "$ROOT\scripts\username-password-encrypted.txt"

Invoke-WebRequest -Uri $SERVER/$SERVER.txt -OutFile $REPOS

cd $SVN

Get-Content -Path $REPOS | ForEach-Object {

if (Test-Path -Path $ROOT\Fontes\$_) {

    $LOGREPOS = "$ROOT\logs\$_.log"
    echo "Directory $_ Found">> $LOGREPOS
    "starting Update repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOGREPOS
    "starting Update repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOG

    .\svn.exe update $ROOT\Fontes\$_>> $LOGREPOS

if ( $? -eq $false ) {
    echo "Error found">> $LOGREPOS
    echo "Retrying http://$SERVER/$_ with SVN cleanup">> $LOGREPOS
    .\svn.exe cleanup $ROOT\Fontes\$_>> $LOGREPOS
    .\svn.exe update $ROOT\Fontes\$_>> $LOGREPOS
}

if ( $? -eq $false ) {
    echo "Update Failed for repository http://$SERVER/$_">> $LOGERROR
}

    "Finish Update repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOGREPOS
    "Finish Update repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOG
     echo "">> $LOG
     echo "">> $LOGREPOS
}
else {

     $LOGREPOS = "$ROOT\logs\$_.log"
     echo "Directory $_ not Found">> $LOGREPOS
     "starting Checkout repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOGREPOS
     "starting Checkout repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOG

     .\svn.exe checkout --username $USERNAME --password $PASSWORD --revision HEAD http://$SERVER/$_ $ROOT\Fontes\$_>> $LOGREPOS

if ( $? -eq $false ) {
    echo "Checkout Failed for repository http://$SERVER/$_">> $LOGERROR
}

     "Finish Checkout repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOGREPOS
     "Finish Checkout repository http://$SERVER/$_ ==> {0}" -f (Get-Date)>> $LOG
     echo "">> $LOG
     echo "">> $LOGREPOS

}
}

### Email notification in case of failures ###

if(!(Test-Path $LOGERROR))
{
    Write-Host "no errors found"
    exit
}

$FROM = 'Forcepoint <xxxxxxxxxxxxxxxx@xxxxxxxxxxxxxxxx>'
$TO = 'xxxxxxxxxxxxxxxx <xxxxxxxxxxxxxxxx@xxxxxxxxxxxxxxxx>'
$SUBJECT = '[ xxxxxxxxxxxxxxxx DLP - Subversion Task Error ]'
$BODY = Get-Content "$LOGERROR"
$SMTP_SERVER = 'xxxxxxxxxxxxxxxx'
$SMTP_PORT = '587'

$user = "xxxxxxxxxxxxxxxx@xxxxxxxxxxxxxxxx"
$password = cat $USER_PASS_ENCRYPTED | convertto-securestring
$autenticar = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $password

Send-MailMessage -From $FROM -To $TO -Subject $SUBJECT -Body $BODY -SmtpServer $SMTP_SERVER -Port $SMTP_PORT  -Priority High -DeliveryNotificationOption OnSuccess, OnFailure -credential $autenticar

### Clean ###
rm $LOGERROR
