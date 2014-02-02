#! /bin/bash

set -e
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./test-arch.sh name category packagetestscript [package options]"
   exit 1
fi

if [[ "`whoami`" != 'root'  ]]; then
   echo "Need to run as root, will install package and test newly created arch package"
   exit 1
fi

export start="`pwd`"
export name="$1"
export date="`date +%Y%m%d`"
export category="$2"
export testscript="$3"
export uninstalledtestscript="$4"

pacman --noconfirm -U /tmp/buildpackage/out/$name-$date-1-*.pkg.tar.xz
$testscript $@
if [[ $uninstalledtestscript != "" ]]; then
    cp $uninstalledtestscript /tmp/test-remove
    pacman -R --noconfirm $name
    /tmp/test-remove $@
    unlink /tmp/test-remove
fi