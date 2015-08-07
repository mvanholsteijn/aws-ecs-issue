#!/bin/bash
MESSAGE=$@
if [ $# -eq 0 ] ; then
	MESSAGE="Hello world!"
fi

echo $MESSAGE 
exit -2
