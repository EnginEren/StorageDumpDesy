#!/bin/bash

rm user.files.txt

cat $1 | grep /user/ | awk -F/ '{print $8}' > user
cat $1 | grep /user/ | awk -F'"' '{print $2}' > filename

paste user filename | awk '{print $1,$2}' | sort -n > user.files.txt

rm user
rm filename

exit 0;





