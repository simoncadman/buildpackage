#! /bin/bash

set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./test-ebuild.sh name category [packagetestscript] [package options]"
   exit 1
fi

if [[ "`whoami`" != 'root'  ]]; then
   echo "Need to run as root, will install package and test newly created ebuild"
   exit 1
fi

export start="`pwd`"
export name="$1"
export date="`date +%Y%m%d`"
export category="$2"
export portdir="/usr/local/portage"
export testscript="$3"
export uninstalledtestscript="$4"
if [[ $6 != "" ]]; then
        date="$6"
fi

emerge --search $name

emerge -q -1 =$category/$name-$date::local
if [[ $testscript != "" ]]; then
    $testscript $@
fi
if [[ $uninstalledtestscript != "" ]]; then
    cp $uninstalledtestscript /tmp/test-remove
    emerge -C $category/$name::local
    /tmp/test-remove $@
    unlink /tmp/test-remove
fi
