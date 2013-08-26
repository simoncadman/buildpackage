#! /usr/local/bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-freebsd.sh name gitrepo [commit]"
   exit
fi

export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date/
cd /tmp/buildpackage/
git clone $gitrepo $name-$date
cd $name-$date 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
tar czf /usr/ports/distfiles/cupscloudprint-$date.tar.gz ./
cd packages/freebsd
export FORCE_PKG_REGISTER=1
make package
echo "Package in `pwd`/`ls *.tbz`"
