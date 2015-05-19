#!/bin/bash

list=$(grep "/user/" $1)
touch bad.txt
rm user.files.txt
for user in $list; do
  s1=${user%'"'>*} 
  s1=${s1##*/user/}
  username=${s1%%/*}  
  filename=${s1##*/}
  echo $username $filename >> bad.txt
done

awk '!/entry/' bad.txt > temp && mv temp user.files.txt

rm bad.txt
exit 0; 
