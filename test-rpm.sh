#! /bin/bash

set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./test-rpm.sh name category [packagetestscript] [package options]"
   exit 1
fi

if [[ "`whoami`" != 'root'  ]]; then
   echo "Need to run as root, will install package and test newly created rpm"
   exit 1
fi

export start="`pwd`"
export name="$1"
export category="$2"
export testscript="$3"
export uninstalledtestscript="$4"

PACKAGEMANAGER="yum"

if hash dnf > /dev/null 2>&1; then
	PACKAGEMANAGER="dnf"
fi

echo "Using $PACKAGEMANAGER for package manager"

$PACKAGEMANAGER install -y /$HOME/rpmbuild/RPMS/noarch/$name-*-1.noarch.rpm
if [[ $testscript != "" ]]; then
    $testscript $@
fi
if [[ $uninstalledtestscript != "" ]]; then
    cp $uninstalledtestscript /tmp/test-remove
    $PACKAGEMANAGER remove -y $name
    /tmp/test-remove $@
    unlink /tmp/test-remove
fi
