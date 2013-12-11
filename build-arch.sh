#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-arch.sh name gitrepo [commit]"
   exit 1
fi

export start="`pwd`"
export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

rm -rf $start/out/
mkdir -p $start/out/

rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date/
cd /tmp/buildpackage/
git clone $gitrepo $name-$date
cd $name-$date 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
cd packages/arch
eval `gpg-agent --daemon --pinentry-program /usr/bin/pinentry-curses`
makepkg --sign

cp *.pkg.tar.xz/ $start/out/
echo "Files in `pwd` , upload `ls *.pkg.tar.xz` "
