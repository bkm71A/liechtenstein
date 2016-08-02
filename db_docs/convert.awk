#!/bin/bash
set -e -u
gawk -F\| '
BEGIN {
  OFS = "|";
  ORS = "\r\n";
  stderr = "/dev/stderr";
  old_file_name = "___.jjj";
}
{
  file_name = "./out/" $1 ".htm"
  if(old_file_name != file_name) {
    printf("<caption><b><font color='#000099'><font size=+3>Table %s</font></font></b><br></caption><tr><td><center>Column Name</center></td><td><center>Column Format</center></td><td><center>Column Type</center></td><td><center>Column Length</center></td><td><center>Default Value</center></td><td><center>Nullable</center></td><td><center>Decimal Total Digits</center></td><td><center>Decimal Fractional Digits</center></td><td><center>Creator Name</center></td><td><center>Create Time Stamp</center></td><td><center>Char Type</center></td></tr>\r\n", $1) >> file_name;
    old_file_name = file_name;
  }
  printf("%s\r\n", $2) >> file_name;
}
END { ;}'