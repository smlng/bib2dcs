#!/bin/bash

if [ -z "$1" ] ; then
    echo "Missing parameter: bbl file!"
    exit 1
fi

if [ -z "$BIBINPUTS" ] ; then 
    echo "BIBINPUTS path not set!"
    exit 1
fi

BBL=$1
TMPFILE="bibitems.tmp"
BIBFILES="own.bib rfcs.bib ids.bib"
grep bibitem $BBL | awk -F '[\{\}]' '{print $2}' > $TMPFILE
for i in `cat $TMPFILE`; do 
#    echo $i;
    CMD="bibtool '--select{\"$i\$\"}' $BIBFILES"; 
    eval $CMD 2> /dev/null
done
rm $TMPFILE
