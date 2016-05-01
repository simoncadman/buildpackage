#! /bin/bash

set -e

if [[ $# -lt 2 ]]; then
   echo "USAGE: ./test-darwin.sh name category [packagetestscript] [package options] [packagename]"
   exit 1
fi

if [[ "`whoami`" != 'root'  ]]; then
   echo "Need to run as root, will install package and test newly created deb"
   exit 1
fi

export start="`pwd`"
export name="$1"
export category="$2"
export testscript="$3"
export uninstalledtestscript="$4"
export packagename="$5"

trap 'echo exiting; tail -n100 /var/log/install.log' exit

installer -dumplog -verbose -pkg ${name}-*.pkg -target /
if [[ $testscript != "" ]]; then
    $testscript $@
fi
if [[ $uninstalledtestscript != "" ]]; then
    cp $uninstalledtestscript /tmp/test-remove
    cd "$start"
    pkgutil --pkgs
    pkgutil --forget --unlink $packagename
    /tmp/test-remove $@
    unlink /tmp/test-remove
    pkgutil --pkgs
fi
