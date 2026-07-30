pkgname=bzip2
pkgver=1.0.8
pkgrel=1
source="https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
sha256="ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"
depends=""
target=unix
desc="block-sorting file compressor and libbz2 (static)"

# 0001-mint.patch is from Thorsten Otto's rpmint collection
# (bzip2-1.0.6-patch-0006-mint.patch): __set_binmode for MiNT libc plus
# const-correctness fixes.

build() {
    # MiNT executables need an explicit stack; 256k matches rpmint
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    # explicit targets: the default 'all' runs the test suite, which cannot
    # execute cross-built binaries
    make CC="$CC" AR="$AR" RANLIB="$RANLIB" \
        CFLAGS="$CFLAGS $stack -D_FILE_OFFSET_BITS=64" \
        libbz2.a bzip2 bzip2recover
}

package() {
    mkdir -p "$pkgdir/usr/bin" "$pkgdir/usr/lib" "$pkgdir/usr/include"
    cp bzip2 bzip2recover "$pkgdir/usr/bin/"
    ln -sf bzip2 "$pkgdir/usr/bin/bunzip2"
    ln -sf bzip2 "$pkgdir/usr/bin/bzcat"
    cp libbz2.a "$pkgdir/usr/lib/"
    cp bzlib.h "$pkgdir/usr/include/"
}
