#!/bin/bash
# -*- coding: UTF8 -*-

# Convert multiple svg files to pdf files and concatenate the resulting pdf
# files to a single one.

# Take a toc file as argument. This file contains the names of the svg files in
# the order you want to produce the pdf file.

# Args:
# $1: toc file
# $2: output pdf file name

# Replace the occurence of #P by the page number and #T by the total number of pages

# Dependencies: inkscape, pdftk or gs

toc=$1
outpdf=$2

i=0
tmpdir=/dev/shm
t=$(wc -l $toc | awk '{print $1}')
for x in $(cat $toc); do
    i=$(($i+1))
    echo $i $x
    sed "s/#P/$i/" $x | sed "s/#T/$t/" > $tmpdir/$i.svg
    inkscape --export-pdf=$tmpdir/$i.pdf $tmpdir/$i.svg
    svglist+=(" $tmpdir/$i.svg") # append to an array (see: http://stackoverflow.com/a/18041780/1679629)
    pdflist+=(" $tmpdir/$i.pdf")
done

echo ${pdflist[@]}
#pdftk ${pdflist[@]} cat output $outpdf
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -sOutputFile=$outpdf ${pdflist[@]} # from: http://tex.stackexchange.com/a/8665/19419
rm ${pdflist[@]}
rm ${svglist[@]}
