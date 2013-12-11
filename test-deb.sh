#! /bin/bash

set -e
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./test-deb.sh name category packagetestscript [package options]"
   exit 1
fi

if [[ "`whoami`" != 'root'  ]]; then
   echo "Need to run as root, will install package and test newly created deb"
   exit 1
fi

export start="`pwd`"
export name="$1"
export date="`date +%Y%m%d`"
export category="$2"
export testscript="$3"

cd /tmp/buildpackage/
debuild -ba $name\_$date-1_all.changes
dpkg -i $name\_$date-1_all.deb
$testscript $@
