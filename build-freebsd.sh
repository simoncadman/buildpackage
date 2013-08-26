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
else
        commit="`git log | head -n1 | cut -d' ' -f2`"
fi
commit="`echo $commit | cut -c1-7`"
OLDPWD="`pwd`"

mkdir -p /tmp/build-package/
cp -rp ./ /tmp/build-package/simoncadman-CUPS-Cloud-Print-$commit/

cd /tmp/build-package/
tar czf /usr/ports/distfiles/$name-$date.tar.gz simoncadman-CUPS-Cloud-Print-$commit

cd "$OLDPWD"
cd packages/freebsd
sed -i -r "s/^PORTVERSION=.*/PORTVERSION=    $date/" Makefile
sed -i -r "s/^GH_COMMIT=.*/GH_COMMIT=    $commit/" Makefile

shasum="`sha256 /usr/ports/distfiles/$name-$date.tar.gz | cut -d' ' -f4`"
size="`stat -f%z /usr/ports/distfiles/$name-$date.tar.gz`"
distinfo="SHA256 ($name-$date.tar.gz) = $shasum
SIZE ($name-$date.tar.gz) = $size"

echo "$distinfo" > distinfo

export FORCE_PKG_REGISTER=1
make package
echo "Package in `pwd`/`ls *.tbz`"
