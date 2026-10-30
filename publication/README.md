# Publication preparation files

The local candidate now has canonical [formalization metadata](../formalization.yaml),
[citation metadata](../CITATION.cff) and an [Apache-2.0 license](../LICENSE).
Igor Kortchemski explicitly confirmed authorship and responsibility. The intended repository is
`igor-kortchemski/rare-subtree-patterns`; it has not yet been created or populated by this task.
The former `.draft` files are superseded pointers, not alternative metadata.

The [full mechanical preflight workflow](../.github/workflows/palomar-preflight.yml) is prepared
at a pinned Palomar verifier revision and runs only when manually dispatched. It binds the
source commit, uses `mode: full` and `palomar-standard-v1`, and records the author/maintainer
relationship confirmed by the user. It performs predictive verification, not registry intake
or registration. The older `.template` file is historical; use the actual workflow.

The source relationship, four selected main declarations, supporting proofs and unformalized
background are documented in [the coverage report](../FORMALIZATION_REPORT.md).
See [PUBLICATION.md](../PUBLICATION.md) and [verification/README.md](../verification/README.md)
for current evidence and the remaining external verification steps.
