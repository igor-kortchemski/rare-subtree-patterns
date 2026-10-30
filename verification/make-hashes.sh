#!/bin/sh
# Regenerate verification/source-sha256.txt: per-file SHA-256 of every file of the candidate except
# build products (.lake), VCS data, macOS metadata, and the generated evidence files themselves, then an
# aggregate hash over that sorted list ("tree hash"), and an aggregate over the Lean sources + configuration.
# Run from the project root:  sh verification/make-hashes.sh
set -eu
out=verification/source-sha256.txt
files=$(find . -type f \
  ! -path './.lake/*' ! -path './.git/*' ! -name '.DS_Store' \
  ! -path './verification/source-sha256.txt' ! -path './verification/*.log' \
  | LC_ALL=C sort)
: > "$out"
for f in $files; do shasum -a 256 "$f" >> "$out"; done
tree=$(shasum -a 256 "$out" | cut -d' ' -f1)
src=$(grep -E '\.lean$|/lakefile\.toml$|/lake-manifest\.json$|/lean-toolchain$|/comparator\.json$|/poisson-declumping-arxiv\.tex$' "$out" | shasum -a 256 | cut -d' ' -f1)
{ echo "# tree-sha256 (hash of the per-file list above, evidence logs excluded): $tree"
  echo "# lean-and-config-sha256 (all .lean files, lakefile.toml, lake-manifest.json, lean-toolchain, comparator.json, paper source): $src"; } >> "$out"
echo "tree-sha256 $tree"
echo "lean-and-config-sha256 $src"
