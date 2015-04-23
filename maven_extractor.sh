#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    echo '--------USAGE--------'
    echo 'maven_extractor.sh fixRevisionSha1 bugId repoDirectory outputDirectory'
    echo '---------------------'
    exit 1
fi

# extract the files impacted by $1 revision
# iterate over them
	# extract commits impacting $file from beginning of the time and to revision $1
	# then tail last 3 results (refers as $increment). They are the supposed to be 
	# 0) stable state before bug insertion
	# 1) bug insertion - buggy state
	# 2) bug fix, stable again
		# iterate over the last three commit impacting current file
			# create directories to host $file at $commit revision and 
			# sort them by $increment
						# extract $file at $commit revision and place it in the right folder

increment=0

cd $3 && hg log -r $1 --style multiline \
| while read file ; do hg log $file -r "::$1" --template "{node|short}\n"| tail -n 3 \
		| while read commit ; do \
			mkdir -p $4/$2/$increment/$commit/"$(dirname "$file")" && \
			hg cat $file -r $commit -o $4/$2/$increment/$commit/$file && \
			(( increment++ )) \
		 ; done \
; done 