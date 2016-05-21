#! /bin/bash

set -e
if [[ $# -lt 2 ]]; then
  echo "USAGE: $0 name workspace"
  exit 1
fi

set -u

export start=$PWD
export name="$1"
export workspace="$2"
export date="`date +%Y%m%d`"

export tmp="/tmp/buildpackage-$date"
export builddir="$tmp/$name-build"

cd "$workspace"

cupsgroup="_lp" ./configure --prefix=/Library
sudo make install DESTDIR="$builddir"
sudo python -m compileall "$builddir"

cd "$start"
mkdir out

pkgbuild \
  --root "$builddir" \
  --identifier com.niftiestsoftware.ccp \
  --ownership preserve \
  --version "$date" \
  --scripts "$workspace/packages/darwin" \
  "$start/out/$name-$date.pkg"

sudo rm -rf "$tmp"

