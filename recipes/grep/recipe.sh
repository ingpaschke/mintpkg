pkgname=grep
pkgver=3.1
pkgrel=1
source="https://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz"
sha256="db625c7ab3bb3ee757b3926a5cfa8d9e1c3991ad24707a83dde8a5ef2bf7a07e"
depends=""
target=unix
desc="GNU grep"

# Version matches Thorsten Otto's rpmint build (unpatched for 3.1; his
# patches directory only holds obsolete 2.4.2 ones). 128k stack per rpmint.

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
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run 'printf "alpha\nbeta\n" | /e/pkg/usr/bin/grep beta'
}
