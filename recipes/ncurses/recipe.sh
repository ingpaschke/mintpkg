pkgname=ncurses
pkgver=6.4
pkgrel=1
source="https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz"
sha256="6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159"
depends=""
target=unix
desc="terminal handling library (static, built-in fallback terminals)"

# Patch set from Thorsten Otto's rpmint. Simplified relative to his dual
# host+target build: common terminals are compiled into libncurses as
# fallbacks (host tic/infocmp generate fallback.c) and the on-disk terminfo
# database is not installed, sidestepping the host-vs-target tic version
# question. ABI 6, no widec, no shared, no C++.

build() {
    host=""
    [ "$MPK_ARCH" != native ] && host="--host=m68k-atari-mint"
    stack=""
    [ "$MPK_ARCH" != native ] && stack="-Wl,-stack,128k"
    CFLAGS="$CFLAGS -fomit-frame-pointer" LDFLAGS="$stack" \
        TIC_PATH=$(command -v tic) INFOCMP_PATH=$(command -v infocmp) \
        ./configure $host --prefix=/usr \
        --without-ada --without-cxx --without-cxx-bindings \
        --without-shared --without-cxx-shared --without-gpm \
        --without-debug --without-profile --without-manpages \
        --without-progs --without-tests \
        --disable-db-install --disable-root-environ \
        --disable-rpath --disable-rpath-hack --disable-stripping \
        --enable-symlinks --enable-const --enable-sigwinch \
        --enable-no-padding --enable-sp-funcs \
        --disable-widec --with-abi-version=6 \
        --with-ospeed=speed_t --enable-mixed-case=yes --with-xterm-kbs=del \
        --with-fallbacks="xterm,xterm-256color,linux,vt100,vt102,vt52,ansi,tw52,st52,dumb"
    make
}

package() {
    make DESTDIR="$pkgdir" install
    rm -rf "$pkgdir/usr/share/doc"
}

# library-only package: no on-target binary to run, so no check()
