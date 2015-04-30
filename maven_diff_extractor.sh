 #!/bin/bash 

cd $3

foldername=`hg log -r $1 --template '{date|hgdate}' | awk -F ' ' '{print $1}'`_$2
mkdir -p $4/$foldername

#Adapted from http://stackoverflow.com/a/12179492/1871890
diff_lines() {
    local path=
    local line=
    while read; do
        esc=$'\033'
        if [[ $REPLY =~ ---\ (a/)?.* ]]; then
            continue
        elif [[ $REPLY =~ \+\+\+\ (b/)?([^[:blank:]$esc]+).* ]]; then
            path=${BASH_REMATCH[2]}
        elif [[ $REPLY =~ @@\ -[0-9]+(,[0-9]+)?\ \+([0-9]+)(,[0-9]+)?\ @@.* ]]; then
            line=${BASH_REMATCH[2]}
        elif [[ $REPLY =~ ^($esc\[[0-9;]+m)*([\ +-]) ]]; then
            echo "$line" >> $1/$foldername/$2/$3/$path.lines_changed
            if [[ ${BASH_REMATCH[2]} != - ]]; then
                ((line++))
            fi
        fi
    done
}

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
						# extract line impacted at $commit for $file with diff_lines and
						# write them in the same directory as $file
increment=0

hg log -r $1 --style multiline \
| while read file ; do hg log $file -r "::$1" --template "{node|short}\n"| tail -n 3 \
		| while read commit ; do \
				mkdir -p $4/$foldername/$increment/$commit/"$(dirname "$file")" && \
				hg cat $file -r $commit -o $4/$foldername/$increment/$commit/$file && \
				hg log -p -r $commit $file | diff_lines $4 $increment $commit && \
				(( increment++ )) \
		; done \
; done 