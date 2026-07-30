pkgname=zstd
pkgver=1.5.5
pkgrel=1
source="https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz"
sha256="9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4"
depends=""
target=unix
desc="Zstandard compression utility and libzstd (static)"

# Patches from Thorsten Otto's rpmint (compiler.h + posix guards).
# Makefile-based build; explicit targets, no tests. rpmint used a 256k stack.

build() {
    # rpmint renames this before applying the include-rewrite patch:
    # "compiler.h" collides with mintlib's system header of the same name
    mv lib/common/compiler.h lib/common/zcompiler.h
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    # no threading on MiNT; single-threaded zstd binary + static lib
    make -C lib libzstd.a CC="$CC" AR="$AR" \
        CFLAGS="$CFLAGS -fomit-frame-pointer" \
        ZSTD_LIB_MINIFY=0
    make -C programs zstd CC="$CC" AR="$AR" \
        CFLAGS="$CFLAGS -fomit-frame-pointer" \
        LDFLAGS="$stack" \
        HAVE_THREAD=0 HAVE_ZLIB=0 HAVE_LZMA=0 HAVE_LZ4=0 BACKTRACE=0
}

package() {
    mkdir -p "$pkgdir/usr/bin" "$pkgdir/usr/lib" "$pkgdir/usr/include"
    cp programs/zstd "$pkgdir/usr/bin/"
    ln -sf zstd "$pkgdir/usr/bin/unzstd"
    ln -sf zstd "$pkgdir/usr/bin/zstdcat"
    cp lib/libzstd.a "$pkgdir/usr/lib/"
    cp lib/zstd.h lib/zdict.h lib/zstd_errors.h "$pkgdir/usr/include/"
}

check() {
    mpk_mint_run 'echo zstd check data > /tmp/t;
        /e/pkg/usr/bin/zstd -z -c /tmp/t > /tmp/t.zst;
        /e/pkg/usr/bin/zstd -d -c /tmp/t.zst' | grep -q "zstd check data"
}
