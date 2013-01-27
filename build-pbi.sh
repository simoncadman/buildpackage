#! /usr/local/bin/bash
set -e
if [[ $# -lt 3 ]]; then
   echo "USAGE: ./build-pbi.sh name section gitrepo [commit]"
   exit
fi

export name="$1"
export section="$2"
export gitrepo="$3"
export commit="$4"
export date="`date +%Y%m%d`"

rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date/
cd /tmp/buildpackage/
git clone $gitrepo $name-$date
cd $name-$date 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
cd packages/freebsd
mkdir -p /tmp/$name
rsync -av ./ /usr/ports/$section/$name
pbi_makeport -o /tmp/$name/ $section/$name
echo "Package in /`ls /tmp/$name/*.pbi`"
