#!/bin/bash
# -*- coding: UTF8 -*-

# Convert multiple svg files to pdf files and concatenate the resulting pdf
# files to a single one.

# Take a toc file as argument. This file contains the names of the svg files in
# the order you want to produce the pdf file.

# Args:
# $1: toc file
# $2: output pdf file name

# Dependencies: inkscape, pdftk

toc=$1
outpdf=$2

i=0
tmpdir=/dev/shm
for x in $(cat $toc); do
    i=$(($i+1))
    echo $i $x
    inkscape --export-pdf=$tmpdir/$i.pdf $x
    pdflist+=(" $tmpdir/$i.pdf") # append to an array (see: http://stackoverflow.com/a/18041780/1679629)
done

echo ${pdflist[@]}
pdftk ${pdflist[@]} cat output $outpdf
