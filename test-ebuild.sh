#! /bin/bash

set -e
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./test-ebuild.sh name category packagetestscript [package options]"
   exit 1
fi

export start="`pwd`"
export name="$1"
export date="`date +%Y%m%d`"
export category="$2"
export portdir="/usr/local/portage"
export testscript="$3"

sudo mkdir -p $portdir/$category/$name
sudo cp out/$name-$date.ebuild $portdir/$category/$name/$name-$date.ebuild
cd $portdir/$category/$name
sudo ebuild $name-$date.ebuild digest
sudo emerge -q -1 =$category/$name-$date
$testscript $@