#!/bin/bash

list=$(grep tier2/store/user $1 | awk -F'"' '{print $2}')

rm user.files.txt

for i in $list; do
  username=$(echo $i | awk -F/ '{print $8}') 
  echo $username $i >> user.files.txt
done


exit 0; 
