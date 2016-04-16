#! /bin/bash
set -e
set -v

if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-ebuild.sh name workspace"
   exit 1
fi

export start="`pwd`"
export name="$1"
export workspace="$2"
export date="`date +%Y%m%d`"

ls -al $WORKSPACE
commit="`cat $WORKSPACE/.git/refs/heads/master`"
rm -rf /$WORKSPACE/.git
rm -rf $start/ebuilds/
mkdir -p $start/ebuilds/

sed  "s/EGIT_COMMIT=\".*\"/EGIT_COMMIT=\"$commit\"/g" /tmp/buildpackage/$name-$date/packages/gentoo/$name.ebuild > $start/ebuilds/$name-$date.ebuild
ebuild $start/ebuilds/$name-$date.ebuild  digest

echo "Ebuild created as $start/ebuilds/$name-$date.ebuild"
