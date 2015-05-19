#!/bin/bash
# Original location of the script : t2-cms-phedex02:/home/sgmcms/ChimeraDump
# Wrapper script to call Chimera-Dump tool
#
#
DUMP_PROG=chimera-dump.py
DUMP_CONF=cd_conf.py
DISK_THRESH=2
DEST=$HOME/StorageInfoProvider

#Check destination dir
if [ ! -d $DEST ]; then
   echo "Destination directory $DEST not existing"
   exit 1
fi

#Check disk space - quite some is needed
#Space in GB
AVAIL=$(df -BG -P $DEST | grep /dev/ | awk '{ print $4 }' | cut -d'G' -f1)
if [ $AVAIL -lt $DISK_THRESH ]; then
   echo "Not enoug disk space in $DEST"
   echo "Need at least $DISK_THRESH, but have only $AVAIL"
   exit 1
fi

# Check tools
if [ ! -r $DUMP_PROG ]; then
   echo "Cannot find $DUMP_PROG"
   exit 1
fi
if [ ! -r $DUMP_CONF ]; then
   echo "Config $DUMP_CONF for dump tool not found"
   exit 1
fi

# Dump file name
OUTNAME="pnfs-dump-`date +%F-%k-%M`"
python $DUMP_PROG -o $DEST/$OUTNAME -s /pnfs/desy.de/cms/tier2/store
RC=$?

if [ $RC ]; then
  echo "ERROR: Chimera Dump returned an error!"
  exit $RC
fi

exit $RC
