#!/bin/bash 

# List directories of $1
# for each directory
#	count how many diff file are present
#	if one diff file is present, then rename the directory with the following pattern 
#		timestampDiffFile_oldName
#	else if there is more than one diff file
#		merge all diff file in big_diff.txt
#		rename the directory to timestampBigDiffFile_oldName

cd $1 && ls -d */ \
| while read directory ; do 
	count=`ls -l $1/$directory/diff_* | wc -l`
	if [ $count -eq 1 ] 
		then name=`head $1/$directory/diff_* -n 1 | awk -F ' ' '{print $1}'` \
		&& mv $1/$directory $1/$name-$directory 
	elif [ $count -ge 2 ]
		then cat $1/$directory/diff_* >> $1/$directory/big_diff.txt && name=`head $1/$directory/big_diff.txt -n 1 | awk -F ' ' '{print $1}'` \
		&& mv $1/$directory $1/$name-$directory 
	fi \
; done