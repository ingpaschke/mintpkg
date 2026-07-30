# Recipe format v1

A recipe is a directory `recipes/<pkgname>/` containing `recipe.sh`, a POSIX
shell fragment sourced by `mpk-build`. It sets variables and defines two
functions. Keep recipes small; complexity belongs in patches, not recipes.

## Required variables

    pkgname=zlib            # [a-z0-9_-]+, must equal directory name
    pkgver=1.3.1            # upstream version
    pkgrel=1                # recipe revision, bump on recipe change
    source="https://..."    # whitespace-separated download URLs ("" = none)
    sha256="abc123..."      # one hash per source entry, same order
    depends=""              # whitespace-separated runtime deps (pkgnames)
    target=unix             # unix = ext2 root, gem = FAT C: drive
    desc="short one-liner"

## Optional variables

    arch="m68000 m68020-60 coldfire"   # restrict buildable arches; default all
    makedepends=""                     # host-side build deps (documentation only in v1)

## Functions

    build()    # cwd = extracted first source dir ($srcdir). Compile here.
    package()  # install into "$pkgdir" (acts as DESTDIR). Only files staged
               # into $pkgdir end up in the package.
    check()    # optional run-verification. Runs after package() when a
               # headless ARAnyM harness is available (MPK_MINT_RUN set) and
               # the arch is emulatable (m68000, m68020-60). The staged
               # package tree is visible in the guest at /e/pkg. Call
               # mpk_mint_run '<guest bash command>'; its stdout comes back,
               # its exit status fails the build on nonzero. Keep checks to a
               # few emulator boots (about 9 s each).

## Environment provided by mpk-build

    $srcdir      extraction/work directory
    $pkgdir      staging root, becomes the tarball
    $MPK_ARCH    native | m68000 | m68020-60 | coldfire
    $CC $AR $RANLIB $STRIP   set to the cross tools for $MPK_ARCH
    $CFLAGS      arch-appropriate (-m68020-60 etc.)

For `target=gem` packages, stage files under `$pkgdir/c/` which the client
maps to `C:\` (`/c/` under MiNT with the usual drive mapping).

## Patches

Files named `*.patch` in the recipe directory are applied with `patch -p1`
inside `$srcdir` after extraction, in lexical order. This is where mined
SpareMiNT SRPM patches go.

## Example

    pkgname=hello
    pkgver=1.0
    pkgrel=1
    source=""
    sha256=""
    depends=""
    target=unix
    desc="smoke-test package"

    build() {
        printf '%s\n' '#include <stdio.h>' \
            'int main(void){puts("hello from mintpkg");return 0;}' > hello.c
        "$CC" $CFLAGS -o hello hello.c
    }

    package() {
        mkdir -p "$pkgdir/usr/bin"
        cp hello "$pkgdir/usr/bin/hello"
    }
