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

if [[ $4 != "" ]]; then
	date="$4"
fi

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

if [[ `fgrep -c "$date Simon Cadman <src@niftiestsoftware.com>" changelog` -lt 1 ]]; then
    mv changelog changelog.old
    echo "$date Simon Cadman <src@niftiestsoftware.com>

        * $date :
          Change: Automatically generated by buildpackage
" > changelog

    cat changelog.old >> changelog
    unlink changelog.old
fi

currentcommit="`git rev-parse HEAD`"

sed -i "s/pkgver=.*/pkgver=$date/g" PKGBUILD
sed -i "s/_gitversion=.*/_gitversion=\"$currentcommit\"/g" PKGBUILD

#eval `gpg-agent --daemon --pinentry-program /usr/bin/pinentry-curses`

if [[ "`whoami`" != 'root'  ]]; then
    makepkg --sign -s --noconfirm
    gpg --verify *.pkg.tar.xz.sig
    gpg -a --batch --detach-sign *.pkg.tar.xz
    gpg --verify *.pkg.tar.xz.asc
else
    chown -R builduser:builduser /tmp/buildpackage/
    sudo -u builduser makepkg --sign -s --noconfirm
    sudo -u builduser gpg --verify *.pkg.tar.xz.sig
    sudo -u builduser gpg -a --batch --detach-sign *.pkg.tar.xz
    sudo -u builduser gpg --verify *.pkg.tar.xz.asc
fi


cp *.pkg.tar.xz* $start/out/
echo "Files in `pwd` , upload `ls *.pkg.tar.xz` "
