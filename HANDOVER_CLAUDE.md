# Handover to Claude

> **Superseded (kept for history).** This is the handover written before the continuation campaign.
> The main results it lists as open are now proved; the authoritative current state, coverage and remaining
> obligations are in [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).


Prepared 30 October 2026. The user asked Codex to do the most important initial
steps and leave the rest to Claude. The eventual objective is the complete
paper formalization and a verified GitHub/Palomar publication candidate.
**This handover milestone is not that final deliverable.**

## Start here

Work in this folder, whose name has a trailing space. From the parent:

```sh
cd 'arXiv-2607.22291v1 '
lake build
lake env lean verification/Axioms.lean
```

Lean and mathlib are pinned to 4.35.0. Preserve the toolchain, Lake configuration
and dependency manifest. The local dependency cache exists; on a fresh machine
use `lake exe cache get` first. Do not use `lake update` or remove caches to
reproduce the checked result.

Read these in order:

1. [AGENTS.md](AGENTS.md) and [lean-workflow](.agents/skills/lean-workflow/SKILL.md).
2. [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md): authoritative coverage,
   actual proof exports, departures and current evidence.
3. [PAPER_INVENTORY.md](PAPER_INVENTORY.md): complete stable claim IDs and source
   locations, including non-headline obligations and conjectural material.
4. [ARCHITECTURE.md](ARCHITECTURE.md): exact content of the four main results,
   representations and dependency route.
5. [INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md) and
   [PUBLICATION.md](PUBLICATION.md): reviewed components and remaining requirements.

The six skills live in `.agents/skills/`; read their files directly if your
client does not discover this location. Use `lean-statement-audit` before
substantial main/interface-dependent work, `lean-project-architecture` for
encodings, `lean-orchestrator` for independent parallel work, `lean-elaboration`
for observed slowness, and `lean-publication` for publication-sensitive choices.
Reuse valid reviews; successful agent review and routine proof choices need no
new user approval.

## Verified work to reuse

| File | Content |
| --- | --- |
| `PoissonDeclumping/PlaneTree/Basic.lean` | Ordered finite plane trees; fringe occurrence list preserving duplicates; raw count/existence/zero characterizations; child induction and transitive fringe containment. |
| `PoissonDeclumping/Declumping/Deterministic.lean` | Declumped positivity implies raw positivity; propagation plus no declumped occurrence forces any raw mark to the root; both zero-event inclusions. |
| `PoissonDeclumping/Probability/TotalVariation.lean` | Paper-normalized TV, event bound, attained-event characterization, equivalent uniform event bound and elementary distance laws. |
| `PoissonDeclumping/Declumping/Probability.lean` | Finite-measure event sandwich, quantitative raw Poisson-zero error, abstract filter-level `declump_to_raw`. |

The last theorem proves the probability reduction of source L5.2 for arbitrary
tree laws. It assumes propagation, vanishing root marks and declumped Poisson
approximation, with measurable pushforwards. These are the paper lemma's
hypotheses, not new substitutes for a main theorem. The actual conditioned
Bienaymé family and its specialization are still absent. All four Introduction
theorems remain open; their interfaces are mathematical design notes, not
completed Lean declarations.

The final local build passed with 3,209 jobs and no warnings. The axiom probe
checks 40 declarations/definitions and reports only subsets of `propext`,
`Classical.choice`, and `Quot.sound`. See `verification/` for outputs, source
hashes and commands. Independent source/interface and proof-route review passed.
No Comparator, NanoDa, clean Linux rebuild, GitHub CI or Palomar preflight ran.

## First continuation tasks

**Settle the tree/walk and law interfaces before the large proof campaign.**
Extend the existing tree model with valid child-index addresses and fringe
lookup, then prove that DFS enumeration yields `fringeTrees`. Add proper-fringe
size, outdegree sequence and excursion characterizations. Mathlib's ordinary
`Tree` is binary and must not replace the arbitrary-degree ordered model.
Use `induction_children` for recursive proofs; the `fringeTrees` constructor
equation uses its equation theorem rather than definitional `rfl`.

