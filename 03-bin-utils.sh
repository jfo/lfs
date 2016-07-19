# this would be run from the "build" directory after extraction. eventually I'll automate that too.

../configure 				\ 
	--prefix=/tools 		\
	--with-sysroot=$LFS 		\
	--with-lib-path=/tools/lib 	\
	--target=$LFS_TGT 		\
	--disable-nls  			\
	--disable-werror

make -j4

case $(uname -m) in
	x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;; 
esac

make install
