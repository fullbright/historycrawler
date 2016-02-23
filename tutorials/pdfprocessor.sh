#!/bin/bash

if [ -z "$1" ]
    then
        echo "No argument supplied"
        exit 0
fi

PDFFILE=$1
PDFNAME=$(echo $PDFFILE | cut -f 1 -d '.')
#JOBID=${$PDFNAME//[[:alpha:]]/}
JOBID=$(echo $PDFNAME | sed 's/[^a-zA-Z0-9]//g')

echo PDFFILE is $PDFFILE
echo PDFNAME is $PDFNAME
echo JOBID is $JOBID

echo Creating a folder with the jobid $JOBID
mkdir $JOBID

echo Processing PDF file

echo "Extracting information from PDF"
pdfinfo $PDFFILE > $JOBID/$PDFNAME-initialinfo.txt

echo Extracting text from the PDF
pdftotext $PDFFILE $JOBID/$PDFNAME-raw-text.txt

echo Extrating images from the PDF
mkdir -p $JOBID/images
pdfimages $PDFFILE $JOBID/images/$PDFNAME

echo Creating a contact sheet with the images
montage -verbose -label '%f' -define pbm:size=200x200 -geometry 100x100+38+6 -tile 5x $JOBID/images/*.pbm[100x100] $JOBID/images-contact.jpg

echo Converting images to pdf
convert -negate $JOBID/images/*.pbm $JOBID/$JOBID-images.pdf

echo Using PDFK
pdftk $PDFFILE cat 3east output $JOBID/$PDFNAME-p003-rotated.pdf

pdftk $PDFFILE cat 230-233 output $JOBID/$PDFNAME-pp230-233-index.pdf


echo "Using OCR on the extracted images"
./ocr.sh $PDFFILE


pdfinfo $JOBID/$PDFNAME-updated.pdf > $JOBID/$PDFNAME-updatedinfo.txt


