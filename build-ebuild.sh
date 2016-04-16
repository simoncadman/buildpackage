#! /bin/bash
set -e
set -u

if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-ebuild.sh name workspace category"
   exit 1
fi

export start="`pwd`"
export name="$1"
export WORKSPACE="$2"
export date="`date +%Y%m%d`"
export category="$3"

cd "$WORKSPACE"
commit="`git rev-parse HEAD`"
cd "$start"
rm -rf "$WORKSPACE/.git"
rm -rf $start/ebuilds/
mkdir -p $start/ebuilds/

sed  "s/EGIT_COMMIT=\".*\"/EGIT_COMMIT=\"$commit\"/g" "$WORKSPACE/packages/gentoo/$name.ebuild" > "$start/ebuilds/$name-$date.ebuild"
mkdir -p /usr/local/portage/$category/$name/
echo 'masters = gentoo' > /usr/local/portage/layout.conf
cp "$start/ebuilds/$name-$date.ebuild" /usr/local/portage/$category/$name/
ebuild /usr/local/portage/$category/$name/$name-$date.ebuild digest
mkdir -p $start/ebuilds/$category/$name
cp usr/local/portage/$category/$name/* $start/ebuilds/$category/$name

echo "Ebuild created in $start/ebuilds/"
