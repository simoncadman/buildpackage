#! /bin/bash
echo $#
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./buildpackage "
   exit
fi
