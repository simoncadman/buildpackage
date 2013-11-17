#! /bin/bash

set -e
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./test-ebuild.sh name category packagetestscript [package options]"
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

mkdir -p $portdir/$category/$name
cp out/$name-$date.ebuild $portdir/$category/$name/$name-$date.ebuild
cd $portdir/$category/$name
ebuild $name-$date.ebuild digest
emerge -q -1 =$category/$name-$date
$testscript $@
