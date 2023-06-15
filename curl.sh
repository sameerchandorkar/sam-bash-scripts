#!/bin/bash
for i in 
if curl -I "https://www.magesh.co.in" 2>&1 | grep -w "200\|301" ; then
    echo "magesh.co.in is up"
else
    echo "magesh.co.in is down"
fi
