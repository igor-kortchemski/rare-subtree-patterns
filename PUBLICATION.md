# Publication candidate

Updated 30 October 2026. The intended repository is
`igor-kortchemski/rare-subtree-patterns`. This is a local publication candidate;
the repository has not been created or populated by this task. The candidate's
source identity is recorded in `verification/source-sha256.txt`; a future public
commit must identify the same proof and configuration files.

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
A clean Linux build, official Comparator and the full Palomar preflight remain
pending a public candidate commit.

## Prepared GitHub workflows

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

## Remaining external actions

After review of the local candidate, create the public GitHub repository and push
its frozen commit, run both workflows, and inspect the full mechanical report.
Publication and execution have not occurred here. Registry intake and registration
remain separate actions; no intake, submission or registration has been performed.
