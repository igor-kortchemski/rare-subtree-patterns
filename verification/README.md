# Verification evidence

The reviewed publication interface uses normalized weak attraction directly, without the
unused truncated-moment conjunct. All results below concern the pinned Lean/mathlib 4.35.0
candidate. The table records local evidence; the GitHub checks below identify their
own exact commit and remain separate from sandboxed Comparator and full Palomar verification.

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

## GitHub CI and full preflight

[CI run 41101096161](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101096161)
completed successfully for `81fbaf90a44aa3f8ae7807306288990dde3756ba` on Ubuntu.
It checked out the candidate afresh, restored canonical Mathlib cache, built the library
(3,464 jobs), compared 426 shared definition lines, built Challenge/Solution (3,467 jobs)
and audited 1,986 project declarations with zero forbidden dependencies. This does not
claim a from-source rebuild of Mathlib. The public documentation revision preserves all
Lean sources, dependency/toolchain pins and Comparator configuration from that commit.

[Full-preflight run 41101135106](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101135106)
checked the same source identity using pipeline
`14aa8d6b3c2f14a8540605e37144560b9a00e7e7`, `mode: full`, profile `palomar-standard-v1`
and request ID `rare20261030`. Its mechanical report records `status: fail` in
`phase: preparation`: source fetch requires public access and failed while the repository
was private. Comparator, Lean and NanoDa were not run by that workflow.

The next [public-source run](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41105960433)
fetched `189178da782d875508c45c0b3f4c5792a99e5eb2`, then reported `license.mismatch` in
preparation. The root `LICENSE` has since been normalized by removing its extra SPDX
identifier line; its remaining bytes exactly match the official Apache-2.0 text.
The SPDX choice remains `Apache-2.0`. This correction receives a new source commit and
fresh checks; the failed run supplies no Comparator/kernel evidence.

The local `lake comparator --config comparator.json` attempt exited 2 because bubblewrap
requires Linux namespaces (`comparator-platform.log`). No sandbox was disabled.
Standalone export replay does not replace canonical Challenge provenance checking or
Comparator. At this documentation freeze, a passing official Comparator/full Palomar
report remains pending. Fresh public-candidate runs are available under
[Lean CI](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml)
and [full preflight](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml).
Their reports identify the exact source commit; branch badges alone do not certify it.
