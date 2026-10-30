# Mathematical architecture and next proof tasks

> **Design note (partly historical).** It proposed the interfaces before implementation. The statements and
> definitions actually used are in `PoissonDeclumping/Statements/Main.lean` and `PoissonDeclumping/Setup/`; the
> coverage record is [FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md).


This is a source-driven design note for Claude's continuation, prepared on
30 October 2026 against `poisson-declumping-arxiv.tex`, arXiv:2607.22291v1,
and the pinned mathlib commit in `lake-manifest.json`. It proposes interfaces;
it does **not** claim that the main theorems below have Lean statements or proofs.
Read the coverage report for actual completion and verification evidence.

## The four Introduction results

All limits use admissible sizes: $n$ tends to infinity subject to
$\mathbb P(|\mathcal T|=n)>0$. The standing offspring assumptions are criticality,
$\mu_1\ne1$, and attraction to a stable law of index $\alpha\in(1,2]$.
The source states these at lines 173–181 and 699–713. Periodic offspring laws
are included; an aperiodicity assumption would weaken the final results.

1. **`thm:PoissonApproximation`, lines 305–333.** For arbitrary tree marks
   $G_k$, indices $k_n$, and a common cutoff $M_n\to\infty$, $M_n=o(n)$,
   assume exactly microscopicity (M) and pair non-clustering (C), defined at
   lines 217–299. Put $\pi_n=\mathbb P(G_{k_n}(\mathcal T)=1)$ and
   $N_n=\sum_{v\in\mathcal T^n}G_{k_n}(\mathcal T^n_v)$.
   Bounded $n\pi_n$ gives $d_{\rm TV}(\mathcal L(N_n),\operatorname{Po}(n\pi_n))\to0$;
   divergent $n\pi_n$ gives $N_n/(n\pi_n)\to1$ in probability and hence
   $N_n\to\infty$ in probability. Do not replace (M) by the stronger (S) in this
   theorem's final interface.
2. **`thm:PoissonApproximation2`, lines 396–442.** Given $B\subseteq\mathbb N$,
   define the declumped root mark by a root degree in $B$ and at least one
   marked child. Let $c_B=\mathbb E[D\mathbf1_{D\in B}]\in(0,\infty)$.
   Assume (S) for the **raw** marks and (C) for the **declumped** marks with
   the same cutoff. The bounded-mean conclusion is Poisson approximation of
   the declumped count with parameter $c_Bn\pi_n$. The divergent-mean conclusion
   is divergence of that count in probability; it does **not** assert a law of
   large numbers normalized by $c_Bn\pi_n$.
3. **`thm:max_string`, lines 475–508.** For $r=1$, $\mu_1>0$, preserve the
   lattice correction $\exp(-\mu_1^{t+1-\{t_n^*+t\}})$ and the exact centering
   $t_n^*=(\log n+\log(1-\mu_1))/\log(1/\mu_1)$.
   For $r\ge2$, $\mu_r>0$, use
   $t_n^{**}=\log_r\log n-\log_r(\log(1/\mu_r)/(r-1))$;
   $m_n=\lfloor t_n^{**}\rfloor$, $\theta_n=\{t_n^{**}\}$.
   The two-point set is $\{m_n-1,m_n\}$ when $\theta_n\le1/2$ and
   $\{m_n,m_n+1\}$ otherwise. A liminf bounded away from both lattice endpoints
   gives concentration at $m_n$. Non-fringe embedding is grafting onto leaves,
   not selection of any $r$ children from a vertex of larger degree.
4. **`thm:max_lh`, lines 533–566.** With $\mu_1>0$, the lattice formula uses
   $k_n^*=(\log n+\log((1-\mu_1)C_\mu))/\log(1/\mu_1)$ and one
   $C_\mu>0$ valid for every $t\in\mathbb R$.
   With $\mu_1=0$, $\kappa=\min\{i\ge2:\mu_i>0\}$ and one
   $D_\mu\in(0,1)$ determine
   $k_n^{**}=\log_\kappa\log n-\log_\kappa\log(1/D_\mu)$ and the same
   two-point rule and interior-phase refinement. The constants must be
   characterized by the root-tail limits at lines 562–572, not selected to
   make the maximum theorem tautological. Retain the first-order consequences
   at lines 574–586 in the inventory.

## Representations to settle before substantial dependent proofs

**Finite plane trees.** A recursively defined node with an ordered finite list
of children directly matches the source. A leaf is a node with no children and
has one vertex. Preserve multiplicities when listing fringe trees: two equal
child trees are two occurrences. A list of DFS fringe trees is suitable for
counts; a set of tree values is not. Add vertices/addresses and their fringe
lookup with proved correspondence to that list before using a uniform vertex.
An equivalent finite prefix-closed address model is also valid, provided child
indices are consecutive and DFS order is proved compatible with the encoding.

