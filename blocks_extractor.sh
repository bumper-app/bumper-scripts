#!/bin/bash 

		#cd $1/$directory && nicad3 blocks $2 $sub $3 \
increment = 0

cd $1 && ls -d */ \
| while read directory ; do  \
	(( increment++ )) \
	&& echo -ne $increment $directory 0  \
	&& cd $1/$directory && nicad3 blocks java 0 blindrenamereport &> /dev/null \
	&& echo -ne 1  \
	&& nicad3 blocks java 1 blindrenamereport &> /dev/null \
	&& echo 2  \
	&& nicad3 blocks java 2 blindrenamereport &> /dev/null \
; done