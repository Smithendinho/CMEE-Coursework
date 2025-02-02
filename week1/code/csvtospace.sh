#!/bin/bash


if [ -z "$*" ];
then echo "Please give an argument!!"; exit 
fi # fi ends an if statement in bash

echo "changing csv file into txt file"

filename1=$(basename -- "$1") # find basename
filename1="${filename1%.*}" # remove file extensions

cat $1 | tr "," " " > ../data/Temperatures/$filename1.txt

echo "done"

exit

