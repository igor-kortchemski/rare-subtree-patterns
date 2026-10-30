#!/usr/bin/env bash
# Check that `Challenge.lean` is exactly `PoissonDeclumping/Statements/Defs.lean` plus the final
# theorem section, apart from the two module docstrings.
#
# Usage (from anywhere): bash verification/check-challenge-defs.sh
# Exit status 0: the texts agree. Exit status 1: they differ (a unified diff is printed).
# Exit status 2: a file or the theorem-section marker is missing.
#
# What is compared: each file with its first `/-!` ... `-/` block (the module docstring) removed;
# for `Challenge.lean`, also everything from the marker line
#   /-! ### The four Introduction theorems (deliberate Challenge holes)
# to the end of the file. Everything else (header, imports and their order, `open`s, section
# comments, declarations, docstrings, blank lines) must be identical.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
challenge="$root/Challenge.lean"
defs="$root/PoissonDeclumping/Statements/Defs.lean"
marker='/-! ### The four Introduction theorems (deliberate Challenge holes)'

for f in "$challenge" "$defs"; do
  [[ -f "$f" ]] || { echo "missing file: $f" >&2; exit 2; }
done
count="$(grep -cF -- "$marker" "$challenge" || true)"
if [[ "$count" != 1 ]]; then
  echo "expected exactly one theorem-section marker in Challenge.lean, found $count" >&2
  exit 2
fi
if grep -qF -- "$marker" "$defs"; then
  echo "the theorem-section marker must not occur in Statements/Defs.lean" >&2
  exit 2
fi

# Drop the first `/-!` ... `-/` block (the module docstring).
strip_module_doc() {
  awk 'state == 0 && /^\/-!/ { state = 1; if ($0 ~ /-\/[[:space:]]*$/) state = 2; next }
       state == 1 { if ($0 ~ /-\/[[:space:]]*$/) state = 2; next }
       { print }' "$1"
}
# Drop the theorem section and the blank lines just before it.
strip_theorems() {
  awk -v m="$marker" 'index($0, m) == 1 { exit } { print }' | awk '
    { lines[NR] = $0 }
    END { n = NR; while (n > 0 && lines[n] == "") n--; for (i = 1; i <= n; i++) print lines[i] }'
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
strip_module_doc "$challenge" | strip_theorems > "$tmp/challenge-defs.lean"
strip_module_doc "$defs" > "$tmp/library-defs.lean"

if diff -u "$tmp/library-defs.lean" "$tmp/challenge-defs.lean"; then
  echo "OK: Challenge.lean = PoissonDeclumping/Statements/Defs.lean + theorem section" \
    "($(wc -l < "$tmp/library-defs.lean" | tr -d ' ') shared lines)"
else
  echo "MISMATCH: Challenge.lean and PoissonDeclumping/Statements/Defs.lean have drifted" >&2
  exit 1
fi
