# Current local verification evidence

The reviewed publication interface uses normalized weak attraction directly, without the
unused truncated-moment conjunct. All results below concern the pinned Lean/mathlib 4.35.0
candidate. They are local evidence, separate from sandboxed Comparator and Palomar verification.

| Check | Current result | Evidence |
| --- | --- | --- |
| Library build | Exit 0, 3,464 jobs, no warnings | `build.log` |
| Challenge/Solution build | Exit 0; only four deliberate Challenge-hole warnings | `challenge-build.log` |
| Whole-library axiom audit | 1,986 declarations, zero forbidden dependencies | `axiom-audit.log` |
| Guard negative control | Artificially disallowed standard axiom is detected; Lean exits 1 | `axiom-audit-negative-control.log` |
| Exact types and representative axioms | Exit 0; only propext, Classical.choice, Quot.sound | `axioms.log` |
| Local semantic comparison | PASS; 25,899 constants, 71 project constants, zero mismatches | `statement-closure.log` |
| Source scan | 112 Lean files; 107 library modules all root-reachable; no implementation holes/native axioms | `content-checks.log` |
| Standalone export | Four selected theorem proof closures; 405,504,858 bytes | `solution-export.log` |
| Independent NanoDa replay | Exit 0; 56,903 declarations, no type-checker errors | `nanoda.log` |
| Lean kernel replay of same export | Exit 0; kernel accepts solution | `leanchecker.log` |

NanoDa logs one **pretty-printer** diagnostic, `Unable to print axioms`; it reports zero
**type-checker** errors and exits successfully. The configuration rejects all unpermitted
axioms, permits only the three standard axioms and does not enable `unsafe_permit_all_axioms`.
The independent replay covers the four selected theorem proof closures, not every unused
library declaration.

The export SHA-256 is
`262eca9e22c51c17f67df35b2ef01af1fbb9c26324fe1e2f1cfa8b10c4813bcc`.
It uses exporter/format 3.1.0 and Lean commit
`eb6cafb7290e8bd5f2937522d8d804f58f02bafc`.
The generated export is under `.lake/verification/`, excluded from the repository.

## Reproduction

Run from the project root:

```sh
lake build
lake build Challenge Solution
lake env lean verification/Axioms.lean
lake env lean verification/AxiomAudit.lean
lake env lean verification/StatementClosure.lean
bash verification/check-challenge-defs.sh
python3 -I verification/content-checks.py
mkdir -p .lake/verification
lake env leanexport Solution -- PoissonDeclumping.poissonApproximation PoissonDeclumping.poissonApproximation2 PoissonDeclumping.maxString PoissonDeclumping.maxLeafHeight > .lake/verification/solution.ndjson
lake env nanoda_bin verification/nanoda-config.json
lake env leanchecker --from-export .lake/verification/solution.ndjson
sh verification/make-hashes.sh
```

`Axioms.lean`, `AxiomAudit.lean` and `StatementClosure.lean` are diagnostics, not imports of
the proof library. The source hashes identify the current source/configuration tree.
The source list excludes `.git`, `.lake`, evidence logs and the generated list itself.

`clean-build.log` is **historical** evidence for the earlier source hash named in the report;
it is not a clean build of the changed interface. The current local build reuses pinned
dependency artifacts. It does not claim a clean Linux checkout build.

## External checks still pending

`lake comparator --config comparator.json` was attempted with its default sandbox and exited 2
because bubblewrap requires Linux namespaces (`comparator-platform.log`). No sandbox was disabled.
Standalone export replay does not replace the canonical Challenge provenance audit or official
Comparator. The clean public Linux build, GitHub CI and full Palomar preflight remain pending.
The prepared manual workflow is `.github/workflows/palomar-preflight.yml`.
