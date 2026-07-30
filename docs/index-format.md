# Index format v1

The repository index is a single plain-text file `INDEX` at the repo root,
next to the package tarballs. Plain text, line-based, pipe-separated: awk and
sh on a 68030 parse it trivially, no JSON parser needed on device.

## Grammar

Comment lines start with `#`. The first line is a magic header:

    #mintpkg-index v1

Each package line:

    pkg|<name>|<version>-<rel>|<arch>|<deps>|<sha256>|<size>|<file>|<target>|<desc>

- `deps`: comma-separated pkgnames, empty allowed
- `size`: bytes of `<file>`
- `file`: tarball filename relative to the index
- `target`: `unix` or `gem`
- `desc`: free text, must not contain `|`

Example:

    #mintpkg-index v1
    pkg|hello|1.0-1|native|zlib|9f86d08...|3072|hello-1.0-1-native.tar.gz|unix|smoke-test package

## Signature

`INDEX.minisig` is a minisign (ed25519) signature over `INDEX`. The client
ships the public key and refuses unsigned repos unless `MPK_INSECURE=1`.
Package integrity chains from the signed index via the per-file sha256, so
tarballs themselves need no individual signatures and mirrors cannot tamper.

## Multi-arch

One index may mix arches. The client filters on its own arch plus `native`
is never selected on device; arch detection order: `$MPK_FORCE_ARCH`, then
`uname -m` mapping.
