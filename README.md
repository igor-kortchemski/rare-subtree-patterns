# Poisson approximation and declumping

[![CI](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml/badge.svg?branch=main)](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml)
[![Comparator](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml/badge.svg?branch=main)](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml)

Lean formalization of the four Introduction theorems of
[*Rare subtree patterns in size-conditioned Bienaymé trees: Poisson approximation
and declumping*](https://arxiv.org/abs/2607.22291v1), by Igor Kortchemski and Leonard
Vetter. The unchanged paper source is [poisson-declumping-arxiv.tex](poisson-declumping-arxiv.tex).

## Proved results and certification scope

The four Introduction theorems are proved in Lean, with exactly the types of the
statement-level propositions in [Statements/Main.lean](PoissonDeclumping/Statements/Main.lean):

| Paper | Lean theorem |
| --- | --- |
| Theorem 1.1 (marked Poisson approximation / law of large numbers) | [PoissonDeclumping.poissonApproximation](PoissonDeclumping/MainTheorems.lean#L38) |
| Theorem 1.2 (root declumping) | [PoissonDeclumping.poissonApproximation2](PoissonDeclumping/MainTheorems.lean#L42) |
| Theorem 1.3 (maximal complete non-fringe $r$-ary height) | [PoissonDeclumping.maxString](PoissonDeclumping/MainTheorems.lean#L46) |
| Theorem 1.4 (maximum leaf-height) | [PoissonDeclumping.maxLeafHeight](PoissonDeclumping/MainTheorems.lean#L50) |

[comparator.json](comparator.json) selects exactly these four theorems for the
Palomar publication candidate. The repository also includes the reviewed numbered
results and their supporting proofs. Whole-source completion is not claimed.

The main statements retain the paper's marking and cutoff hypotheses and its standing
assumption $(H_\alpha)$: a critical offspring law with $\mu_1\ne 1$, in the domain of
attraction of an $\alpha$-stable law, $1<\alpha\le 2$. `StableDomain` expresses this
through normalized weak convergence to the specified stable law; periodic laws are
included. The stable random-walk toolbox, including regular variation and the lattice
local limit theorem, is derived from that hypothesis. The Bienaymé tree law, Łukasiewicz
coding, cycle lemma, Chen–Stein bound, bridge estimates and extremal applications are
formalized too.

The general stable-domain characterization (**B06**) and full functional Skorokhod
$J_1$ theorem (**B07**) remain unformalized cited background. Their required consequences
are proved separately; the main theorems require neither a separate truncated-moment
criterion nor full functional convergence. **Potter bounds are proved for the actual
normalization function used in the paper**; the generic Potter theorem is cited
background. Conjectures remain conjectures.

[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md) and [PAPER_INVENTORY.md](PAPER_INVENTORY.md)
retain the full inventory, proof departures and periodic-domain corrections.
[INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md) records scoped agent statement and proof-route
reviews; [MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md) records source observations.

## Verification status

[GitHub CI for commit 81fbaf9](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101096161)
passed on Ubuntu: the library build, shared-definition check, Challenge/Solution build
and whole-library audit of **1,986 declarations, zero forbidden axiom dependencies**.
The documentation revision prepared for public publication preserves that commit's
Lean sources, toolchain, dependencies and Comparator configuration; subsequent runs
are linked by the badges above and identify their exact commit.

The selected proof closures also pass standalone NanoDa replay (56,903 declarations,
zero type-checker errors) and Lean kernel replay. The only permitted axioms are
`propext`, `Classical.choice` and `Quot.sound`. The proof library has no proof holes;
[Challenge.lean](Challenge.lean) has four deliberate isolated statement holes.

**Full Palomar verification is pending at this documentation revision.** The
[first full-preflight attempt](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101135106)
stopped before proof checks because the repository was private. The public candidate
is to be checked by the same pinned full workflow. The Comparator badge reports that
workflow's aggregate status, including source preparation; it does not certify a
particular commit on its own. See [PUBLICATION.md](PUBLICATION.md) and
[verification/README.md](verification/README.md) for exact evidence and limitations,
including the nonfatal standalone NanoDa pretty-printer diagnostic.

## Build and check

Install [Lean and elan](https://leanprover-community.github.io/install/project.html), then:

```sh
git clone https://github.com/igor-kortchemski/rare-subtree-patterns.git
cd rare-subtree-patterns
# For a cited candidate, check out its full commit SHA before building.
lake exe cache get
lake build
bash verification/check-challenge-defs.sh
lake build Challenge Solution
lake env lean verification/AxiomAudit.lean
```

The project pins Lean `leanprover/lean4:v4.35.0`, Mathlib `v4.35.0` and exact dependency
revisions in [lake-manifest.json](lake-manifest.json). Preserve these pins when
reproducing a candidate. Open the cloned directory in VS Code with the Lean 4 extension.

Start reading at [PoissonDeclumping.lean](PoissonDeclumping.lean), which imports every
maintained proof module, or at [MainTheorems.lean](PoissonDeclumping/MainTheorems.lean)
for the four main exports. [ARCHITECTURE.md](ARCHITECTURE.md) describes the module layout.

## License, citation and contributions

The formalization code is licensed under [Apache-2.0](LICENSE). Igor Kortchemski is
the formalization author and responsible maintainer. Claude and Codex are recorded
as automated tools in [formalization.yaml](formalization.yaml); the reviews described
here are agent reviews. The unchanged paper source retains its own CC-BY-4.0 license.
Installed skills retain their notices under `.agents/skill-notices/`.

Use [CITATION.cff](CITATION.cff) to cite the formalization and cite the paper separately.
Issues and pull requests are welcome; include the candidate commit and a reproducible
Lean diagnostic for proof or build problems.

The local [Lean skills](.agents/README.md) and [AGENTS.md](AGENTS.md) describe the
formalization workflow. Use `lean-workflow` for proof development and maintain the
coverage record when mathematical scope or source correspondence changes.
