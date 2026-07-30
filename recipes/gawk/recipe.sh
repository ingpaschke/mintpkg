pkgname=gawk
pkgver=4.1.4
pkgrel=1
source="https://ftp.gnu.org/gnu/gawk/gawk-4.1.4.tar.xz"
sha256="53e184e2d0f90def9207860531802456322be091c7b48f23fdc79cda65adc266"
depends=""
target=unix
desc="GNU awk"

# mint patch from Thorsten Otto's rpmint (test-time patch kept for patch-set
# fidelity; his libexecdir patch dropped: it only relocates awklib helpers,
# which we do not ship, and patching Makefile.am would force an automake
# regeneration); 256k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    # gnu17: pre-C23 codebase, () prototypes break under gcc 15 defaults.
    # mktime cache var: cross-configure guesses broken and the gnulib
    # replacement then collides with mintlib's at link time.
    CFLAGS="$CFLAGS -fomit-frame-pointer -std=gnu17" LDFLAGS="$stack" \
        ac_cv_func_working_mktime=yes \
        ./configure $host --prefix=/usr --disable-nls
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/info" "$pkgdir/usr/share/doc" \
        "$pkgdir/usr/lib/gawk" "$pkgdir/usr/libexec"
}

check() {
    mpk_mint_run 'printf "1 2\n3 4\n" | /e/pkg/usr/bin/gawk "{s+=\$2} END{print s}"' \
        | grep -q "^6$"
}
