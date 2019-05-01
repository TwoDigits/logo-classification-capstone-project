#!/bin/bash

path="/mnt/c/environment/Machine Learning/Machine Learning Engineer/capstone_project/LogosInTheWild-v2/data"
OIFS="$IFS"
IFS=$'\n'
for file in $(find "$path" -regextype posix-extended -regex '.*img[0-9]+.*');
do
   #echo "$file"
   newfile=$(echo "$file" | sed -r 's/^.*(img.*)/\1/g')
   #echo "$newfile"
   mv "$file" "$(dirname "$file")/${newfile}"
done
IFS="$OIFS"