Construct offspring/tree laws with actual normalization and branching proofs.
A structure whose fields assume those conclusions supplies only conditional
helpers. Critical nondegenerate extinction is a prerequisite to the finite-tree
law. For `declump_to_raw`, index laws by the subtype of admissible sizes, or
otherwise ensure every indexed law is a probability measure. A conditional
measure at an impossible size is not one. Keep the actual size, rather than the
subsequence index, in asymptotic scales.

Next establish the tree/walk bijection, cycle lemma, cyclic bridge law and
uniform-vertex convolution (B02–B05, L2.2, C2.3). This unlocks microscopicity
and bridge estimates. Stable lattice local limits, regular variation/Potter
bounds and forest estimates are major missing dependencies; do not hide them
in new assumptions of the final Introduction theorems.

Once shared interfaces pass independent review, useful parallel work is:

- cyclic combinatorics and tree probability characterization;
- stable random-walk/forest estimates with exact uniformity;
- the precise AGG test-function Chen–Stein bound;
- the root-declumping parent formula and first-moment dominated-convergence
  argument, without an unjustified finite-second-moment assumption;
- root leaf-height PGF asymptotics, proving equivalents, not just logarithmic order.

Assign disjoint files and one coordinator for builds writing shared outputs.
Use focused `lake build Module.Name` checks and batched axiom probes. Keep all
maintained proof modules reachable from `PoissonDeclumping.lean`.

## Mathematical traps already found

- **No extra aperiodicity:** all four main results allow periodic laws. Make
  admissible sizes and compatible bridge endpoints explicit; aperiodic formulas
  cannot be used at impossible lattice points.
- **TV factor:** use `paperTVDist`, not unscaled mathlib `tvDist`. Its exact
  measurable-event meaning is proved. Preserve probability hypotheses because
  the real library distance is totalized for infinite measures.
- **Main T1.1 assumes (M)/(C):** replacing (M) by stronger (S) loses scope.
  T1.2 uses raw (S) and declumped (C) with the same cutoff; its divergent
  conclusion is divergence, not an LLN normalized by $c_Bn\pi_n$.
- **Non-fringe embedding preserves internal degrees:** it is grafting at leaves,
  not selecting any $r$ children of a higher-degree vertex.
- **T1.3(ii) reference correction:** use T1.1(ii) at source lines 2853–2855;
  C3.8(ii)'s stronger uniform pair assumption was not established there.
- **Other boundaries:** zero marking probabilities, empty forests, zero
  remainder time, nonempty cut-and-graft index, negative floored levels,
  and the unary maximum's essential $+1$.
- **No raw/declumped deterministic equivalence:** use the proved root-error
  bound and prove its vanishing in each application.

[MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md) records the
concrete findings. No manuscript edits were made.

## Completion and publication

After the four main results, reconcile every remaining inventory ID, including
direct fringe/non-fringe/outdegree applications, remarks and unnumbered claims.
The perspectives' four expected laws remain conjectural unless the user expands
the proof task. Update coverage at coherent milestones and review affected
statements, dependencies and routes. Before a whole-paper claim, scan the whole
source again for omissions.

The eventual candidate needs independently reviewed Challenge/Solution interfaces
and real Comparator evidence. Current Palomar constraints and official links
are in `PUBLICATION.md`; refresh them at release time. Lean 4.35.0 meets the
checked minimum. A Linux build workflow with immutable action pins is prepared
but has never run on GitHub.

Still missing: full mathematical coverage, concrete candidate repository/commit,
root code license, factual human credits/maintainers, publication metadata,
clean build, Comparator and full Palomar report. Paper and skill licenses do
not automatically license the formalization. Do not invent human facts, green
badges, releases or verification success. Preparation does not itself publish
or submit.

No git repository was initialized here by this pass, and no publication,
submission or registration occurred. Finish with actual evidence and explicit
remaining obligations whenever the full scope is still unfinished.
