pkgname=bison
pkgver=3.6.4
pkgrel=1
source="https://ftp.gnu.org/gnu/bison/bison-3.6.4.tar.xz"
sha256="8b13473b31ca7fcf65e5e8a74224368ffd5df19275602a9c9567ba393f18577d"
depends="m4"
target=unix
desc="GNU parser generator"

# rpmint's pinned version, unpatched. bison executes m4 at runtime, hence
# the dependency. 128k stack per rpmint.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,128k"
    CFLAGS="$CFLAGS -fomit-frame-pointer -std=gnu17" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run '/e/pkg/usr/bin/bison --version' | grep -q "bison.*3.6.4"
}
