#bin/bash

#First argument is the path of pnfs file
#Manualy run the script like this : ./space_count.sh StorageInfoProvider/pnfs-dump-2015-03-31-10-43.xml
#This script is run weekly by cron

#Set Enviromental Variables

export sw=/home/sgmcms/phedex/sw
export myarch=slc6_amd64_gcc461
export version=4.1.3-comp3
source $sw/$myarch/cms/PHEDEX/$version/etc/profile.d/env.sh
unset PERL5LIB
source $sw/$myarch/cms/PHEDEX/$version/etc/profile.d/init.sh
export PHEDEX_ROOT=/home/sgmcms/StorageInfoProvider/PHEDEX
export PERL5LIB=$PHEDEX_ROOT/perl_lib:$PERL5LIB
export PATH=$PHEDEX_ROOT/Utilities:$PHEDEX_ROOT/Utilities/testSpace:$PATH

#setting proxy
#proxy_path=$(ls /tmp/x509up*)
#export X509_USER_PROXY=$proxy_path
export MYPROXY_SERVER=grid-px.desy.de
export X509_USER_PROXY=/var/lib/vobox/cms/proxy_repository/+2fC+3dDE+2fO+3dGermanGrid+2fOU+3dDESY+2fCN+3dEngin+20Eren+2fCN+3dproxy-voms+20cms

#check that the argument is exist 
#if not, exit 
if [ ! -f "$1" ]; then 
    echo $1 "Xml file provided does not exists"
    exit 3
fi

# Get the date from xml input file
ARG="$1"
TMP="${ARG##*dump-}"
DATE="${TMP%.xml*}"

WARNING=20
YEAR=$(echo $DATE  | cut -d "-" -f1)
MONTH=$(echo $DATE | cut -d "-" -f2)
DAY=$(echo $DATE | cut -d "-" -f3)

PNFS="$YEAR-$MONTH-$DAY"
CURRENT="$(date +"%F")"

#convert it to seconds
CURRENT_sec=$(date -ud $CURRENT  +'%s')
PNFS_sec=$(date -ud $PNFS +'%s')

#determine how old the xml file is (in days)
DIFF=$(( ($CURRENT_sec - $PNFS_sec)/60/60/24 ))

if [ $DIFF -gt $WARNING ]; then
    msg="XML file here is $DIFF (> $WARNING )days old :  $HOME/$1" 
    echo $msg  | mail -s "[Storage Dump-T2-DESY]: Input File (pnfs*.xml) file is old" engin.eren@desy.de #,christoph.wissing@desy.de
    echo $msg  | mail -s "[Storage Dump-T2-DESY]: Input File (pnfs*.xml) file is old" christoph.wissing@desy.de
fi


#myroxy server info
host=$(hostname)
#prox_left=$(myproxy-info -d) #| grep timeleft | cut -d "(" -f2 | cut -d "." -f1)
prox=$(myproxy-info -d)
t1="${prox##*(}"
proxy_left="${t1%.*}"

#Send email before 6days that proxy expires
if [ $proxy_left -lt 6 ]; then
	proxy_warn="Long term proxy in myproxy server will expire in $proxy_left days. Please renew it."
	echo $proxy_warn | mail -s "[Proxy Alert : $host]" engin.eren@desy.de,christoph.wissing@desy.de 
fi

#count/validate space and upload Site Status Board
spacecount dcache --dump $1 --node T2_DE_DESY > space_output.log

update=$(tail -5 space_output.log)
header="************************CRON-BEGIN*****************************\n"
info="Command: spacecount dcache --dump $1 --node T2_DE_DESY\n"
end="***********************CRON-END*****************************"
echo -e $header $info $update "\n" $end | mail -s "[Cron-Storage-Dump Weekly]" engin.eren@desy.de 
echo -e $header $info $update "\n" $end | mail -s "[Cron-Storage-Dump Weekly]" christoph.wissing@desy.de


exit 0
