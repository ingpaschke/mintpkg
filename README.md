# mintpkg

A modern, CI-built package distribution platform for FreeMiNT / Atari systems.

Successor idea to SpareMiNT: instead of a hand-maintained RPM repository,
packages are described by small recipe files, cross-compiled automatically by
CI, and published as a static, signed file tree that any web server or mirror
can host. The on-device client is a small POSIX shell script that runs under
the bash already shipped with every MiNT distribution.

## Design goals

- **Zero-server**: the repository is static files (tarballs + one index).
  Hosted on GitHub Pages, mirrored by anyone with rsync. Survives maintainer
  loss.
- **No TLS required on device**: 68k TLS is painful. Integrity comes from a
  minisign (ed25519) signature over the index; ed25519 verify is cheap.
  Transport can be plain HTTP or sneakernet.
- **Multi-arch from day one**: `m68000`, `m68020-60`, `coldfire`, plus
  `native` for host-side testing of the pipeline.
- **Hybrid FS aware**: every package declares `target=unix` (ext2 root) or
  `target=gem` (FAT `C:` drive), matching the TOS/Unix split used by current
  distro images.
- **Recipes are the community interface**: one small shell file per package,
  APKBUILD-style. Contributions are pull requests; CI does the building.

## Layout

    recipes/<name>/recipe.sh   package build recipes
    tools/mpk-build            builds one recipe -> out/<pkg>-<ver>-<arch>.tar.gz
    tools/mpk-genindex         generates + optionally signs the repo index
    client/mpk                 on-device package manager (POSIX sh)
    docs/recipe-format.md      recipe spec
    docs/index-format.md       index spec
    .github/workflows/         CI: build all recipes, publish repo to Pages

## Quick demo (host, no cross-toolchain needed)

    MPK_ARCH=native tools/mpk-build recipes/hello
    tools/mpk-genindex out/
    MPK_REPO=$PWD/out MPK_ROOT=/tmp/fakeroot client/mpk install hello

## Cross builds

Install a m68k-atari-mint toolchain (Vincent Riviere's PPA
`ppa:vriviere/ppa`, or mikro's binaries), then:

    MPK_ARCH=m68020-60 tools/mpk-build recipes/zlib

## Status

Proof of concept. Roadmap:

- [ ] C client (drop bash/coreutils dependency for base install)
- [ ] GEM front-end / stool-style web UI
- [ ] Mine SpareMiNT SRPM patch archive for recipes
- [ ] Repo signing key ceremony + mirror docs
- [ ] mintelf vs a.out ABI variants once the ecosystem settles
