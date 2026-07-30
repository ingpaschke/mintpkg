pkgname=flex
pkgver=2.6.4
pkgrel=1
source="https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
sha256="e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
depends="m4"
target=unix
desc="fast lexical analyzer generator"

# Patches from Thorsten Otto's rpmint (extensions + help2man avoidance).
# flex executes m4 at runtime, hence the dependency. 256k stack.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,256k"
    # use-extensions patch touches configure.ac
    autoreconf -fiv >/dev/null 2>&1
    # malloc/realloc cache vars: cross guesses "broken", and the rpl_
    # replacements then break the build
    CFLAGS="$CFLAGS -fomit-frame-pointer -std=gnu17" LDFLAGS="$stack" \
        ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes \
        CFLAGS_FOR_BUILD="-O2 -std=gnu17" \
        ./configure $host --prefix=/usr --disable-nls --disable-shared
    make -C src
}

package() {
    make -C src DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/doc"
}

check() {
    mpk_mint_run '/e/pkg/usr/bin/flex --version' | grep -q "^flex 2.6.4"
}
