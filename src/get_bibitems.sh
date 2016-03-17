#!/bin/bash
BIBTOOL=$(which bibtool)

if [ -z "$BIBTOOL" ] ; then
    echo "bibtool not found, either install or set PATH!"
    exit 1
fi

if [ -z "$BIBINPUTS" ] ; then
    echo "BIBINPUTS path to bib files not set!"
    exit 1
fi

if [ -z "$BIBFILES" ] ; then
    echo "BIBFILES not specified!"
    exit 1
fi

if [ -z "$1" ] ; then
    echo "Missing parameter: bbl file!"
    exit 1
fi
BBL=$1

TMPFILE="bibitems.tmp"
grep bibitem $BBL | awk -F '[\{\}]' '{print $2}' > $TMPFILE
for i in `cat $TMPFILE`; do
    CMD="$BIBTOOL '--select{\"$i\$\"}' $BIBFILES";
    eval $CMD 2> /dev/null
done
rm $TMPFILE
