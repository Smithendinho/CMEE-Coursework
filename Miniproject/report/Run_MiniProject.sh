#!/bin/bash

# Run Python script
echo "Running DataWrangling.py..."
python3 ../code/DataWrangling.py

# Run R script
echo "Running Fitting_Models.R..."
Rscript ../code/Fitting_Models.R

# Run another R script
echo "Running Plotting.R..."
Rscript ../code/Plotting.R

# Compile LaTeX document
echo "Compiling Write_up.tex..."
texcount -1 -sum Write_up.tex > WordCount.sum

pdflatex -shell-escape Write_up.tex
bibtex Write_up
pdflatex Write_up.tex
pdflatex Write_up.tex

pdflatex -shell-escape SI.tex
bibtex SI
pdflatex SI.tex
pdflatex SI.tex


pdflatex -shell-escape FinalReport.tex
bibtex FinalReport
pdflatex FinalReport.tex
pdflatex FinalReport.tex

rm -f Write_up.pdf SI.pdf
rm -f *.aux *.log *.out *.fls *.sum *.bbl *.blg 

echo "Script execution complete. Please find FinalReport.pdf in the report directory"
