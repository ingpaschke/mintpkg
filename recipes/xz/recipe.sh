pkgname=xz
pkgver=5.4.4
pkgrel=1
source="https://github.com/tukaani-project/xz/releases/download/v5.4.4/xz-5.4.4.tar.gz"
sha256="aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8"
depends=""
target=unix
desc="XZ/LZMA compression utilities and liblzma (static)"

# Version 5.4.4 matches Thorsten Otto's rpmint build (pre-backdoor lineage,
# no patches needed; his script builds it unpatched).

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$CFLAGS" \
        ./configure $host --prefix=/usr --disable-shared --disable-nls \
        --disable-scripts
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/doc"
}
