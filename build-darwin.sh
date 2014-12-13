#! /bin/bash

set -e
if [[ $# -lt 2 ]]; then
  echo "USAGE: $0 name gitrepo [commit]"
  exit 1
fi

export start=$PWD
export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

if [[ $4 != "" ]]; then
    date="$4"
fi

export tmp="/tmp/buildpackage-$date"
export srcdir="$tmp/$name-src"
export builddir="$tmp/$name-build"

sudo rm -rf "$srcdir" "$builddir"
mkdir -p "$srcdir" "$builddir"
cd $srcdir

git clone $gitrepo . 
if [[ $commit != "" ]]; then
  git checkout $commit
fi

cupsgroup="_lp" ./configure
sudo make install DESTDIR="$builddir"

cd "$start"

pkgbuild \
  --root "$builddir" \
  --identifier com.niftiestsoftware.ccp \
  --ownership preserve \
  --version "$date" \
  --scripts "$srcdir/packages/darwin" \
  "$start/$name-$date.pkg"

sudo rm -rf "$tmp"

