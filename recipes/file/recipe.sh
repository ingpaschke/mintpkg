pkgname=file
pkgver=5.45
pkgrel=1
source="https://astron.com/pub/file/file-5.45.tar.gz"
sha256="fc97f51029bb0e2c9f4e3bffefdaf678f0e039ee872b9de5c002a6d09c784d82"
depends=""
target=unix
desc="file type identification utility with libmagic"

# Patch set from Thorsten Otto's rpmint. Cross builds need a native file
# binary of the same version to compile the magic database, so a host copy
# is built first (same trick as his build script); 128k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,128k"

    # patches touch configure.ac/Makefile.am; regenerate like rpmint does
    autoreconf -fiv >/dev/null 2>&1

    if [ "$MPK_ARCH" != native ]; then
        mkdir -p hostbuild && cd hostbuild
        CC=cc CFLAGS=-O2 ../configure --disable-shared --disable-nls >/dev/null
        make -C src magic.h file >/dev/null 2>&1 || make >/dev/null
        cd ..
    fi

    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls --disable-shared \
        --enable-fsect-man5
    if [ "$MPK_ARCH" != native ]; then
        make FILE_COMPILE="$PWD/hostbuild/src/file"
    else
        make
    fi
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run '/e/pkg/usr/bin/file -m /e/pkg/usr/share/misc/magic.mgc /e/pkg/usr/bin/file' \
        | grep -qi "atari"
}
