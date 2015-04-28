#!/bin/bash 

cd $1 && ls -d */ \
| while read other_directory && [[ "$other_directory" <  "$directory" ]] ; do
	sh /usr/local/lib/nicad/scripts/FindCrossClones $1/$2/0_blocks-blind.xml $1/$other_directory/0_blocks-blind.xml 0.3 5 2500 > $1/$directory/0-crossclones.log 2>&1
	sh /usr/local/lib/nicad/scripts/FindCrossClones $1/$2/1_blocks-blind.xml $1/$other_directory/1_blocks-blind.xml 0.3 5 2500 > $1/$directory/1-crossclones.log 2>&1 \
; done 
