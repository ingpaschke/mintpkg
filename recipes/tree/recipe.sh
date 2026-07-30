pkgname=tree
pkgver=1.8.0
pkgrel=1
source="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/1.8.0/unix-tree-1.8.0.tar.gz"
sha256="a983144d27a72080a3b6039216e3dfec5c8c5c989be349e7feab69c0c75e1cfe"
depends=""
target=unix
desc="display directory tree"

# Patches from Thorsten Otto's rpmint. Original home (mama.indstate.edu)
# is dead; source now fetched from the maintained gitlab mirror, same 1.8.0
# content. rpmint used a 128k stack for this one.

build() {
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,128k"
    # old codebase vs modern compilers: gnu99 keeps C23 'bool' out of the
    # way and the -Wno flag downgrades pointer-mismatch hard errors; both
    # accepted by the older cross compilers too
    make CC="$CC" \
        CPU_CFLAGS="$CFLAGS -std=gnu99 -Wno-incompatible-pointer-types" \
        LDFLAGS="-s $CFLAGS $stack" tree
}

package() {
    mkdir -p "$pkgdir/usr/bin" "$pkgdir/usr/share/man/man1"
    cp tree "$pkgdir/usr/bin/"
    cp doc/tree.1 "$pkgdir/usr/share/man/man1/"
}
