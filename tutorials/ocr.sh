#!/bin/bash

if [ -z "$1" ]
    then
        echo "You need to supply 2 arguments. > ocr.sh <path to images folder> <job id folder>"
        exit 0
fi

#if [ -z "$2" ]
#    then
#        echo "You need to supply 2 arguments. > ocr.sh <path to images folder> <job id folder>"
#        exit 0
#fi


#IMAGESPATH=$1
#JOBID=$2
PDFFILE=$1
PDFNAME=$(echo $PDFFILE | cut -f 1 -d '.')
#JOBID=${$PDFNAME//[[:alpha:]]/}
JOBID=$(echo $PDFNAME | sed 's/[^a-zA-Z0-9]//g')
IMAGESPATH=$JOBID/images
CLEANIMAGESPATH=$JOBID/images/clean

echo PDFFILE is $PDFFILE
echo PDFNAME is $PDFNAME
echo JOBID is $JOBID
echo IMAGESPATH is $IMAGESPATH
echo CLEANIMAGESPATH is $CLEANIMAGESPATH


echo "Doing OCR ..."

for f in $IMAGESPATH/*.ppm
do
    echo "Processing $f file ..."
    IMAGENAME=$(basename $f | cut -f 1 -d '.')
    OUTPUTFILE=$CLEANIMAGESPATH/$IMAGENAME-clean.ppm
    echo Cleaning the file $f to $OUTPUTFILE
    ./textcleaner $f $OUTPUTFILE 

    echo Doing OCR on the file $f
    tesseract $OUTPUTFILE $JOBID/$IMAGENAME-ocr
    tesseract $f $JOBID/$IMAGENAME-ocr-original
done

echo "Assemble all the OCRed files into one"
OCRALL=$JOBID/$PDFNAME-ocr-all
cat $JOBID/$PDFNAME-*-ocr.txt > $OCRALL.txt

echo "Create a word list and frequences"
cat $OCRALL.txt | tr [:upper:] [:lower:] | tr -d [:punct:] | tr -d [:digit:] | tr ' ' '\n' | sort > $OCRALL-allwords.txt
uniq $OCRALL-allwords.txt > $OCRALL-wordlist.txt
uniq -c $OCRALL-allwords.txt | sort -n -r > $OCRALL-wordfreqs.txt

echo "Finding non dictionnary words"
fgrep -v -w -f /usr/share/dict/french $OCRALL-wordlist.txt > $OCRALL-nondictwords.txt

echo "Approximate the pattern matching"
while read p; do
  echo $p
  tre-agrep -2 --color $p $OCRALL-wordlist.txt >> $OCRALL-approx-macthing-2.txt
  tre-agrep -4 --color $p $OCRALL-wordlist.txt >> $OCRALL-approx-macthing-4.txt
done <$OCRALL-nondictwords.txt

echo "Cleaning the ocred text"
cat $OCRALL.txt > $OCRALL-clean.txt

echo "Labeling named entities : person"
~/stanford-ner/ner.sh $OCRALL-clean.txt > $OCRALL-clean-ner.txt
sed 's/\/O / /g' < $OCRALL-clean-ner.txt > $OCRALL-clean-ner-clean.txt
egrep -o -f personpattr $OCRALL-clean-ner-clean.txt | sed 's/\/PERSON//g'  > $OCRALL-clean-ner-clean-pers.txt

cat $OCRALL-clean-ner-clean-pers.txt | sed 's/\/PERSON//g' | sort | uniq -c | sort -nr > $OCRALL-clean-ner-clean-pers_freq.txt

echo "Labeling named entities : organizations"
egrep -o -f orgpattr $OCRALL-clean-ner-clean.txt | sed 's/\/ORGANIZATION//g' > $OCRALL-clean-ner-clean-org.txt
cat $OCRALL-clean-ner-clean-org.txt | sed 's/\/ORGANIZATION//g' | sort | uniq -c | sort -nr > $OCRALL-clean-ner-clean-org_freq.txt

echo "Labeling named entities : locations"
egrep -o -f locpattr $OCRALL-clean-ner-clean.txt | sed 's/\/LOCATION//g' > $OCRALL-clean-ner-clean-loc.txt
cat $OCRALL-clean-ner-clean-loc.txt | sed 's/\/LOCATION//g' | sort | uniq -c | sort -nr > $OCRALL-clean-ner-clean-loc_freq.txt

echo "Generating the metadata for the PDF"

while read VALUE; do
  #echo $VALUE
  echo "InfoKey: Person" >> $JOBID/$PDFNAME-metadata.txt
  echo "InfoValue: $VALUE" >> $JOBID/$PDFNAME-metadata.txt
done <$OCRALL-clean-ner-clean-pers.txt

while read VALUE; do
  #echo $VALUE
  echo "InfoKey: Organization" >> $JOBID/$PDFNAME-metadata.txt
  echo "InfoValue: $VALUE" >> $JOBID/$PDFNAME-metadata.txt
done <$OCRALL-clean-ner-clean-org.txt

while read VALUE; do
  #echo $VALUE
  echo "InfoKey: Location" >> $JOBID/$PDFNAME-metadata.txt
  echo "InfoValue: $VALUE" >> $JOBID/$PDFNAME-metadata.txt
done <$OCRALL-clean-ner-clean-loc.txt

echo "Add the metadata into the pdf"
pdftk $PDFFILE update_info $JOBID/$PDFNAME-metadata.txt output $JOBID/$PDFNAME-updated.pdf

echo "Done."

