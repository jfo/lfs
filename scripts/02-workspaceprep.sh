#!/bin/bash

git config --global user.name "Jeff Fowler"
git config --global user.email "jeffowler@gmail.com"

mount /dev/sda2 /mnt
mkdir -v /mnt/lfs
LFS=/mnt/lfs

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
wget --input-file=../sources/wget-list --continue --directory-prefix=$LFS/sources

cp ../sources/checksums $LFS/sources/
pushd $LFS/sources
md5sum -c checksums
popd

mkdir -v $LFS/tools
ln -sv $LFS/tools /

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

pushd ../bashrc
bash rc-copy.sh
popd

su lfs -c "mkdir /home/lfs/lfs 						&&\
	git clone https://github.com/urthbound/lfs /home/lfs/lfs 	&&\
	git config --global user.name 'Jeff Fowler'			&&\
	git config --global user.email 'jeffowler@gmail.com'"

rm -rf /root/lfs
su - lfs
