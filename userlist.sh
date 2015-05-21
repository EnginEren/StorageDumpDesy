#!/bin/bash

cat $1 | awk -F/ '{print $8}' > user
cat $1 | awk -F'"' '{print $2}' > filename

paste user filename | awk '{print $1,$2}' > user.files.txt

rm user
rm filename

exit 0;





