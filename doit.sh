#!/bin/bash
MESSAGE=$@
if [ $# -eq 0 ] ; then
	MESSAGE="default message: Hello world!"
fi

echo $MESSAGE 
exit -2
