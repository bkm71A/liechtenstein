#!/bin/bash

#set -e -u

for n in ./out/*.htm
do
   cat table_start.xml "$n" table_end.xml >> "$n"l;
done
