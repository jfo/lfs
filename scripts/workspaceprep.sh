#!/bin/bash

git config --global user.name "Jeff Fowler"
git config --global user.email "jeffowler@gmail.com"

mount /dev/sda2 /mnt
mkdir -v /mnt/lfs
LFS=/mnt/lfs

mkdir -v $LFS/src
wget --input-file=../sources/wget-list --continue --directory-prefix=$LFS/src

cp ../sources/checksums $LFS/src/
pushd $LFS/src
md5sum -c checksums
popd

mkdir -v $LFS/tools
ln -sv $LFS/tools /

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/src

pushd ../bashrc
bash rc-copy.sh
popd

su - lfs
