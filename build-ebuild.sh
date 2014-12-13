#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-ebuild.sh name gitrepo [commit]"
   exit 1
fi

export start="`pwd`"
export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"
export isbranch="$5"

if [[ $4 != "" ]]; then
    date="$4"
fi

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
rm -rf $start/out/
mkdir -p $start/out/

if [[ $isbranch == "branch" ]]; then
    sed  "s/EGIT_COMMIT=\".*\"/EGIT_BRANCH=\"$commit\"/g" /tmp/buildpackage/$name-$date/packages/gentoo/$name.ebuild > $start/out/$name-$date.ebuild    
else
    sed  "s/EGIT_COMMIT=\".*\"/EGIT_COMMIT=\"$commit\"/g" /tmp/buildpackage/$name-$date/packages/gentoo/$name.ebuild > $start/out/$name-$date.ebuild    
fi

echo "Ebuild created as $start/out/$name-$date.ebuild"
