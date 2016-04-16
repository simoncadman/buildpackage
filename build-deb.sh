#! /bin/bash
set -e
set -u
set -v

if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-deb.sh name workspace"
   exit 1
fi

export start="`pwd`"
export name="$1"
export workspace="$2"
export date="`date +%Y%m%d`"

mv "$workspace" "~/$name-$date"
cd ~/$name-$date
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
cd ..
tar cjf $name\_$date.orig.tar.bz2 $name-$date
cd $name-$date
debuild -S
mk-build-deps -i ../$name\_$date-1.dsc -t "apt-get --no-install-recommends -y"
debuild -A
dpkg-sig --sign builder ../$name\_$date-1_*.deb
if [[ "`dpkg-sig --verify ../$name\_$date-1_*.deb | grep -c GOODSIG`" -lt 1 ]]; then
    echo "Missing signature"
    exit 1
fi

cp ../$name\_$date.orig.tar.bz2 $start/out/
cp ../$name\_$date-1* $start/out/
echo "Files in $start/out/ , run dput changes file"
