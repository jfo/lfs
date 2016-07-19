../configure                                    \
        --prefix=/tools                         \
        --host=$LFS_TGT                         \
        --build=$(../scripts/config.guess)      \
        --enable-kernel=2.6.32                  \
        --with-headers=/tools/include           \
        libc_cv_forced_unwind-yes               \
        libc_cv_ctors_header=yes                \
        libc_cv_c_cleanup=yes

# can fail on parallel builds
make -j1
make install
