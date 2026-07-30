pkgname=findutils
pkgver=4.7.0
pkgrel=1
source="https://ftp.gnu.org/gnu/findutils/findutils-4.7.0.tar.xz"
sha256="c5fefbdf9858f7e4feb86f036e1247a54c79fc2d8e4b7064d5aaa1f47dfa789a"
depends=""
target=unix
desc="GNU find, xargs, locate"

# xautofs + mint patches from Thorsten Otto's rpmint; 128k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,128k"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc" "$pkgdir/usr/var"
}

check() {
    mpk_mint_run '/e/pkg/usr/bin/find /e/pkg/usr/bin -name xargs' \
        | grep -q xargs
}
