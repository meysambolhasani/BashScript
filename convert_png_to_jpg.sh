#!/bin/bash
# install ImageMagick  for using convert command 
# $1 is source path
# $2 is destination path


clear
IFS=$'\n'
mkdir "$2"
echo hello
files=`ls $1/*png`
b="1"
for i in $files ;do
   convert "$i" -resize 50% "$2/$b.jpg"
   echo "file $b.jpg is created"   
   ((b++)) 	
done