Mathlib's `Mathlib.Data.Tree.Basic` defines **binary** trees. Its `Tree` alias
does not supply arbitrary plane trees. `Mathlib.Order.SuccPred.Tree` provides
order-theoretic `RootedTree`, without the required finite ordered-child data.

**Bienaymé law.** Start with `PMF ℕ` for offspring. Express criticality by the
nonnegative first moment being one and prove the required integrability. Define
finite tree weights by the product of offspring weights and prove normalization
using critical, nondegenerate extinction. Normalization, the branching property,
and the law's characterization are obligations, not fields containing unproved
desired estimates. Then define the size-conditioned law only at admissible
sizes, or use conditional measures with explicit positivity at every use.

**Asymptotic index.** One convenient representation is the filter
`Filter.atTop ⊓ Filter.principal {n | 0 < treeLaw {T | size T = n}}`.
Prove it is nontrivial. Alternatively use an arbitrary cofinal increasing
sequence of admissible sizes, but keep the actual size in $n\pi_n$ and $M_n/n$;
do not substitute the subsequence index. Probability convergence can be stated
directly as convergence of probabilities under the varying conditioned laws.
`MeasureTheory.TendstoInMeasure` takes a fixed measure, so using it verbatim for
varying laws would require a justified common realization.

**Marks and zero probabilities.** `PlaneTree → Prop` with classical indicators
is a faithful alternative to $\{0,1\}$-valued functions. Define (M), (S), and (C)
with their full content. In (S), conditional independence and each grafted
tree's unconditioned law must be explicit. Conditional statements are used on
positive-marking subsequences (source line 206); handle zero-mark cases
separately. `Asymptotics.IsEquivalent` is preferable to blindly defining
$f\sim g$ as a ratio limit when $g$ may vanish.

**Total variation.** Mathlib's `MeasureTheory.tvDist` ranges up to **two** for
probability measures (`Mathlib.MeasureTheory.Measure.TotalVariation.Defs`).
The paper uses the conventional distance up to one. Define a clear normalized
wrapper, such as `tvDist μ ν / 2`, and prove its event and coupling bounds.
Retain finite/probability measure hypotheses: mathlib's real-valued `tvDist`
is totalized to zero when a measure is not finite. Scaling does not affect
convergence to zero, but it does affect every quantitative bound.

## Most useful first mathematical milestone

The deterministic core of **`lem:declump_to_raw`**, lines 2343–2399, is small,
source-facing, and directly feeds both extremal main results. For raw count
$N_G(T)$ and declumped count $\widehat N_{G,B}(T)$, prove:

$$
\widehat N_{G,B}(T)>0\ \Longrightarrow\ N_G(T)>0.
$$

Under the exact propagation property

$$
G(T_u)\ \land\ k_v(T)\notin B\ \Longrightarrow\ G(T_v)
\qquad\text{for each child }u\text{ of }v,
$$

prove the deterministic exceptional-event inclusion

$$
N_G(T)>0\ \land\ \widehat N_{G,B}(T)=0\ \Longrightarrow\ G(T).
$$

The paper chooses a marked vertex of minimal depth and moves to its parent.
Structural induction up the marked branch is the same underlying argument.
Also connect positive counts to existence of a marked fringe occurrence.
These results require no offspring, stable-law, or Poisson assumptions.
Have an independent reviewer check the tree/count/propagation interface first.
The **full probabilistic lemma** remains pending until the event-probability
sandwich and Poisson zero-event limit are proved; do not mark the whole lemma
complete merely because this deterministic core is finished.

The next short extension is the event sandwich for any probability law on trees:

$$
0\le \mathbb P(\widehat N=0)-\mathbb P(N=0)\le\mathbb P(G(T)).
$$

Combine it with the normalized total variation bound at the singleton $\{0\}$
and `ProbabilityTheory.poissonMeasure_real_singleton` to finish the abstract
probabilistic reduction, retaining the paper's explicit vanishing root-mark
and Poisson-approximation hypotheses. Those hypotheses must later be discharged
before claiming either main extremal theorem.

## Dependency route and sensible modules

