#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-rpm.sh name gitrepo [commit]"
   exit
fi

export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

mkdir -p /tmp/buildpackage
rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date
cd /tmp/buildpackage/$name-$date
git clone $gitrepo . 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
rm -rf /tmp/buildpackage/$name-$date/.git
cd /tmp/buildpackage/
echo "Files in /tmp/buildpackage/"
