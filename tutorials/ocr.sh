#!/bin/bash

if [ -z "$1" ]
    then
        echo "You need to supply 2 arguments. > ocr.sh <path to images folder> <job id folder>"
        exit 0
fi

if [ -z "$2" ]
    then
        echo "You need to supply 2 arguments. > ocr.sh <path to images folder> <job id folder>"
        exit 0
fi


IMAGESPATH=$1
JOBID=$2

echo "Doing OCR ..."

for f in $IMAGESPATH/*.ppm
do
    echo "Processing $f file ..."
    IMAGENAME=$(basename $f | cut -f 1 -d '.')
    tesseract $f $JOBID/$IMAGENAME-ocr
done

echo "Assemble all the OCRed files into one"
OCRALL=$JOBID/$IMAGENAME-ocr-all
cat $JOBID/$IMAGENAME-ocr*.txt > $OCRALL.txt

echo "Create a word list and frequences"
cat $OCRALL.txt | tr [:upper:] [:lower:] | tr -d [:punct:] | tr -d [:digit:] | tr ' ' '\n' | sort > $OCRALL-allwords.txt
uniq $OCRALL-allwords.txt > $OCRALL-wordlist.txt
uniq -c $OCRALL-allwords.txt | sort -n -r > $OCRALL-wordfreqs.txt

echo "Finding non dictionnary words"
fgrep -i -v -w -f /usr/share/dict/french $OCRALL-wordlist.txt > $OCRALL-nondictwords.txt

echo "Approximate the pattern matching"
while read p; do
  echo $p
  tre-agrep -2 --color $p $OCRALL-wordlist.txt >> $OCRALL-approx-macthing-2.txt
  tre-agrep -4 --color $p $OCRALL-wordlist.txt >> $OCRALL-approx-macthing-4.txt
done <$OCRALL-nondictwords.txt

