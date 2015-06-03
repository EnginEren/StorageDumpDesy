#!/bin/bash

IFS=$'\n'
set -f

comm -12 $1 $2 | awk '{print $1,$2}' > notouch

cat notouch | awk '{print $1}' | sort -u > onlyname

touch users.html

echo "<!DOCTYPE html>
<html>
<head>
<BODY BACKGROUND="speckle.gif"> 
<title>
Users@T2_DESY
</title>
</head>
<body>
<h2> Users who did not access/touch files in tier2/store/user directory between 01.03.2015-31.05.2015 </h2>
<img src="user-group-icon.png" alt="People" style="width:256px"> " > users.html
for i in $(cat onlyname); do
	touch user_$i.html
	echo "<!DOCTYPE html>
<html>
<body>
<BODY BACKGROUND="speckle.gif">
<h2>Dear $i, you did not access these files in tier2/store/user directory between 01.03.2015-31.05.2015 </h2> " > user_$i.html
	user="$i"
	echo "<ul>
		<li> <p><a href="https://eeren.web.cern.ch/eeren/user_$i.html"> $i</a></p> </li> 
	      </ul>" >> users.html
	for j in $(cat notouch); do
		username=$(echo $j | awk '{print $1}')
		filename=$(echo $j | awk '{print $2}')
		if [ "$username" == "$user" ]; then
		echo "<ul>
    			<li> $filename </li>
    		      </ul>" >> user_$i.html
		fi 	
	done		
echo "</body>
</html>" >> user_$i.html


done

echo "</body>
</html>" >> users.html


exit 0;
