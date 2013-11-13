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

sudo mkdir -p $portdir/$category/$name-test
sudo cp out/$name-$date.ebuild $portdir/$category/$name-test/$name-test-$date.ebuild
cd $portdir/$category/$name-test
sudo ebuild $name-test-$date.ebuild digest
sudo emerge -v -1 =$category/$name-test-$date
$testscript $@