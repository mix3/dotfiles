#!/bin/sh

RUN_DIR=$(cd $(dirname $0);pwd)
LIST=`ls -al $RUN_DIR | awk '{print $9}' | egrep '^\.[^\.]+' | egrep -v .git | xargs`
INCLUDE=".gitconfig"
LIST="$LIST $INCLUDE"

for FILE in $LIST
do
	if [ ! -L $HOME/$FILE ]; then
		echo "exec: ln -s $RUN_DIR/$FILE $HOME/"
		ln -s $RUN_DIR/$FILE $HOME/
	fi
done
