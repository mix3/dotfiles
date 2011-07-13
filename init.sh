#!/bin/sh

CURRENT_DIR=$(cd $(dirname $0);pwd)
LIST=$(ls -al $CURRENT_DIR | awk '{print $9}'| egrep "^\.[^.]+" | egrep -v .git | xargs)

for FILE in $LIST 
do
	if [ ! -e ~/$FILE ]; then
		ln -s $CURRENT_DIR/$FILE ~/$FILE
		echo $FILE
	fi
done
