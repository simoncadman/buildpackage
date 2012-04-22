#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./buildpackage name gitrepo [commit]"
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
tar cjf $name\_$date.orig.tar.bz2 $name-$date
cd $name-$date
mv packages/debian debian
rm -rf packages
debuild -S
echo "Files in /tmp/buildpackage/ , run dput changes file"
