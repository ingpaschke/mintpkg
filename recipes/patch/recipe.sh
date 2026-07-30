pkgname=patch
pkgver=2.7.5
pkgrel=1
source="https://ftp.gnu.org/gnu/patch/patch-2.7.5.tar.xz"
sha256="fd95153655d6b95567e623843a0e77b81612d502ecf78a489a4aed7867caa299"
depends=""
target=unix
desc="GNU patch"

# Unpatched at rpmint's pinned version; 160k stack per rpmint.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,160k"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        ./configure $host --prefix=/usr --disable-nls
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run 'printf "old line\n" > /tmp/f;
        printf -- "--- f\n+++ f\n@@ -1 +1 @@\n-old line\n+new line\n" > /tmp/p;
        cd /tmp && /e/pkg/usr/bin/patch f < p >/dev/null && cat f' \
        | grep -q "new line"
}
