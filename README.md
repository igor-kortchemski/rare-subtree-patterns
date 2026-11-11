# Rare subtree patterns in size-conditioned Bienaymé trees: Poisson approximation and declumping

[![CI](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml/badge.svg?branch=main)](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/lean.yml)
[![Comparator](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml/badge.svg?branch=main)](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/workflows/palomar-preflight.yml)

Lean 4 and Mathlib formalization of
[*Rare subtree patterns in size-conditioned Bienaymé trees: Poisson approximation and declumping*](https://arxiv.org/abs/2607.22291v1)
(arXiv:2607.22291v1) by Igor Kortchemski and Leonard Vetter.
**The four Introduction theorems (Theorems 1.1–1.4) are proved, using only the axioms
`propext`, `Classical.choice` and `Quot.sound`, with no `sorry` outside the four deliberate
statement holes of the Comparator Challenge.**

Statements: [Challenge.lean](Challenge.lean) · Correspondence: [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md) · Verification: [verification/README.md](verification/README.md)

## Main results

The paper counts fringe subtrees carrying a rare mark in a Bienaymé tree $\mathcal T_n$
conditioned to have $n$ vertices, proves Poisson approximation and a root-declumping
principle for these counts, and applies them to extremal statistics. Below, $\pi_n$ is the
probability that an unconditioned Bienaymé tree is marked.

| Paper | Lean theorem | Statement |
| --- | --- | --- |
| Theorem 1.1 | [`PoissonDeclumping.poissonApproximation`](PoissonDeclumping/MainTheorems.lean#L38) | Under (M) and (C), the marked count is close in total variation to $\mathrm{Poisson}(n\pi_n)$ when $n\pi_n$ is bounded, and is $\sim n\pi_n$ in probability when $n\pi_n\to\infty$. |
| Theorem 1.2 | [`PoissonDeclumping.poissonApproximation2`](PoissonDeclumping/MainTheorems.lean#L42) | Root declumping: under (S), and (C) for the declumped marks, the declumped count is close in total variation to $\mathrm{Poisson}(c_B n\pi_n)$ when $n\pi_n$ is bounded, and diverges when $n\pi_n\to\infty$. |
| Theorem 1.3 | [`PoissonDeclumping.maxString`](PoissonDeclumping/MainTheorems.lean#L46) | Maximal complete non-fringe $r$-ary height $H_r$: a lattice Gumbel limit for $H_1$ if $\mu_1>0$; concentration of $H_r$ on two consecutive values if $r\ge 2$ and $\mu_r>0$. |
| Theorem 1.4 | [`PoissonDeclumping.maxLeafHeight`](PoissonDeclumping/MainTheorems.lean#L50) | Maximum leaf-height: a lattice Gumbel limit if $\mu_1>0$; concentration on two consecutive values if $\mu_1=0$. |

Each theorem has exactly the type of a proposition in
[Statements/Defs.lean](PoissonDeclumping/Statements/Defs.lean#L343), such as
`PoissonApproximationStatement`, with limits along the admissible sizes $n$. These
statements retain the paper's marking and cutoff hypotheses and its standing
assumption $(H_\alpha)$: a critical offspring law with $\mu_1\ne 1$, in the domain of
attraction of an $\alpha$-stable law, $1<\alpha\le 2$. `StableDomain` expresses this
through normalized weak convergence to the specified stable law; periodic laws are
included. The stable random-walk toolbox, including regular variation and the lattice
local limit theorem, is derived from that hypothesis. The Bienaymé tree law, Łukasiewicz
coding, cycle lemma, Chen–Stein bound, bridge estimates and extremal applications are
formalized too; the paper's other numbered results are proved, some in corrected or
generalized form.

The general stable-domain characterization (**B06**) and the full functional Skorokhod
$J_1$ theorem (**B07**) remain unformalized cited background. Their required consequences
are proved separately; the main theorems require neither a separate truncated-moment
criterion nor full functional convergence. **Potter bounds are proved for the actual
normalization function used in the paper**; the generic Potter theorem is cited
background. Conjectures remain conjectures, and whole-source completion is not claimed.
The periodic-case corrections and the other manuscript observations (R1–R9) are in
[MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md); none changes the
conclusion of an Introduction theorem. Proof departures are listed in Section 4 of
[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).

## Where to start

- [Challenge.lean](Challenge.lean): the four statements and every definition they use,
  importing only Mathlib; readable without the rest of the library.
- [PoissonDeclumping/Statements/Defs.lean](PoissonDeclumping/Statements/Defs.lean): the same
  definitions inside the library, including `StableDomain` and the assumptions (M), (S), (C).
- [PoissonDeclumping/MainTheorems.lean](PoissonDeclumping/MainTheorems.lean): the four proofs
  assembled; [PoissonDeclumping.lean](PoissonDeclumping.lean) imports every module.
- [PoissonDeclumping/Stable/ToolkitProof.lean](PoissonDeclumping/Stable/ToolkitProof.lean):
  `Stable.stableToolkit` derives the stable random-walk toolbox from $(H_\alpha)$.
- [PoissonDeclumping/Examples/](PoissonDeclumping/Examples): periodic and aperiodic offspring
  laws satisfying $(H_\alpha)$.
- [PAPER_INVENTORY.md](PAPER_INVENTORY.md) lists every claim of the paper with a stable ID;
  Section 6 of the report maps the modules.

## Verify

Install [Lean and elan](https://leanprover-community.github.io/install/project.html), then:

```sh
git clone https://github.com/igor-kortchemski/rare-subtree-patterns.git
cd rare-subtree-patterns
lake exe cache get
lake build
bash verification/check-challenge-defs.sh
lake build Challenge Solution
lake env lean verification/AxiomAudit.lean
```

The project pins Lean `leanprover/lean4:v4.35.0`, Mathlib `v4.35.0` and the exact dependency
revisions in [lake-manifest.json](lake-manifest.json); do not run `lake update`. To browse the
proofs, open the cloned folder in VS Code with the Lean 4 extension.

The [Lean build](.github/workflows/lean.yml) workflow runs the commands above on Ubuntu: the
library build, the check that the Challenge definitions equal the library text, the
Challenge/Solution build and an axiom audit of every project declaration. The
[full Palomar preflight](.github/workflows/palomar-preflight.yml) runs `lake comparator` on
[comparator.json](comparator.json), with NanoDa enabled: it checks that `Solution` proves the
four Challenge statements with the same types and definitions and only the three permitted
axioms. On 1 November 2026 both passed for commit `fc5ef72`
([CI run](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41296377810),
[preflight run](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41296377843));
later commits do not change the Lean sources or configuration. The badges show the latest run
of each workflow on `main`. [verification/README.md](verification/README.md) records the runs,
local logs and standalone NanoDa and Lean kernel replays of the four proofs.

## How it was made

Claude and Codex agents developed and reviewed the proofs under Igor Kortchemski's direction,
with Lean 4.35.0, Mathlib 4.35.0 and Lean autoformalization skills; exact model identities for
the earlier Claude work were not recorded. Independent Claude and Codex review agents checked
the statements, the Challenge and selected proof routes against the paper
([INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md)). These are agent reviews: no human
line-by-line review of the Lean proofs is claimed, and several proof directories were checked
only by the Lean kernel, as listed in Section 6 of [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).
[ARCHITECTURE.md](ARCHITECTURE.md) and [docs/BRIDGE_PLAN.md](docs/BRIDGE_PLAN.md) are design
notes written before the proofs; module docstrings cite the latter's corrections F1–F15.

## License and citation

The formalization is licensed under [Apache-2.0](LICENSE). Igor Kortchemski is its author and
maintainer. The license does not cover the paper: its unchanged arXiv source
([poisson-declumping-arxiv.tex](poisson-declumping-arxiv.tex), with its figures and
bibliography) is distributed under CC BY 4.0.

Cite the formalization with [CITATION.cff](CITATION.cff) and cite the paper separately.
Issues and pull requests are welcome; for a proof or build problem, include the commit and a
reproducible Lean diagnostic.
