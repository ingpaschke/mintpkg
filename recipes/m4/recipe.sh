pkgname=m4
pkgver=1.4.18
pkgrel=1
source="https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
sha256="f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"
depends=""
target=unix
desc="GNU m4 macro processor"

# rpmint's pinned version, unpatched; his flags. Old gnulib: native builds
# on modern glibc break, cross targets are the supported ones. 256k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    CFLAGS="$CFLAGS -fomit-frame-pointer -std=gnu17" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls --without-included-regex
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run 'printf "define(X,42)X\n" | /e/pkg/usr/bin/m4' | grep -q "^42$"
}
