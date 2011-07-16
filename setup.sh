#!/bin/sh

RUN_DIR=$(cd $(dirname $0);pwd)
IGNORE=".git$|.gitignore|.gitmodules"
LIST=`ls $RUN_DIR -al | awk '{print $9}' | egrep '^\.[^\.]+' | egrep -v $IGNORE | xargs`

for FILE in $LIST
do
	if [ ! -L $HOME/$FILE ]; then
		echo "exec: ln -s $RUN_DIR/$FILE $HOME/"
		ln -s $RUN_DIR/$FILE $HOME/
	fi
done
