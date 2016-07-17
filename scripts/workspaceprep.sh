#!/bin/bash

mkdir -v $LFS/src
wget --input-file=../sources/wget-list --continue --directory-prefix=$LFS/src
wget --input-file=../sources/md5sums --continue --directory-prefix=$LFS/src
pushd $LFS/src
md5sum -c md5sums
popd

mkdir -v $LFS/src/patches
wget --input-file=../sources/patches --continue --directory-prefix=$LFS/src/patches
wget --input-file=../sources/patchsums --continue --directory-prefix=$LFS/src/patches
pushd $LFS/src/patches
md5sum -c md5sums
popd

mkdir -v $LFS/tools
ln -sv $LFS/tools /

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources
su - lfs
