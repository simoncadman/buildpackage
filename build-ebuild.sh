#! /bin/bash
set -e
set -u

if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-ebuild.sh name workspace"
   exit 1
fi

export start="`pwd`"
export name="$1"
export WORKSPACE="$2"
export date="`date +%Y%m%d`"

cd "$WORKSPACE"
commit="`git rev-parse HEAD`"
cd "$start"
rm -rf "$WORKSPACE/.git"
rm -rf $start/ebuilds/
mkdir -p $start/ebuilds/

sed  "s/EGIT_COMMIT=\".*\"/EGIT_COMMIT=\"$commit\"/g" "$start/packages/gentoo/$name.ebuild" > "$start/ebuilds/$name-$date.ebuild"
ebuild $start/ebuilds/$name-$date.ebuild  digest

echo "Ebuild created as $start/ebuilds/$name-$date.ebuild"
