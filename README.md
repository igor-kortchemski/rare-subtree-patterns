# Poisson approximation and declumping

Lean formalization project for *Rare subtree patterns in size-conditioned
Bienaymé trees: Poisson approximation and declumping*, by Igor Kortchemski and
Leonard Vetter (arXiv:2607.22291v1).

The paper source is `poisson-declumping-arxiv.tex`.

## Environment

- Lean: `leanprover/lean4:v4.35.0`.
- Mathlib: [release v4.35.0](https://github.com/leanprover-community/mathlib4/releases/tag/v4.35.0).
- Exact dependency revisions: `lake-manifest.json`.
- Library entry point: `PoissonDeclumping.lean`.

The entry point imports all maintained proof modules under `PoissonDeclumping/`.

From this directory, with elan installed:

```sh
lake exe cache get
lake build
lake env lean verification/Axioms.lean
```

The `lean-toolchain` file selects Lean 4.35.0 automatically. Open this directory
as the workspace when using the Lean 4 extension in VS Code.

The existing directory name ends with a space. From its parent directory, use:

```sh
cd 'arXiv-2607.22291v1 '
```

## Status

**The four Introduction theorems are proved in Lean** (`PoissonDeclumping/MainTheorems.lean`), with
exactly the types of the statement-level propositions in `PoissonDeclumping/Statements/Main.lean`:

| Paper | Lean theorem |
| --- | --- |
| Theorem 1.1 (marked Poisson approximation / law of large numbers) | `PoissonDeclumping.poissonApproximation` |
| Theorem 1.2 (root declumping) | `PoissonDeclumping.poissonApproximation2` |
| Theorem 1.3 (maximal complete non-fringe $r$-ary height) | `PoissonDeclumping.maxString` |
| Theorem 1.4 (maximum leaf-height) | `PoissonDeclumping.maxLeafHeight` |

They retain the paper's marking and cutoff hypotheses and its standing assumption $(H_\alpha)$ (critical offspring law with
$\mu_1\ne 1$, in the domain of attraction of an $\alpha$-stable law, $1<\alpha\le 2$), encoded by
`StableDomain` through normalized weak convergence to the specified stable law; periodic laws are included.
The unused truncated-moment conjunct has been removed, so its unformalized general characterization
is not an extra hypothesis of the main results. The stable random-walk
toolbox (characteristic function of the limit law, regular variation of the normalizing sequence, the lattice
local limit theorem) is derived from that hypothesis (`PoissonDeclumping/Stable/`), not assumed. The
Bienaymé tree law (normalization, branching), the Łukasiewicz coding and cycle lemma, the Chen–Stein bound,
the bridge estimates of Sections 3–5 and the applications of Sections 6–7 are formalized too.

The unary clustering counterexample, finite-variance normalization, real-valued Skorokhod
representation and actual walk maximal tightness are also proved. The general stable-domain
characterization and full functional $J_1$ convergence remain open. The all-real Potter bound for
the actual norming factor is proved. The general Potter theorem is cited background;
the formalization uses only that proved specialization, as agreed (R9).
Substantive proof departures, manuscript corrections and exact coverage by inventory ID are in
[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md). The statement-level definitions were reviewed by
independent reviewers ([INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md)); the conjectures in the paper's last
section remain conjectures.

Evidence ([verification/README.md](verification/README.md)): the whole library builds with `lake build`
(no `sorry`, axiom, or native evaluation in the sources) and an audit of every declaration finds only
`propext`, `Classical.choice`, `Quot.sound`. The four selected proof closures also pass standalone
NanoDa replay (56,903 declarations, zero type-checker errors) and Lean kernel replay. See the
verification record for the nonfatal NanoDa pretty-printing diagnostic. **Still pending:** the
official Linux Comparator, clean Linux build, GitHub CI and full Palomar preflight. Licensing,
author/maintainer credits and metadata are now supplied. See [PUBLICATION.md](PUBLICATION.md).

## Formalization skills

All six skills from `lean-autoformalization-skills` are installed locally under
`.agents/skills/`, including their references and UI metadata. See
[AGENTS.md](AGENTS.md) for project instructions and
[the skill index](.agents/README.md) for usage, provenance, and licenses.
Use `lean-workflow` for ordinary proof work and the specialized skills as their
tasks arise. Progress and paper coverage are recorded in
[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).

Open this paper's folder as the working directory to use its local skills.
From the parent workspace, read `AGENTS.md` and load the linked skills directly.

## License and credits

The formalization code is licensed under [Apache-2.0](LICENSE). Igor Kortchemski is the
formalization author and responsible maintainer. Claude and Codex are recorded as automated
tools in [formalization.yaml](formalization.yaml); the reviews described here are agent reviews.
The unchanged paper source retains its own CC-BY-4.0 license. Installed skills retain their
third-party notices under `.agents/skill-notices/`. Citation metadata is in [CITATION.cff](CITATION.cff).