| Proposed module area | Mathematical content | Source |
| --- | --- | --- |
| `PlaneTree`, `Marks`, `Declumping` | Plane trees, fringe counts, propagation, deterministic comparison | 679–713, 2334–2437 |
| `Bienayme`, `Conditioning` | Tree probability weights, extinction, branching, conditioned laws, admissible sizes | 699–713 |
| `Lukasiewicz`, `CyclicIndicators` | Tree/walk bijection, cycle lemma, random cyclic bridge, truncated indicators, uniform fringe identity | 683–835 |
| `StableWalk` | Stable domain, norming, regular variation/Potter bounds, lattice local limits | 837–881 |
| `Microscopicity` | Forest estimates, (S) consequences, (S) implies (M) | 1015–1365 |
| `ChenStein` | The precise AGG test-function bound, not a stronger mixing assumption | 1597–1624 |
| `BridgeEstimates` | Bridge removal, truncation, $p_n\sim q_n\sim\pi_n$, three errors and divergent-mean variance | 1631–2090 |
| `MainPoisson` | Theorem `thm:PoissonApproximation` | 2092–2144 |
| `RootDeclumping` | Parent formula, mean asymptotics, inherited microscopicity, second main theorem | 2148–2331 |
| `CompleteArity` | Cut-and-graft, (S)/(C), raw/unary thresholds | 2442–2899 |
| `LeafHeight` | Root-tail recursion/asymptotics, (S)/(C), lattice thresholds | 2901–3387 |
| `Applications` and final reconciliation | Direct fringe/non-fringe/outdegree applications, substantive remarks and consequences; retain conjectures as conjectures | 911–1553, 3007–3026, full `PAPER_INVENTORY.md` |

This is a dependency order, not an instruction to create empty modules. Keep
the deterministic layer small and independently useful. The hardest shared
missing mathematics is the stable lattice local-limit machinery and the exact
AGG bound; importing Poisson distributions does not supply these theorems.
Searches of the pinned probability/analysis library found no ready-made
Bienaymé/Galton–Watson, Łukasiewicz, Chen–Stein, or stable local-limit development.
This is a bounded search result, not proof that no useful helper exists anywhere.

## Verified library entry points

These names were inspected in the pinned source; no build was run for this note.

| Need | Existing module and declaration |
| --- | --- |
| Discrete offspring and tree laws | `Mathlib.Probability.ProbabilityMassFunction.Basic`: `PMF`, `PMF.toMeasure`, `PMF.toMeasure_apply` |
| Pushforwards and positive conditioning | `Mathlib.Probability.ProbabilityMassFunction.Constructions`: `PMF.map`, `PMF.filter` |
| Branching mixtures | `Mathlib.Probability.ProbabilityMassFunction.Monad`: `PMF.bind` |
| General conditioning | `Mathlib.Probability.ConditionalProbability`: `ProbabilityTheory.cond`, `ProbabilityTheory.cond_apply`, `ProbabilityTheory.cond_apply'` |
| Law characterization | `Mathlib.Probability.HasLaw`: `ProbabilityTheory.HasLaw` |
| Poisson law and zero mass | `Mathlib.Probability.Distributions.Poisson.Basic`: `ProbabilityTheory.poissonMeasure`, `ProbabilityTheory.poissonMeasure_real_singleton` |
| Poisson convolution | same module: `ProbabilityTheory.poissonMeasure_conv_poissonMeasure` |
| Total variation | `Mathlib.MeasureTheory.Measure.TotalVariation.Defs`: `MeasureTheory.tvDist`, `MeasureTheory.tvDist_triangle`, `MeasureTheory.tvDist_eq_iSup_finPartition_abs` |
| Cyclic list combinatorics | `Mathlib.Data.List.Rotate`: `List.rotate_rotate`, `List.rotate_perm`, `List.getElem_rotate`, `List.cyclicPermutations_rotate` |
| Little-o and equivalence | `Mathlib.Analysis.Asymptotics.Defs`: `Asymptotics.IsLittleO`; `Mathlib.Analysis.Asymptotics.AsymptoticEquivalent`: `Asymptotics.IsEquivalent` |
| Variance estimate | `Mathlib.Probability.Moments.Variance`: `ProbabilityTheory.meas_ge_le_variance_div_sq` |

## Publication-aware interface

Keep mathematical definitions public and expose bodies needed in theorem types;
use the pinned Lean module system. Keep source-level statement definitions
separate from proof implementation so a focused Challenge/Solution interface
can later be reviewed and compared. Do not publish a Challenge that assumes
the unfinished bridge estimates as if they were original paper hypotheses.
Do not add holes or axioms merely to fill the main-theorem interface now.
The eventual candidate must identify precisely which named paper results are
proved, and must pass the source, axiom, Comparator, and Palomar checks described
by the publication workflow. An initial deterministic library is useful progress,
not a verified candidate for the whole paper.
