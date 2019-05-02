#!/bin/bash

oldpath="/data/Machine_Learning/Machine_Learning_Engineer/capstone_project/openlogo/JPEGImages"
newpath="/data/Machine_Learning/Machine_Learning_Engineer/capstone_project/LogosInTheWild-v2/data"
OIFS="$IFS"
IFS=$'\n'
for file in $(find "$oldpath" -regextype posix-extended -regex '.*img[0-9]+.jpg');
do
   #echo "$file"
   newfile=$(echo "$file" | sed -r 's/^.*(img.*)/\1/g')
   #echo "$newfile"
   oldfilename=${file##*/}
   #echo "$oldfilename"
   brand=$(echo "$oldfilename" | sed -r 's/^(.*)img.*/\1/g')
   #echo "$brand"
   for D in `find "$newpath" -type d`
   do
      subfolder=$(echo  $D| rev | cut -d'/' -f 1 | rev)
      if [ "$(echo "${subfolder^^}" | tr -dc '[:alnum:]')" = "$(echo "${brand^^}" | tr -dc '[:alnum:]')" ]; then
        echo mv "$file" "$D/${newfile}"
        mv "$file" "$D/${newfile}"
      fi
   done
done
IFS="$OIFS"
