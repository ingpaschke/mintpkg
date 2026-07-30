pkgname=zlib
pkgver=1.3.1
pkgrel=1
source="https://zlib.net/fossils/zlib-1.3.1.tar.gz"
sha256="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
depends=""
target=unix
desc="compression library (static)"

build() {
    # zlib's configure respects CC/CFLAGS from env; static only, shared
    # libraries are not a thing we want to solve on MiNT in v1
    CHOST= ./configure --prefix=/usr --static
    make libz.a
}

package() {
    mkdir -p "$pkgdir/usr/lib" "$pkgdir/usr/include"
    cp libz.a "$pkgdir/usr/lib/"
    cp zlib.h zconf.h "$pkgdir/usr/include/"
}
