#!/bin/bash
MESSAGE=$@
if [ $# -eq 0 ] ; then
	MESSAGE="Hello world!"
fi

COUNT=0
while [ $COUNT -lt 10 ] ; do
	echo $COUNT : $MESSAGE ; sleep 1
	COUNT=$(($COUNT + 1))
done
