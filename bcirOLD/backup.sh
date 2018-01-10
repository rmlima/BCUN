#!/bin/bash
if [ $# -ne 1 ]; then

echo "usage ./backup.sh <nome> ex: ./backup 100n50"
exit 1

else
echo "Running Full Backup"
TARGETDIR="../backup/"
OUTPUTFILE=$1backup-$(date +%Y%m%d).tar.gz

tar -zcvpf $TARGETDIR$OUTPUTFILE ./simul ./scenarios ../backup/LOG log.txt


fi

exit 0


