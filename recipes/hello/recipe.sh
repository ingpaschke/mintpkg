pkgname=hello
pkgver=1.0
pkgrel=1
source=""
sha256=""
depends=""
target=unix
desc="smoke-test package for the mintpkg pipeline"

build() {
    printf '%s\n' '#include <stdio.h>' \
        'int main(void){puts("hello from mintpkg");return 0;}' > hello.c
    "$CC" $CFLAGS -o hello hello.c
}

package() {
    mkdir -p "$pkgdir/usr/bin"
    cp hello "$pkgdir/usr/bin/hello"
}

check() {
    mpk_mint_run '/e/pkg/usr/bin/hello' | grep -q "hello from mintpkg"
}
