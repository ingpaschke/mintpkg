pkgname=sed
pkgver=4.9
pkgrel=1
source="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
sha256="6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
depends=""
target=unix
desc="GNU stream editor"

# nothreads patch from Thorsten Otto's rpmint; his configure flags:
# --disable-nls --disable-threads --without-included-regex, 256k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls --disable-threads \
        --without-included-regex
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run 'echo hello mint | /e/pkg/usr/bin/sed s/mint/world/' \
        | grep -q "hello world"
}
