#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-ebuild.sh name gitrepo [commit]"
   exit
fi

export start="`pwd`"
export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"

rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date
cd /tmp/buildpackage/$name-$date
git clone $gitrepo .
if [[ $commit != ""  ]]; then
	git checkout $commit
else
	commit="`cat /tmp/buildpackage/$name-$date/.git/refs/heads/master`"
fi
rm -rf /tmp/buildpackage/$name-$date/.git
#cat packages/gentoo/$name.ebuild > $start/$name-$date.ebuild
sed  "s/EGIT_COMMIT=\".*\"/EGIT_COMMIT=\"$commit\"/g" /tmp/buildpackage/$name-$date/packages/gentoo/$name.ebuild > $start/$name-$date.ebuild
echo "Ebuild created as $start/$name-$date.ebuild"
