pkgname=make
pkgver=4.2.1
pkgrel=1
source="https://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz"
sha256="e40b8f018c1da64edd1cc9a6fce5fa63b2e707e404e20cad91fbae337c98a5b7"
depends=""
target=unix
desc="GNU make"

# clockskew + test-timeout patches from Thorsten Otto's rpmint; his flags:
# --disable-load (no dlopen on MiNT) --disable-nsec-timestamps; 160k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,160k"
    # gnu17: pre-C23 codebase (K&R definitions in glob/), breaks under
    # gcc 15 defaults
    CFLAGS="$CFLAGS -fomit-frame-pointer -std=gnu17" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls --disable-load \
        --disable-nsec-timestamps
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc" \
        "$pkgdir/usr/include"
}

check() {
    # SHELL line: guest sys-root ships bash but no /bin/sh
    mpk_mint_run 'mkdir -p /tmp/mk && cd /tmp/mk;
        printf "SHELL=/bin/bash\nall:\n\t@echo make-works\n" > Makefile;
        /e/pkg/usr/bin/make' | grep -q make-works
}
