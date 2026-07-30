pkgname=gzip
pkgver=1.9
pkgrel=1
source="https://ftp.gnu.org/gnu/gzip/gzip-1.9.tar.xz"
sha256="ae506144fc198bd8f81f1f4ad19ce63d5a2d65e42333255977cf1dcf1479089a"
depends=""
target=unix
desc="GNU gzip compression utilities"

# Patches 0001-0008 are from Thorsten Otto's rpmint collection, applied in
# his PATCHES order. 0007-mint.patch carries the MiNT port (68k asm match.c,
# tailor.h); version 1.9 pinned to match the patch set.
#
# Native builds fail on modern glibc (the bundled 2018 gnulib predates it);
# cross builds against mintlib are the supported targets.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run 'echo gzip check data > /tmp/t;
        /e/pkg/usr/bin/gzip -c /tmp/t > /tmp/t.gz;
        /e/pkg/usr/bin/gzip -d -c /tmp/t.gz' | grep -q "gzip check data"
}
