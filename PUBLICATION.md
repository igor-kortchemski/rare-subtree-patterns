# Publication candidate

Updated 30 October 2026. The publication repository is
[igor-kortchemski/rare-subtree-patterns](https://github.com/igor-kortchemski/rare-subtree-patterns).
It was created privately with proof candidate
`81fbaf90a44aa3f8ae7807306288990dde3756ba`. This documentation revision prepares the
authorized public candidate and records the completed checks on that proof snapshot.
Its Lean sources, toolchain, dependency pins and Comparator configuration are unchanged.
[verification/source-sha256.txt](verification/source-sha256.txt) identifies the files;
workflow runs bind their reports to the exact Git commit they checked.

## Mathematical claim

`comparator.json` selects exactly the four Introduction theorems, with the names
listed in [README.md](README.md). The repository also contains the reviewed
numbered results and supporting proofs, with periodic conditioning corrections
and substantive proof departures in [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).

The standing stable-domain assumption is now normalized weak convergence of the
actual centered offspring walk to the probability law with the specified Laplace
transform. An unused truncated-moment conjunct was removed after independent
review. The main results therefore do not ask the caller for an unproved
characterization theorem or assume the desired local-limit estimates.

As agreed, the formalized Potter theorem is the real-argument bound for the actual
normalization function. The general stable-domain characterization and full
functional Skorokhod J1 theorem remain explicitly unformalized cited background;
their required consequences are proved separately. Selecting four results for
Palomar does not claim whole-source completion or silently discharge the original
inventory obligations. See [INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md) for the
independent scope and standalone Challenge reviews.

## License, authorship and repository facts

The user explicitly chose **Apache-2.0**, confirmed **Igor Kortchemski** as the
formalization author and responsible maintainer, and chose the new repository name
**rare-subtree-patterns**. The connected GitHub account is `igor-kortchemski`.

The canonical files are [LICENSE](LICENSE), [formalization.yaml](formalization.yaml)
and [CITATION.cff](CITATION.cff). Claude and Codex are recorded as automated tools;
agent review is not described as human peer review. The original paper remains
unchanged and retains its own CC-BY-4.0 license. Installed skills retain their
notices under `.agents/skill-notices/`.

## Mechanical verification

The environment remains pinned to Lean `leanprover/lean4:v4.35.0` and canonical
mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679`, with the unchanged manifest.
Current commands, source hashes and results are documented in
[verification/README.md](verification/README.md). The Challenge and Solution build
separately; the only deliberate proof holes are the four isolated Challenge declarations.

The local statement-closure comparison checks the four theorem types and their
semantic definitions, but is not Comparator. Standalone replay of the selected proof export now passes both NanoDa and Lean
(the exact logs, export hash and nonfatal NanoDa pretty-printing diagnostic are in
`verification/README.md`). This does not imply a full Palomar mechanical pass. The pinned toolchain bundles `leanexport`, `leanchecker` and
`nanoda_bin`; they are available through `lake env` on this Mac.

The official sandboxed Comparator was attempted with the default sandbox and
returned exit 2: its bubblewrap sandbox requires Linux namespaces. No sandbox was
disabled. This machine has no configured Linux container, VM or SSH executor.
The first Ubuntu [CI run](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101096161)
completed successfully for `81fbaf90a44aa3f8ae7807306288990dde3756ba`: a fresh project
checkout and build (3,464 jobs, with pinned Mathlib cache), shared-definition comparison,
Challenge/Solution build (3,467 jobs) and an audit of 1,986 declarations with zero forbidden
dependencies. This is clean-checkout CI evidence, not a from-source rebuild of Mathlib.

The first [full Palomar preflight](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101135106)
used that same commit, `mode: full`, `palomar-standard-v1` and request ID `rare20261030`.
Its mechanical report says `status: fail`, `phase: preparation`: unauthenticated source
fetch failed with `could not read Username for 'https://github.com': terminal prompts disabled`
because the repository was private. No Comparator or kernel checks ran in that workflow.
This access failure is distinct from the successful local kernel replays and GitHub CI.

The public documentation revision is to receive fresh CI and a full preflight at its
own immutable commit. At the time of this documentation freeze, official sandboxed
Comparator and a passing full Palomar report remain pending. Use the workflow links
below to locate later runs and inspect their exact source identity and report.

## GitHub workflows

[Lean build](.github/workflows/lean.yml) builds the library and Challenge/Solution,
checks shared definitions and runs the hardened axiom audit. Its actions are pinned.

[Palomar full mechanical preflight](.github/workflows/palomar-preflight.yml) is a
manual-only reusable-workflow call pinned to
`14aa8d6b3c2f14a8540605e37144560b9a00e7e7`. It binds `${{ github.sha }}`, uses
`mode: full` and `execution_profile: palomar-standard-v1`, and supplies the
responsible-author/maintainer relationship explicitly confirmed by the user.
The pinned workflow was fetched and its inputs checked. Supply a 12-character
lowercase alphanumeric request ID; the prepared default is `poisson00001`.
The job performs predictive verification, not registry submission or registration.

## Requirements refreshed for this candidate

The official [submission standard](https://github.com/PalomarRegistry/PalomarPolicy/blob/main/CONTRIBUTING.md)
and [toolchain policy](https://raw.githubusercontent.com/PalomarRegistry/PalomarSubmission/main/toolchains.json)
were checked on 30 October 2026. Lean 4.35.0 meets the current minimum of 4.35.0-rc2.
The Challenge uses only Mathlib imports and fits the 1,000-line/100-KiB hard limit;
the exact size is in [CHALLENGE_NOTES.md](CHALLENGE_NOTES.md). Root licensing,
metadata, pinned public dependencies and the selected declarations must all agree
at the final public commit. No LFS pointers, source symlinks, submodules or compiled
outputs outside `.lake` belong in the candidate.

The current [metadata template](https://github.com/PalomarRegistry/PalomarTemplate/blob/main/formalization.yaml)
uses schema v0.4. The [official verifier documentation](https://github.com/PalomarRegistry/PalomarSubmission/blob/main/README.md)
distinguishes local checks, predictive full preflight and registry intake. Inspect
the exact `mechanical-report.json`, including mandatory Lean and NanoDa results;
a green ordinary CI job is insufficient.

## Public candidate and remaining verification

The author authorized public visibility, the documentation update and a fresh run of
both workflows. The public candidate keeps exactly the four Introduction theorems in
`comparator.json`; B06/B07 remain open background obligations in the broader inventory.

For the public commit, require a successful
[Lean CI run](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml)
and inspect the report from the
[full mechanical preflight](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml).
A pass must identify that exact commit, the pinned pipeline, the four selected declarations,
and acceptance by mandatory Lean and NanoDa checks. An ordinary green build is insufficient.

GitHub publication, predictive preflight, registry intake and registration are distinct.
No registry intake, submission or registration has been performed. A full-preflight pass
would establish mechanical evidence for the selected interface, not whole-source coverage
or completion of Palomar's later rendering and review.
