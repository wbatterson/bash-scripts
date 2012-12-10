#!/usr/bin/bash -x
for h in `cat chkurl.lst`; do
   export CHK=`curl -s -m 30 $h|grep -c "Col1=hello333"`;
   if [ "$CHK" != 1 ]; then
      s=`echo $h|awk -F/ '{print $3}'`;
      echo "`date` : $s has been reset" >> /home/admin/logs/`date +%Y%m%d`.log
      /cygdrive/c/WINDOWS/system32/iisreset $s
   fi
   sleep 2
   s=`echo $h|awk -F/ '{print $3}'`;
   /cygdrive/c/WINDOWS/system32/iisreset /status $s|grep "Stopped" && /cygdrive/c/WINDOWS/system32/iisreset $s;
done