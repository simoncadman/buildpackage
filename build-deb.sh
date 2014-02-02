#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-deb.sh name gitrepo [commit]"
   exit 1
fi

export start="`pwd`"
export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

rm -rf $start/out/
mkdir -p $start/out/

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
cd $name-$date
mv packages/debian debian

if [[ `fgrep -c "$name ($date-1)" debian/changelog` -lt 1 ]]; then
    # only add stub entry if one doesnt already exist
    mv debian/changelog debian/changelog.old
    echo "$name ($date-1) precise; urgency=low

  * Change: Automatically generated by buildpackage

 -- simon cadman <src@niftiestsoftware.com>  `date -R`
    " > debian/changelog
    cat debian/changelog.old >> debian/changelog
    unlink debian/changelog.old
fi

rm -rf packages
if [[ `fgrep -Ro "#! /usr/bin/env python2" *.py | wc -l` -gt 0 ]]; then
    echo "Compiling python packages"
    python2 -m compileall .
fi
cd /tmp/buildpackage/
tar cjf $name\_$date.orig.tar.bz2 $name-$date
cd $name-$date
debuild -S
debuild -A
dpkg-sig --sign builder ../$name\_$date-1_*.deb
if [[ "`dpkg-sig --verify ../$name\_$date-1_*.deb | grep -c GOODSIG`" -lt 1 ]]; then
    echo "Missing signature"
    exit 1
fi

cp ../$name\_$date-1.dsc $start/out/
cp ../$name\_$date.orig.tar.bz2 $start/out/
cp ../$name\_$date-1_* $start/out/
echo "Files in /tmp/buildpackage/ , run dput changes file"
