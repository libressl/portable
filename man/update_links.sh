#!/bin/sh

# Run this periodically to ensure that the manpage links are up to date

echo "# This is an auto-generated file by $0" > links
doas makewhatis
for i in `ls -1 *.3`; do
  name=`echo $i|cut -d. -f1`
  links=`sqlite3 /usr/share/man/mandoc.db \
    "select names.name from mlinks,names where mlinks.name='$name' and mlinks.pageid=names.pageid;"`
  for j in $links; do
    a=`echo "x$j" | tr '[:upper:]' '[:lower:]'`
    b=`echo "x$name" | tr '[:upper:]' '[:lower:]'`
    if [[ $a != $b && $a != *"<type>"* ]]; then
      echo $name.3,$j.3 >> links
    fi
  done
done
