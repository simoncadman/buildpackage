#! /bin/bash
set -e
if [[ $# -lt 2 ]]; then
   echo "USAGE: ./build-rpm.sh name gitrepo [commit] [arch]"
   exit 1
fi

export name="$1"
export gitrepo="$2"
export commit="$3"
export date="`date +%Y%m%d`"
export arch="noarch"

if [[ $5 != ""  ]]; then
	arch=$5
fi

rm -rf /tmp/buildpackage/$name-$date
mkdir -p /tmp/buildpackage/$name-$date/rpmbuild
cd /tmp/buildpackage/$name-$date/rpmbuild
mkdir {BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
cd SOURCES
git clone $gitrepo $name-$date
cd $name-$date 
if [[ $commit != ""  ]]; then
	git checkout $commit
fi
mv packages/redhat/SPECS/$name.spec /tmp/buildpackage/$name-$date/rpmbuild/SPECS/
rm -rf .git packages
cd ..
tar cjf $name-$date.tar.bz2 $name-$date
rm -rf $name-$date
rm -rf $HOME/rpmbuild
mkdir -p $HOME/rpmbuild/SOURCES
mv $name-$date.tar.bz2 $HOME/rpmbuild/SOURCES/
cd ..
rpmbuild -ba --sign SPECS/$name.spec --target $arch -D "_version $date"
echo "Files in $HOME/rpmbuild/RPMS , copy to /root/niftyreporpm/$arch/ , run upload and then upload to s3. "
