#!/bin/bash

## Exercise Solution found on stack overflow - with help from fancis

filename=$(basename -- "$1")
filename="${filename%.*}"

echo $filename

pdflatex $filename.tex
bibtex $filename
pdflatex $filename.tex
pdflatex $filename.tex
evince $filename.pdf & 


## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg