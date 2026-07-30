pkgname=diffutils
pkgver=3.6
pkgrel=1
source="https://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz"
sha256="d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6"
depends=""
target=unix
desc="GNU diff, cmp, sdiff, diff3"

# mint patch from Thorsten Otto's rpmint; his flags: --disable-nls, 128k stack.

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
    mpk_mint_run 'printf "a\nb\n" > /tmp/f1; printf "a\nc\n" > /tmp/f2;
        /e/pkg/usr/bin/diff /tmp/f1 /tmp/f2; test $? = 1 && echo diff-ok' \
        | grep -q diff-ok
}
