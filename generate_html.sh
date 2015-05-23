#!/bin/bash

IFS=$'\n'
set -f

#comm -3 $1 $2 | awk '{print $1,$2}' > trash

cat new | awk '{print $1}' | sort -u > onlyname


cat << _EOF_
<!DOCTYPE html>
<html>
<body>
<h2>Users who did not access files in tier2/store/user directory over six months </h2>
_EOF_


for i in $(cat onlyname); do
	cat << _EOF_
<ul>
  <li> $i 
_EOF_
	user="$i"
	for j in $(cat new); do
		username=$(echo $j | awk '{print $1}')
		filename=$(echo $j | awk '{print $2}')
		if [ "$username" == "$user" ]; then
		cat << _EOF_
    <ul>
    <li> $filename </li>
    </ul>
  </li>
_EOF_
		fi 	
	done		

cat << _EOF_
</ul>
_EOF_

done

cat << _EOF_
</body>
</html>
_EOF_

exit 0;
