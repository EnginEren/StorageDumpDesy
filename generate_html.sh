#!/bin/bash

IFS=$'\n'
set -f

comm -3 $1 $2 | awk '{print $1,$2}' > trash

cat << _EOF_
<!DOCTYPE html>
<html>
<body>
<table border="1" cellpadding="5" cellspacing="5">
 <caption>Users who did not access files in tier2/store/user directory over six months </caption>
_EOF_


for i in $(cat trash); do
	username=$(echo $i | awk '{print $1}')
	filename=$(echo $i | awk '{print $2}')
	 
cat << _EOF_
<tr>
   <td>$username</td>
   <td>$filename</td>
</tr>
_EOF_
done

cat << _EOF_
</table>
</body>
</html>
_EOF_


exit 0;
