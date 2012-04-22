#! /bin/bash
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./buildpackage name gitrepo [commit]"
   exit
fi

export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

rm -rf /tmp/$name-$date
mkdir -p /tmp/$name-$date
cd /tmp/$name-$date
git clone $gitrepo . 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
rm -rf /tmp/$name-$date/.git
cd /tmp/
tar cjf $name\_$date.orig.tar.bz2 $name-$date
cd $name-$date
mv packages/debian debian
rm -rf packages
debuild -S
