#!/bin/bash 

		#cd $1/$directory && nicad3 blocks $2 $sub $3 \

cd $1 && ls -d */ \
| while read directory ; do  \
	echo $directory 0; \
	cd $1/$directory && nohup nicad3 blocks java 0 blindrenamereport > /dev/null \
	echo $directory 1; \
	cd $1/$directory && nohup nicad3 blocks java 1 blindrenamereport > /dev/null \
	echo $directory 2; \
	cd $1/$directory && nohup nicad3 blocks java 2 blindrenamereport > /dev/null \
; done