# Formalization report

Updated 30 October 2026. This is the authoritative coverage record of the Lean
library `PoissonDeclumping`. The stable claim IDs and the full source inventory
are in [PAPER_INVENTORY.md](PAPER_INVENTORY.md), whose
"Implementation status overlay" section summarizes the table of Section 3.
Statement reviews are recorded in [INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md)
and manuscript observations in
[MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md).

## 1. Scope, source identity and environment

- **Paper:** *Rare subtree patterns in size-conditioned Bienaymé trees: Poisson
  approximation and declumping*, Igor Kortchemski and Leonard Vetter,
  arXiv:2607.22291v1.
- **Source:** `poisson-declumping-arxiv.tex`, 3,504 lines, SHA-256
  `3b75c02ec5e8a7e12d32cccddfe463ae79ca596d1b8b239bc0352110b6472595`
  (recomputed with `shasum -a 256` for this report; unchanged since the
  inventory). Line numbers below refer to this file.
- **Declared scope:** every theorem, proposition, lemma, corollary, definition,
  remark and substantive asserted claim of the paper, with the four Introduction
  theorems as the priority. Cited background results are in scope as
  dependencies. The user agreed to formalize the actual normalization-factor Potter bound,
  treating the generic Potter theorem as cited background. Conjectures and perspectives
  (Q01–Q05) are identified, not claimed. B06 and B07 remain open in the original inventory;
  selecting four declarations for Palomar does not silently discharge that broader scope.
- **Environment:** Lean `leanprover/lean4:v4.35.0`; mathlib release `v4.35.0`
  at commit `56a005855ea17e0b0958f73ec801ae140b0a1679`; all other dependency
  revisions as pinned in `lake-manifest.json` (unchanged).
- **Lean snapshot:** the maintained repository is
  [igor-kortchemski/rare-subtree-patterns](https://github.com/igor-kortchemski/rare-subtree-patterns).
  Proof candidate `81fbaf90a44aa3f8ae7807306288990dde3756ba` passed GitHub CI; this
  publication documentation revision preserves its mathematical sources and configuration.
  There are 106 module files under `PoissonDeclumping/` (29,063 lines; the largest,
  `Bridge/EndpointSmoothing.lean`, has 1,234 lines) plus the root `PoissonDeclumping.lean`.
  They include `Examples/BinomialWalk.lean` (an aperiodic witness for `(H_α)`) and
  `MainConsequences.lean` (the unconditional corollaries of Section 3). Every file has a
  `module` header. The current per-file and aggregate source identities are recorded in
  [verification/source-sha256.txt](verification/source-sha256.txt); the Lean-and-configuration
  hash is `8c8dfb521df2a6dc7c03073e8957ad94d56b53c941e6f4cb35dd6ad6651a0941`.

Declaration names below are relative to the namespace `PoissonDeclumping`
(for example `Bridge.critM` is `PoissonDeclumping.Bridge.critM`). Every name
cited was located in the source by `grep` for this report. The statements of
the four main theorems, of the statement-level definitions and of the principal
export for each numbered result were read and compared with the paper; helper
declarations in the B, U and P rows are cited as described in their module
docstrings.

## 2. Headline: the four Introduction theorems

The four Introduction theorems are proved as Lean theorems in
[PoissonDeclumping/MainTheorems.lean](PoissonDeclumping/MainTheorems.lean). Each
has exactly the type of the statement-level proposition in
[PoissonDeclumping/Statements/Main.lean](PoissonDeclumping/Statements/Main.lean),
which is the statement interface that was independently reviewed.

| Paper | Lean theorem | Type |
| --- | --- | --- |
| T1.1 `thm:PoissonApproximation` (lines 305–329) | `poissonApproximation` | `PoissonApproximationStatement` |
| T1.2 `thm:PoissonApproximation2` (lines 396–442) | `poissonApproximation2` | `PoissonApproximation2Statement` |
| T1.3 `thm:max_string` (lines 475–501) | `maxString` | `MaxStringStatement` |
| T1.4 `thm:max_lh` (lines 533–558) | `maxLeafHeight` | `MaxLeafHeightStatement` |

**Hypotheses.** Beyond the hypotheses that are part of each paper statement
((M) and (C) for T1.1; (S), (C) for the declumped marks and
$0<c_B<\infty$ for T1.2; $\mu_1>0$ or $\mu_r>0$ or $\mu_1=0$ for the cases of
T1.3–T1.4), the only assumption is the paper's standing hypothesis $(H_\alpha)$,
encoded by `StableDomain μ α a` and `InStableDomain μ` in
`Setup/Walk.lean`: $\mu$ is critical (mean one, stated in $[0,\infty]$),
$\mu_1\ne1$, $\alpha\in(1,2]$, and a positive nondecreasing sequence
$a_n$ normalizes $(K_1+\dots+K_n-n)/a_n$ to a probability law $\nu$ with
$\int e^{-\lambda y}\,d\nu(y)=e^{\lambda^\alpha}$ for $\lambda>0$.
The unused truncated-second-moment conjunct was removed from `StableDomain`
after an independent scope review. Callers supply the defining normalized
attraction condition, without an extra unproved equivalent characterization.
The general truncated-moment equivalence remains a separate background obligation.
Periodic offspring laws are included: all limits run along the admissible sizes
`admissibleSizes μ`, and no aperiodicity hypothesis appears.
`Examples.SimpleWalk.witness : StableDomain μ 2 a` (with that file's `μ` and `a`)
exhibits the hypothesis for the periodic law $(\delta_0+\delta_2)/2$ with
$a_n=\sqrt{n/2}$, so `(H_α)` is satisfiable. `Examples.BinomialWalk.witness :
StableDomain μ 2 a` is an aperiodic witness: the law
$(\delta_0+2\delta_1+\delta_2)/4$, with $\mu_1=1/2$
(`Examples.BinomialWalk.mu_one_pos`), lattice span $1$
(`Examples.BinomialWalk.latticeSpan_eq_one`), $\alpha=2$ and $a_n=\sqrt{n/4}$.

**How the proofs close.** The stable random-walk toolbox is derived, not
assumed: `Stable.stableToolkit : StableDomain μ α a → StableToolkit μ α a`.
Most intermediate lemmas are stated under `StableToolkit μ α a`; the paper-level
results follow by composing with `Stable.stableToolkit`, which
`Bridge.poissonApproximationStatement_of_b3` and
`Bridge.poissonApproximation2Statement_of_b3` do. The last Chen–Stein error term
is `Bridge.tendsto_errorB3` (P4.8), packaged as `errorB3Statement`; T1.3 and T1.4
are assembled by `Extremes.maxString_of` and `MaxLeafHeight.maxLeafHeight_of`
from T1.1–T1.2 (and T1.3 for T1.4). The corollaries that were proved as
lemmas conditional on a main theorem (C3.1, R3.2, C3.8, P3.9, C5.3, U01, U03)
are exported unconditionally in
[PoissonDeclumping/MainConsequences.lean](PoissonDeclumping/MainConsequences.lean),
namespace `PoissonDeclumping.Main`, by supplying the proved main theorem.

**What "proved" means here.** The Lean kernel accepts closed proofs of these
four propositions in the pinned environment. Their transitive axioms are exactly
`propext`, `Classical.choice`, `Quot.sound` (Section 5). The statement
propositions contain no hypothesis beyond the paper's statements and
`(H_α)`.

**What it does not mean.**

- That the Lean propositions say what the paper says is a human judgement. It
  rests on the independent statement review in
  [INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md), "Main-theorem statement
  interfaces": PASS for T1.1, T1.3, T1.4 and the setup files; PASS-WITH-FINDINGS
  for (S) and T1.2, finding F1 applied. The F1 change and two later definitional changes were
  re-reviewed by the final independent review of the four theorems (PASS-WITH-FINDINGS, no blocking
  finding; Section 6). A Challenge/Solution pair for Comparator is prepared and was reviewed as a
  standalone document (`Challenge.lean`, `Solution.lean`); Comparator was not run.
- It is not a claim that every result of the paper is formalized, nor that
  every written proof was checked. Coverage of the other inventory items is in
  Section 3; items not formalized are listed in Section 3.7. Where the Lean
  proof takes a different route, it proves the result without validating the
  paper's written argument for that step (Section 4).

## 3. Coverage by inventory ID

Status vocabulary: **Proved** (an exported Lean theorem with the paper's
content, possibly generalized), **Proved (route differs)**, **Proved (corrected
statement, R…)** (the paper's statement is corrected for the periodic case as
recorded in Section 4 and the manuscript recommendation cited), **Helper/partial**, **Bypassed** (replaced by a weaker tool that suffices),
**Not formalized (disclosed)**, **Conjecture (not claimed)**. Rows D-M, D-S, D-C
are definitions and are marked **Defined**. "Toolkit" means that the Lean
statement assumes `StableToolkit μ α a` (derived from `(H_α)` by
`Stable.stableToolkit`) instead of `StableDomain μ α a`. A hypothesis
`h1 : PoissonApproximationStatement` (or `h2`, `h` for T1.2, T1.4) is discharged
by the corresponding proved main theorem; the instantiated, unconditional forms
are exported in `MainConsequences.lean` under the namespace `Main` (for example
`Main.poisson_fringe` is `PoissonDeclumping.Main.poisson_fringe`), each with the
statement of the conditional lemma minus that hypothesis.

The statements of the intermediate results were independently reviewed against
the paper as recorded in Section 6 and INDEPENDENT_REVIEW.md. Those scoped
statement reviews do not amount to a manual review of every proof body.

### 3.1 Introduction theorems and assumptions

| ID | Status | Lean | Notes |
| --- | --- | --- | --- |
| T1.1 | Proved | `poissonApproximation` (`MainTheorems`); per law: `Bridge.poissonApproximation_of_b3`, `Bridge.poissonApproximation_divergent` (`Bridge/MainTheorems`) | Both regimes: TV to $\operatorname{Po}(n\pi_n)$ for bounded $n\pi_n$; $N_n/(n\pi_n)\to1$ in probability and $P(N_n\le K)\to0$ for divergent $n\pi_n$. Hypothesis: some cutoff with (M) and (C). |
| T1.2 | Proved | `poissonApproximation2`; per law `Bridge.poissonApproximation2_of_b3` | Raw (S) and declumped (C) with the same cutoff; $c_B$ as `cB μ B` with `0 < cB μ B < ∞`. Statement re-review after F1 passed; see Section 6. |
| T1.3 | Proved (route differs) | `maxString`; `Extremes.maxString_of`, `Extremes.maxString_unary_of`, `Extremes.maxString_rary_of` | (ii) uses T1.1(ii) instead of C3.8(ii) (recommendation R1); one two-point level for all $n$ instead of the split at $\theta_n=1/2$. |
| T1.4 | Proved (route differs) | `maxLeafHeight`; `MaxLeafHeight.maxLeafHeight_of_approx2_maxString`, `maxLeafHeight_unary`, `maxLeafHeight_superexp_of_cConst_pos`, `maxLeafHeight_of_cConst_eq_zero` | $C_\mu$, $D_\mu$ stated as limits of $\pi_k/\mu_1^k$ and $\pi_k^{1/\kappa^k}$. Uses T1.2 and T1.3 only; one two-point level. |
| D-M | Defined | `Microscopic`, `uniformFringeLaw` (`Setup/Marks`) | Reviewed PASS. |
| D-S | Defined | `StructuralMicroscopic`, `Skeleton` | Decomposition required only at marks of positive probability (F1); re-review passed (Section 6). $E[L]/a_{M_n}$ stated in $[0,\infty]$. |
| D-C | Defined | `pairProb`, `NonClustering` | Reviewed PASS. |

### 3.2 Numbered results, definition and remarks

| ID | Status | Lean (module) | Notes |
| --- | --- | --- | --- |
| D2.1 | Proved | `Cyclic.firstIndicator`, `shiftIndicator`, `cyclicSum`, `firstIndicator_take`, `firstIndicator_congr_take`, `firstIndicator_eq_zero_or_eq_one`, `cyclicSum_mono`, `cyclicSum_dfsSeq` (`Cyclic/Indicators`) | Locality, Boolean range, monotonicity in the cutoff, sum equals truncated count. |
| L2.2 | Proved | `Cyclic.map_cyclicSum_conditioned`, `Cyclic.markedCountLaw_eq` (`Cyclic/RandomWalk`) | Equality of laws for every $n$ (both sides zero at inadmissible $n$). |
| C2.3 | Proved | `Cyclic.uniformFringeLaw_real_eq` (`Cyclic/UniformVertex`) | Exactly the displayed identity, $\Psi_m=0$ for $m<0$ built in. |
| C3.1 | Proved | Unconditional form `Main.poisson_fringe` (`MainConsequences`); conditional `DirectApplications.poisson_fringe_of` (`FringeCorollary`), from `h1` | Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.1). Generalization `poisson_fringe_of_forces_size`; cutoff `max 1 k_n`. |
| L3.3 | Proved | `Bridge.microscopic_of_tail_of_eventually_pos`, `Bridge.microscopic_of_tail` (`CriterionM`) | Toolkit. The second form drops the hypothesis $\pi_n>0$. |
| L3.4 | Proved | `Bridge.critM` (`CriterionS`) | Toolkit; cutoff `max 1 ⌊n^(1-η)⌋₊` (equal for $n\ge1$); only the upper bound $E[C+L]\le n^{\delta}$ is assumed. |
| L3.5 | Proved | `Bridge.forest_tail_le`, `Bridge.forest_weighted_tail_sup_le`, `Bridge.forest_weighted_tail_div_le` (`ForestEstimates`) | Toolkit; also valid for $\ell=0$. (ii) is exported in the paper's divided form at admissible $n$ with an arbitrary endpoint selector (`forest_weighted_tail_div_le`), and in $\sup_x$ form only in the numerator (`forest_weighted_tail_sup_le`); the two are equivalent (R5). |
| L3.6 | Proved (route differs) | `Bridge.consequenceM_tail`, `consequenceM_weighted`, `consequenceM_weighted_sup`, `consequenceM_weighted_div` (`Microscopic`) | Toolkit; numerator form avoids $\Psi_{n-c}(-1)=0$ in periodic case (R5). |
| C3.7 | Proved | `Bridge.microscopic_of_structural`, `Bridge.integral_markCount_isEquivalent`, `Bridge.conditioned_mark_tendsto_zero` (`Microscopic`) | Toolkit; parts (i)–(iii). |
| C3.8 | Proved | Unconditional form `Main.nonfringe_poisson` (`MainConsequences`); conditional `DirectApplications.nonfringe_poisson_of`, `nonfringe_poisson_of_general` (`NonFringe`), from `h1` | Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.1). Exact hypotheses incl. aperiodicity (unused); the general (conditional) form drops aperiodicity, $\lvert T_k\rvert=k$, $k_n\to\infty$. |
| P3.9 | Proved | Unconditional form `Main.large_outdegree` (`MainConsequences`); conditional `DirectApplications.large_outdegree_of`, `large_outdegree_of_general` (`Outdegree`), from `h1` | Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.1). Limit law in TV (stronger than in distribution); the general (conditional) form drops $d_n\to\infty$, $\mu_{d_n}>0$. |
| P4.1 | Proved (route differs) | `ChenStein.prop_AGG`; sharper `ChenStein.exists_paperTVDist_le_two_mul_add` (`ChenStein/AGG`) | Paper cites AGG89; Lean proves it with the Stein factor $\lVert f\rVert\le1$, giving $2b_1+2b_2+b_3$. |
| L4.2 | Proved (corrected statement, R2: compatible endpoints only) | `Bridge.exists_cond_take_le` (`BridgeRemoval`) | Toolkit; general total length $N_n$; supremum over compatible endpoints $\Psi_{N_n}(k)\ne0$ only (R2); see Section 4. |
| C4.3 | Proved | `Bridge.exists_qProb_le_mul_markProb` (`BridgeRemoval`) | At admissible $n\ge1$ (R5). Assumes only $M_n=o(n)$, as in the paper; no positivity or divergence of the cutoff is required. |
| L4.4 | Proved | `Bridge.tendsto_paperTVDist_cyclicSum_truncated`, `tendsto_paperTVDist_cyclicSum_markedCountLaw`, `tendsto_mul_qProb_sub_mul_markProb`, `tendsto_paperTVDist_poisson_qProb_markProb` (`Truncation`) | No toolkit or cutoff needed. |
| L4.5 | Proved (route differs) | `Bridge.isLittleO_walkVecLaw_firstMarked_abs_sum_gt_admissible`, `Bridge.isEquivalent_pProb_qProb_markProb` (`Truncation`) | Toolkit; (i) by marginal tightness, without (M) (R6). |
| P4.6 | Proved | `Bridge.tendsto_errorB1` (`ErrorTerms`) | Toolkit. |
| L4.7 | Proved | `Bridge.tendsto_errorB2` (`ErrorTerms`) | Toolkit; two-start bound conditioned at $\zeta$ (R7). |
| P4.8 | Proved (route differs) | `Bridge.eventually_errorB3_le`, `Bridge.tendsto_errorB3` (`EndpointSmoothing`) | Toolkit; uniform in $\lVert f\rVert_\infty\le1$; (M) not needed. |
| L4.9 | Proved (corrected statement, R4; route differs) | `Bridge.tendsto_lem1`, `Bridge.eventually_lem1`, `Bridge.eventually_abs_endpointMean_sub_le` (`EndpointSmoothing`) | Corrected statement: base point $h_n(k_0)$ at a compatible $k_0$ with $\lvert k_0\rvert\le r_n$; the paper's $h_n(0)$ can condition on a null event (R4). The case $k_0=0$ is not a separate export. |
| L4.10 | Proved | `Bridge.tendsto_bridgeLaw_one_le_cyclicSum`, `Bridge.tendsto_bridgeLaw_abs_cyclicSum_div_sub_one` (`ExtremeMeans`) | (ii) toolkit. |
| L5.1 | Proved ((iii) route differs) | `RootDeclumping.lem_root_declumping` (`Lemma51`), `RootDeclumping.root_declumping_bounded`, `root_declumping_divergent`, `bB_mul_le_declumped` (`ParentFormula`), `Bridge.microscopic_declumped` (`RootMicroscopic`) | (iii) toolkit, numerator form with time shift $j=1$ instead of $n\to n-1$ (R5). |
| L5.2 | Proved | `PlaneTree.declump_to_raw` (`Declumping/Probability`), `PlaneTree.conditioned_declump_to_raw` (`Declumping/Conditioned`) | Generalized to arbitrary laws and filters; specialized to $\mathcal T^n$ along admissible sizes. |
| C5.3 | Proved | Unconditional form `Main.declump_zero` (`MainConsequences`); conditional `DirectApplications.declump_zero_of` (`DeclumpZero`), from `h2` | Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.2). Paper's three-step argument. |
| L5.4 | Proved | `tendsto_zero_of_tendsto_lintegral_zero`, `tendsto_one_of_witness` (`Extremes/Ineqs`) | Arbitrary filter and probability spaces; expectation in $[0,\infty]$. |
| L6.1 | Proved | `PlaneTree.lem_cut_graft`, `PlaneTree.lem_cut_graft_real` (`Patterns/CutGraftBound`) | Nonempty finite index type (R3); no criticality needed. |
| L6.2 | Proved (i)–(iii); (ii) route differs | `Applications.lem_S_rary_i`, `lem_S_rary_ii`, `lem_S_rary`, `pairSum_completeTree_le` (`CompleteArySC`); `Applications.lem_S_rary_iii` (`MainConsequences`) | (i) toolkit. (ii) is the summed pair bound (Assumption (C)), for every $M_n=o(n)$; route differs (P19 by cut-and-graft). (iii) $E[N_{k_n}(\mathcal T^n)]\sim n\pi_{k_n}$ under `StableDomain`: C3.7(ii) applied to (S) from (i), as in the paper; the exponent $\eta$ is chosen internally since the conclusion does not involve the cutoff. |
| L6.3 | Proved | `Applications.lem_C_rary` (`CompleteArySC`) | Every level sequence, every $M_n=o(n)$. |
| L7.1 | Proved ((ii) route differs) | `LeafHeight.lem_ell_asymp_i_tree`, `lem_ell_asymp_ii_tree` (`LeafHeight/Tree`); analytic `lem_ell_asymp_i`, `lem_ell_asymp_ii` (`Asymptotics`) | Asymptotic equivalents, not log-order; (ii) uses a monotone sandwich instead of the superexponential bound. |
| L7.3 | Proved (i), (ii) | `Applications.lem_S_lh` (`LeafHeightSC`); `Applications.lem_S_lh_ii` (`MainConsequences`) | (i) toolkit. (ii) $E[N_{k_n}(\mathcal T^n)]\sim n\pi_{k_n}$ under `StableDomain`: C3.7(ii) applied to (S) from (i), as in the paper; $\eta$ chosen internally; the section's assumption $c>0$ is not needed. P23 bound: see Section 4. |
| L7.4 | Proved | `RootDeclumping.lem_lh_conditional_mark` (`LeafHeightMark`) | The surrounding assumption $c>0$ is not needed. |
| L7.5 | Proved (route differs) | `Applications.lem_C_lh`, `Applications.pair_lhDeclumped_le` (`LeafHeightSC`) | Different cut-tree selector (P25). |
| R3.2 | Proved; bibliographic part not formalized | Unconditional forms `Main.poisson_fringe_prescribed_tree`, `Main.poisson_fringe_size`, `Main.poisson_fringe_degreeStatistic` (`MainConsequences`); conditional `DirectApplications.poisson_fringe_prescribed_tree`, `poisson_fringe_size`, `poisson_fringe_degreeStatistic`, from `h1`, and `isDegreeStatistic_degreeStatistic` (`FringeCorollary`) | Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.1). Comparisons with CD17 and BHJ26 are bibliographic and not formalized. |
| R7.2 | Proved | `LeafHeight.tendsto_piSeq_succ_div`, `ellSeq_isEquivalent_of_pos`, `ellSeq_isEquivalent_of_zero` (`LeafHeight/Consequences`), `LeafHeight.bienayme_real_rootLeafHeight_eq` (`LeafHeight/Tree`) | Tree identification $\ell_k=P(\lambda_\varnothing=k)$. |

### 3.3 Background and cited prerequisites

| ID | Status | Lean (module) | Notes |
| --- | --- | --- | --- |
| B01 | Proved | `PlaneTree.weight_node`, `bienayme_apply_singleton`, `bienayme_children_eq`, `bienayme_node_ofFn_mem` (`Bienayme/Basic`), `PlaneTree.bienayme_isProbabilityMeasure` (`Bienayme/Normalization`) | Product formula, branching property, normalization. |
| B02 | Proved | `PlaneTree.mem_range_dfsSeq_iff`, `dfsSeq_append_inj`, `ofSeq_rotate_dfsSeq` (`Lukasiewicz/Coding`) | `eq:fringe`. |
| B03 | Proved | `PlaneTree.map_dfsSeq_conditioned`, `map_shift_conditioned` (`Lukasiewicz/BridgeLaw`), `Lukasiewicz.existsUnique_zeta_rotate_eq_length` (cycle lemma) | `eq:shifts` as equalities of measures. |
| B04 | Proved | `Cyclic.cyclicSum_rotate`, `Cyclic.map_bridgeLaw_comp_perm`, `Cyclic.bridgeLaw_shiftIndicator_eq_one` | |
| B05 | Proved | `Cyclic.walkVecLaw_zeta_eq_inter`, `walkVecLaw_firstIndicator_eq`, `walkVecLaw_firstIndicator_inter_sum` (`Cyclic/Markov`) | |
| B06 | Helper/partial | `Stable.regularlyVaryingSeq`, `slowlyVarying` (`Normalization`); `stableDomain_of_finiteVariance`, `inStableDomain_of_finiteVariance` (`FiniteVariance`); `exists_stable_limit_of_tendsto_mul_stepCF_sub_one` (`DomainCharacterization`) | Regular variation and the finite-variance converse are proved. The general equivalence at line 712 remains open: the new Levy/Prokhorov bridge constructs a limit only after an explicit CF estimate, which is not yet derived from truncated moments. `Stable/TruncatedMoment` now supplies actual shifted cosine-defect head/tail bounds, without stable-domain assumptions. |
| B07 | Helper/partial | `Stable.maximal_tight`, `maximal_le_two_mul_tail`, `tendsto_maximal_tail` (`Stable/MaximalTightness`); `Stable.tight` | The actual maximum over all partial sums on one product-law path is uniformly tight, proved by an Ottaviani first-exit decomposition. Full functional $J_1$ convergence remains open. |
| B08 | Required specialization proved; general statement cited background (R9) | `RegularlyVaryingSeq.potter`, `potter_floor_slowlyVarying` (`RegularVariation/Potter`, `Functions`) | The all-real bound for the actual normalizing slow factor is proved. The agreed formalization scope uses this specialization. No generic theorem for arbitrary ratio-only slowly varying functions is claimed (R9). |
| B09 | Proved (route differs) | `Stable.localLimit`, `localLimit_aperiodic`, `localLimit_of_support`, `walkProb_eq_zero_of_not_dvd`, `stableDensity`, `limitLaw_eq_withDensity`, `latticeSpan`, `latticeLocal`; `exists_norming_isEquivalent_sqrt`, `alpha_eq_two_of_finiteVariance` (`Stable/FiniteVariance`) | Local limits and density as before. The finite-variance normalization is now proved from actual offspring second moments by CLT and convergence of types. |
| B10 | Proved | `StableToolkit.sup_le` (from `Stable.exists_walkProb_le`), `StableToolkit.exists_lower_bound_neg_one`, `eventually_abs_div_sub_one_le`, `eventually_walkProb_neg_one_pos_iff` (`Setup/Toolkit`) | Ratios at compatible points only. |
| B11 | Proved | `Bridge.natCast_mul_forestSizeWeight`, `walkProb_neg_eq_sum` (`Bridge/Kemperman`), `walkProb_neg_one` (`Cyclic/WalkBridge`), `Bridge.tree_size_asymp` (`ForestEstimates`) | Dwass/Kemperman for forests via a generalized cycle lemma (paper cites it). |
| B12 | Proved | `RegularlyVaryingSeq.karamata_tail`, `karamata_tail_tsum`, `karamata_sum` (`RegularVariation/Karamata`) | From global Potter bounds. |
| B13 | Proved (route differs) | `PlaneTree.bienayme_isProbabilityMeasure` (`Bienayme/Normalization`); `LeafHeight.g`, `LeafHeight/Recursion` | Extinction by fixed point of the generating function and Bernoulli's inequality; P23 uses an explicit bound instead of differentiated expansions. |
| B14 | Proved (real-valued application; route differs) | `RealCoupling.exists_measurable_real_coupling` (`Probability/Skorokhod`); `exists_measurable_coupling_of_weak`, `Stable.exists_timeScaled_coupling`, `exists_trimmed_walk_coupling`, `tendsto_timeScaledLaw` (`Stable/CDF`) | Actual marginal laws are preserved on an explicit common probability space; measurable versions converge almost surely. The main smoothing proof still uses the deterministic bound, so this does not retroactively validate its original written route. |
| B15 | Proved | `paperTVDist_map_le_measureReal_ne`, `paperTVDist_map_le_integral_sub`, `paperTVDist_poissonMeasure_le_abs_sub`, `abs_measureReal_zero_sub_exp_le_paperTVDist` (`Probability/PoissonTV`), `paperTVDist_le_iff`, `paperTVDist_triangle` (`Probability/TotalVariation`) | `paperTVDist` is half of mathlib's `tvDist`. |

### 3.4 Unnumbered consequences and structural claims

| ID | Status | Lean (module) | Notes |
| --- | --- | --- | --- |
| U01 | Proved | `DirectApplications.integral_markCount_eq_mul_uniformFringeLaw`, `microscopic_first_iff`, `nonClustering_of_iSup_pairProb`, `hypotheses_of_convenient_criterion`, `poisson_of_convenient_criterion` (from `h1`) (`Criteria`); unconditional form of the convenient criterion (lines 359–364) `Main.poisson_of_convenient_criterion` (`MainConsequences`) | $n^{o(1)}$ hypotheses used through their upper halves. Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.1). |
| U02 | Proved (route differs) | `DirectApplications.unary_raw_zero_tendsto`, `unary_raw_eventually_tv_pos`, `unary_raw_not_tendsto_poisson_mean`, `unary_counterexample_exists` (`UnaryClustering`) | Actual zero limit $\exp(-(1-\mu_1)\lambda)$; explicit admissible subsequence realizes raw mean $1$. Derived from T1.3(i), not CD17's proof. |
| U03 | Proved | constants inside `MaxLeafHeightStatement`; `LeafHeight.lem_ell_asymp_i_tree`, `lem_ell_asymp_ii_tree`; unconditional forms `Main.leafHeight_div_log_tendsto`, `Main.leafHeight_div_logb_log_tendsto` (`MainConsequences`); conditional `MaxLeafHeight.leafHeight_div_log_tendsto`, `leafHeight_div_logb_log_tendsto` (`MaxLeafHeightFirstOrder`), from `h` | First-order limits derived from `MaxLeafHeightStatement`. Unconditional form in `MainConsequences.lean` (from the conditional lemma and the proved T1.4). |
| U04 | Proved | `PlaneTree.le_leafHeight_iff_markCount_pos` (`LeafHeight/Tree`), `PlaneTree.le_maxCompleteHeight_iff_markCount_pos` (`Patterns/Complete`), `PlaneTree.declumped_count_pos_imp_raw_count_pos` (`Declumping/Deterministic`) | |
| U05 | Proved | `PlaneTree.vertexCount_fringeTrees_lt`, `not_forced_size_nested` (`Cyclic/Indicators`), `Cyclic.pairProb_eq_zero_of_forces_size` | |
| U06 | Proved | `PlaneTree.bienayme_embeds_eq`, `cond_embeds_leafTrees_pi`, `cond_embeds_eq_map_graftLeaves`, `skeleton_embeds` (`Patterns/NonFringe`) | |
| U07 | Proved | `PlaneTree.internalCount_completeTree_one`, `internalCount_completeTree_of_two_le`, `leafCount_completeTree`, `bienayme_embeds_completeTree_one`, `bienayme_embeds_completeTree_of_two_le` (`Patterns/Complete`) | |
| U08 | Proved | `PlaneTree.cut_graft`, `graft_cut`, `graft_inj`, `cutFamily_eq`, `cutEquiv`, `PlaneTree.MarkedTree.fringeAt_graft` (`Patterns/CutGraft`) | |
| U09 | Proved | `LeafHeight.cConst_nonneg`, `support_subset_of_cConst_eq_zero`, `mass_kappa_of_cConst_eq_zero`, `leafD_of_cConst_eq_zero`, `centering_eq_of_cConst_eq_zero` (`LeafHeight/Consequences`); `PlaneTree.leafHeight_eq_maxCompleteHeight`, `le_rootLeafHeight_iff_embeds` (`Patterns/Complete`) | Analytic and geometric halves. |
| U10 | Proved | `LeafHeight.bienayme_real_le_rootLeafHeight` (`LeafHeight/Tree`), `LeafHeight.strictAnti_piSeq`, `tendsto_piSeq_zero`, `piSeqZ` (`LeafHeight/Recursion`) | |
| U11 | Proved | `RootDeclumping.lh_declumped_prob_eq`, `lh_declumped_isEquivalent` (`LeafHeightMark`) | |
| U12 | Proved | `DirectApplications.compoundPoisson_leafHeight_mean`, `mean_isEquivalent_leafHeight` (`CompoundPoisson`) | Mean calculation only; the conjectured limit (Q02) is not formalized. |
| U13 | Proved | `LeafHeight.tendsto_natCast_mul_piSeq_succ`, `tendsto_natCast_mul_piSeq_succ_of_ell` (`LeafHeight/Consequences`) | |

### 3.5 Substantive proof obligations

| ID | Status | Lean (module) |
| --- | --- | --- |
| P01 | Proved | `Cyclic.walkVecLaw_bridge_inter_ofSeq` (`UniformVertex`); remainder endpoint $0$ |
| P02 | Proved | `Bridge.eventually_abs_uniformFringeLaw_real_sub_le`, `exists_uniformFringeLaw_real_le_mul` (`CriterionM`); compatible sizes in the periodic case |
| P03 | Proved | `Bridge.forest_weighted_tail_sup_le`, `forest_weighted_tail_le` (`ForestEstimates`) |
| P04 | Proved (route differs) | `Bridge.consequenceM_weighted`, `lintegral_skeleton` (`Microscopic`); numerator form (R5) |
| P05 | Proved | `Bridge.conditioned_mark_tendsto_zero` (`Microscopic`) |
| P06 | Proved | `DirectApplications.structuralMicroscopic_embeds` (`NonFringe`), `nonClustering_of_iSup_pairProb` (`Criteria`) |
| P07 | Proved | `DirectApplications.embeds_star_iff`, `bienayme_degSeq_pair_le` (`Outdegree`) |
| P08 | Proved | `Bridge.exists_cond_take_le` (`BridgeRemoval`), `Bridge.walkVecLaw_real_take_inter_sum` (`WalkCalculus`) |
| P09 | Proved | `Bridge.integral_cyclicSum_sub_truncated`, `paperTVDist_cyclicSum_truncated_le` (`Truncation0`) |
| P10 | Proved (route differs) | `Bridge.walkVecLaw_firstMarked_abs_sum_gt_le` (`Truncation0`), `isLittleO_walkVecLaw_firstMarked_abs_sum_gt_admissible` (`Truncation`), `RegularlyVaryingSeq.tendsto_sqrt_div`; marginal tightness |
| P11 | Proved | `Bridge.walkVecLaw_real_pair_le_markProb` (`PairBound`); conditioning at $\zeta$ (R7) |
| P12 | Proved (route differs) | `Bridge.eventually_abs_endpointMean_sub_le`, `abs_windowMean_sub_le`, `abs_walkProb_div_sub_div_le`, `tendsto_lem1` (`EndpointSmoothing`); compatible base point, no Skorokhod |
| P13 | Proved | `Bridge.eventually_pairBridge_le`, `sum_sum_cycEvent_inter_le`, `eventually_errorB2_le` (`ExtremeMeans`) |
| P14 | Proved | `Bridge.poissonApproximation_divergent` (`Bridge/MainTheorems`) |
| P15 | Proved | `RootDeclumping.parent_formula`, `pointwise_bounds`, `tendsto_parentFun_div` (`ParentFormula`); first moment only |
| P16 | Proved (route differs) | `Bridge.lintegral_declumped_le`, `forest_bound_weighted`, `tendsto_tsum_min_div`, `microscopic_declumped` (`RootMicroscopic`); time shift $j=1$ (R5) |
| P17 | Proved | `PlaneTree.declumped_count_pos_imp_raw_count_pos`, `marked_root_of_no_declumped` (`Deterministic`), `zero_probability_sandwich` (`Declumping/Probability`) |
| P18 | Proved | `PlaneTree.MarkedTree.weight_graft`, `PlaneTree.bienayme_cut_mem` (`CutGraft`), `PlaneTree.cut_graft_bound_aux` (`CutGraftBound`) |
| P19 | Proved (route differs) | `Applications.pairSum_completeTree_le` (`CompleteArySC`), `PlaneTree.exists_replaceClass`, `classCount_le` (`TreeCompleteClass`) |
| P20 | Proved (route differs) | `Extremes.maxString_unary_of`, `maxString_rary_of`; `ExtremesAnalysis.tStar_identity`, `rary_twoPoint_thresholds`, `interior_thresholds`, `twoPoint_thresholds`; split lemmas `fract_le_half_thresholds`, `half_lt_fract_thresholds` also provided |
| P21 | Proved | `PlaneTree.embeds_completeTree_replaceAt` (`TreeCompleteClass`), `Applications.pair_declumped_completeTree_le` |
| P22 | Proved (route differs) | `LeafHeight.lem_ell_asymp_i`, `lem_ell_asymp_ii`, `logD_error_bounds` (`Asymptotics`) |
| P23 | Proved (route differs) | `RootDeclumping.cond_rootDegree_children_mem_tilt`, `tiltMean_le`, `lintegral_genCount_cond_le`, `lintegral_skelSize_add_genCount_cond_le` (`LeafHeightGenerations`), `lhSkeleton_skeleton`, `lintegral_lhSkeleton_le` (`LeafHeightSkeleton`); explicit bound $m_s\le\kappa\exp(\pi_{s-1}/(\kappa\mu_\kappa))$ (`tiltMean_le`; obtained from $m_s\le\kappa+\pi_{s-1}/\mu_\kappa$ in its proof) |
| P24 | Proved (route differs) | `MaxLeafHeight.maxLeafHeight_unary`, `maxLeafHeight_superexp_of_cConst_pos`, `maxLeafHeight_of_cConst_eq_zero`; `ExtremesAnalysis.lh_twoPoint_thresholds`, `lh_interior_thresholds`, `lh_center_eq_tStarStar` |
| P25 | Proved (route differs) | `Applications.pair_lhDeclumped_le`, `PlaneTree.le_rootLeafHeight_replaceAt` (`LeafHeightSC`); minimal admissible selector |

### 3.6 Conjectures and perspectives

| ID | Status | Notes |
| --- | --- | --- |
| Q01–Q04 | Conjecture (not claimed) | The expected Poisson and compound Poisson limits of the final section are not formalized. Only the separately asserted calculations U12 and U13 are proved. |
| Q05 | Conjecture (not claimed) | Perspectives and heuristics; no precise statement. |

### 3.7 What is not formalized

None of the following is an Introduction theorem.

| Item | Source | Classification |
| --- | --- | --- |
| Q01–Q05 | 664–667, 3431–3496 | Conjecture (not claimed). |
| General Potter theorem | 850–853 (B08) | Cited background, outside the agreed Potter target. The required all-real norming-factor bound is proved; no general measurable theorem is claimed. |
| General equivalence of the stable domain of attraction with the truncated-second-moment clause | 712 (part of B06) | Open. Finite-variance converse and a genuine Levy existence bridge are now proved; the general truncated-moment Abelian estimate, inverse normalizer and Laplace identification remain. |
| Functional $J_1$ convergence `eq:cvlaw` | 846–850 (B07) | Open; the main results use proved marginal tools instead. A process law, the $J_1$ topology and a functional convergence proof are still required. |
| Historical and bibliographic comparisons | R3.2 (971–1006), 340–346, 582–586, 653–662, 1424–1430, 3024 (R7.2: "extends [DGZ23, Lemma 9]"), 3391–3405 (related work: DJ14, Jan16, GGLS23, BP17, MS26) | Not formalized (bibliographic, not mathematical obligations). |
| L4.9 with base point $h_n(0)$ exactly | 1872–1876 | Not exported: the corrected statement with a compatible base point is proved (R4). |

## 4. Proof correspondence and departures

Proving a result in Lean establishes that result; it validates the paper's
written argument only where the Lean proof follows that argument. The table
records where it does not. "Paper argument checked" refers to the written proof
of that step.

| Item | Paper | Lean | Effect | Paper argument checked |
| --- | --- | --- | --- | --- |
| B07, B14 | Functional $J_1$ convergence and the real-valued Skorokhod step | Main proof uses marginal tightness and deterministic endpoint smoothing. Later modules independently prove actual maximal tightness and the precise trimmed-walk measurable coupling. | Main results unchanged; full $J_1$ convergence still open | Original route remains bypassed (R6), despite the newly available representation theorem. |
| B01, B13 | Normalization and extinction cited as background | Generating-function fixed point and Bernoulli's inequality | Proof supplied | Not applicable (cited). |
| P4.1 | AGG bound cited from AGG89 | Chen–Stein proof with the Stein factor $\lVert f_A\rVert\le1$; proves $2b_1+2b_2+b_3$, which implies $2(b_1+b_2+b_3)$ | Proof supplied; slightly sharper | Not applicable (cited). |
| B06, B08, B09, B12 | Regular variation, Potter, local limit, Karamata cited | Convergence of types; norming-factor Potter bounds; CF-based local limits; Karamata bounds | Used tools proved; generic B06/B08 obligations remain as in Section 3 | Not applicable (cited). |
| B11 | Dwass/Kemperman for forests cited | Generalized cycle lemma | Proof supplied | Not applicable (R8). |
| L3.5(ii), L3.6, L5.1(iii) | Ratios $\Psi_{n-c}(-1)\sim\Psi_n(-1)$ and the shift $n\to n-1$ | Numerator forms, divided by $\Psi_n(-1)\ge c/a_n$ at the end | Periodic case covered | Partly: the aperiodic argument is followed; its periodic reading is corrected (R5). |
| L4.2, C4.3 | Supremum over all $\lvert k\rvert\le z_n$; every $n\ge1$; $M_n=o(n)$ | Compatible $k$ ($\Psi_{N_n}(k)\ne0$); admissible $n\ge1$; `IsCutoff M` | Null conditionings excluded; the aperiodic literal form follows for large $n$ but is not exported | R2, R5. |
| L4.9, P12 | $\Delta_n(k)=h_n(k)-h_n(0)$ | Oscillation of $h_n$ over compatible endpoints, base point $k_0$ compatible | Corrected statement; conclusion of P4.8 unchanged | Aperiodic argument followed; periodic gap repaired (R4). |
| L4.7, P11 | "two independent Bienaymé trees" on a size-dependent event | Conditioning at $\zeta=j$ and fresh increments | Same bound | Step made precise (R7). |
| L7.1(ii), P22 | Superexponential bound | Monotone sandwich $v_k\le\log D_\mu\le u_k$ | Same asymptotic equivalent | Different route for the tail error. |
| L6.2(ii), P19 | Skeleton/forest split and union bound over an infinite forest | Cut-and-graft at every DFS position with a class $j\le k$ | Same bound $K\pi_k+M\pi_k^2$ | Different route. |
| L7.5, P25 | Selector $\tau(A)=0$ or $(k-h(A))_+$ | Minimal admissible selector | Same pair bound | Different route. |
| L7.3, P23 | $m_s=1+O(\pi_{s-1})$ or $\kappa+O(\pi_{s-1})$ | Explicit bound $m_s\le\kappa\exp(\pi_{s-1}/(\kappa\mu_\kappa))$ (`RootDeclumping.tiltMean_le`; obtained from $m_s\le\kappa+\pi_{s-1}/\mu_\kappa$ in its proof) | Same constants | Local adaptation. |
| T1.3(ii) | Invokes C3.8(ii), whose uniform pair hypothesis is not established | T1.1(ii) with (M) from C3.7(i) and (C) from L6.2(ii) | Same conclusion | Corrected citation (R1). |
| T1.3(ii), T1.4(ii), P20, P24 | Case split at $\theta_n=1/2$ | One level $a_n=\lceil x_n-1/2\rceil-1$ with $J_n=\{a_n,a_n+1\}$; integer levels through `Int.toNat` | Same conclusion; split lemmas also proved | Different bookkeeping. |
| L3.4, C3.1, applications | $M_n=\lfloor n^{1-\eta}\rfloor$ or $M_n=k_n$ | `max 1 ⌊n^(1-η)⌋₊`, `max 1 k_n`; `IsCutoff` requires $M_n>0$ only for $n\ge1$ | Equal for large $n$ | Not affected (R8). |
| Null marks | Paper works along subsequences with $\pi_n>0$ | `ProbabilityTheory.cond` of a null event is $0$; lemmas hold without $\pi_n>0$ | Generalization | Not affected. |

Module docstrings refer to corrections by labels F1–F15 of
[docs/BRIDGE_PLAN.md](docs/BRIDGE_PLAN.md). Their mathematical content is described
in the docstrings and corresponds to the manuscript recommendations as follows:
F1, F4 (compatible endpoints) to R2/R5; F2 (base point of L4.9) to R4; F3, F5, F12
(numerator forms, admissible sizes) to R5; F6, F7 (tightness, no Skorokhod) to R6;
F8 (citation in T1.3(ii)) to R1; F11 (cutoff at $n=0$) to R8; F13 (null marks)
and F15 (notation) are formal conventions with no manuscript action. The F1 of
[INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md) is a different finding (the
statement of (S)).

**Manuscript findings** (details in
[MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md); these R-numbers
are recommendation numbers, not the remark IDs R3.2 and R7.2):

- R1: citation correction in the proof of T1.3(ii).
- R2: compatible bridge endpoints in the periodic case.
- R3: nonempty index set in L6.1.
- R4: a genuine gap in the periodic case of L4.9 ($h_n(0)$ conditions on a null
  event unless $d\mid M_n$); repaired in Lean, conclusion unchanged.
- R5: ratios of $\Psi$ at incompatible points (L3.5(ii), L3.6, L5.1(iii), C4.3).
- R6: marginal tightness and a deterministic bound replace $J_1$ and Skorokhod.
- R7: the conditioning step in L4.7.
- R8: the cutoff at $n=0$; Kemperman's formula for forests is proved.

None of these changes the conclusion of an Introduction theorem. No TeX edit was
made.

## 5. Verification evidence

The post-audit integration on 30 October 2026 is checked in the pinned Lean/mathlib
4.35.0 environment. Commands and complete outputs are under `verification/`:

- `lake build`: [build.log](verification/build.log), 3,464 jobs, exit 0, no warnings.
  Every maintained module is imported by the root.
- `lake build Challenge Solution`: [challenge-build.log](verification/challenge-build.log),
  exit 0. The four deliberate isolated Challenge holes produce the expected warnings.
- `lake env lean verification/AxiomAudit.lean`: [axiom-audit.log](verification/axiom-audit.log),
  **1,986 declarations, zero offenders**, exit 0. This checks the transitive axiom
  closure of every project declaration. The checker now fails
  on any forbidden axiom or an empty audit; it no longer merely logs violations.
- The [negative control](verification/axiom-audit-negative-control.log) deliberately
  removes the allowed axioms for one existing theorem in a temporary copy of the
  checker: **one offender detected, Lean exit 1, negative control PASS**.
  It adds no axioms or proof holes to the development.
- `lake env lean verification/Axioms.lean`: [axioms.log](verification/axioms.log),
  exact headline types and representative new exports, including the completed
  obligations, maximal tightness and actual truncated-moment bounds.
- `lake env lean verification/StatementClosure.lean`:
  [statement-closure.log](verification/statement-closure.log), the current local semantic comparison; its exact counts and result are in that log. This is **not** Comparator or independent kernel replay.
- Standalone proof-export replay: [nanoda.log](verification/nanoda.log), **56,903 declarations,
  zero type-checker errors, exit 0**; [leanchecker.log](verification/leanchecker.log),
  **Lean kernel accepts the same export, exit 0**. NanoDa logs one nonfatal pretty-printer
  diagnostic. This is not sandboxed Comparator or full Palomar verification.
- [content-checks.log](verification/content-checks.log): 112 Lean files, all with
  module headers, largest 1,234 lines; 107 library modules, all root-reachable;
  no maintained proof holes, custom axioms or native-evaluation methods. The only
  proof holes are the four deliberate isolated Challenge declarations.
- `bash verification/check-challenge-defs.sh` confirms shared statement definitions
  remain identical. The Ubuntu CI invocation now uses Bash, as the script requires.
- [source-sha256.txt](verification/source-sha256.txt) identifies this candidate;
  `sh verification/make-hashes.sh` regenerates it after all source changes.

The earlier [clean-build.log](verification/clean-build.log) is **historical**:
its clean project build covered the preceding source snapshot with Lean-and-config
hash `8f57c4051e8a62c1ccaa0a91f284f09e06ce41459d91a36ffb68551ad7153905`.
It does not certify a clean rebuild of the changed tree. Current evidence above
is an incremental local build with preserved pinned dependency artifacts.

**GitHub CI:** [run 41101096161](https://github.com/igor-kortchemski/rare-subtree-patterns/actions/runs/41101096161)
passed for `81fbaf90a44aa3f8ae7807306288990dde3756ba`, including a fresh Ubuntu project
checkout/build with Mathlib cache, shared definitions, Challenge/Solution and the whole-library
axiom audit. The public documentation revision preserves that proof/configuration snapshot.
The first full Palomar run failed during preparation because private source could not be fetched;
no proof checks ran. At this documentation freeze, sandboxed Comparator and a passing full
Palomar report remain pending fresh public-candidate checks. Exact evidence and workflow links
are in [verification/README.md](verification/README.md). Whole-paper completion is not claimed.

## 6. Module map and remaining obligations

### Module map

| Directory | Content |
| --- | --- |
| `PlaneTree/`, `Bienayme/` | Finite plane trees, patterns, Bienaymé law, normalization, branching, conditioned laws, admissible sizes |
| `Lukasiewicz/`, `Cyclic/` | DFS coding, cycle lemma, `eq:fringe`, `eq:shifts`, Definition 2.1, Lemma 2.2, Corollary 2.3, Markov decompositions |
| `Probability/`, `ChenStein/` | Paper-normalized total variation, Poisson TV facts, Stein solution, Proposition 4.1 |
| `RegularVariation/`, `Stable/`, `Setup/` | `(H_α)`, marks and assumptions, toolkit interface, its derivation (limit law, density, lattice local limit theorem, regular variation) |
| `Bridge/` | Sections 3–5: criteria for (M) and (S), forest estimates, consequences of (S), bridge removal, truncation, Chen–Stein error terms, endpoint smoothing, boundary cases, assembly of T1.1–T1.2 |
| `Declumping/`, `RootDeclumping/` | Lemma 5.2, parent formula, Lemma 5.1, leaf-height declumping, generations and skeletons |
| `Patterns/`, `Applications/`, `ExtremesAnalysis/` | Non-fringe patterns, cut-and-graft, (S) and (C) for complete $r$-ary and leaf-height marks, level asymptotics |
| `Extremes/`, `DirectApplications/` | Lemma 5.4, T1.3, T1.4, first-order corollaries, Section 3 applications, Corollary 5.3, U12 |
| `Statements/`, `MainTheorems.lean`, `Examples/` | Reviewed statements, the four theorems, two non-vacuity witnesses for `(H_α)`: `Examples/SimpleWalk.lean` (periodic, $\mu_1=0$) and `Examples/BinomialWalk.lean` (aperiodic, $\mu_1=1/2$, lattice span $1$, $\alpha=2$) |
| `MainConsequences.lean` | Unconditional forms `Main.*` of C3.1, R3.2, C3.8, P3.9, C5.3, U01, U03; L6.2(iii) and L7.3(ii) (`Applications.lem_S_rary_iii`, `Applications.lem_S_lh_ii`) |
| project root: `Challenge.lean`, `Solution.lean` | Comparator Challenge (the four statements, Mathlib imports only) and Solution (re-exports the library); separate `lean_lib` targets, not default targets |

### Re-reviews and the extent of independent review

1. The three items changed after the first statement review (`StructuralMicroscopic` /
   `PoissonApproximation2Statement` after finding F1; the foldr form of `PlaneTree.rootLeafHeight`;
   `IsCutoff.pos` for `n ≥ 1`) were **re-reviewed** by the final independent review of the four theorems
   ([INDEPENDENT_REVIEW.md](INDEPENDENT_REVIEW.md)): PASS-WITH-FINDINGS, no blocking finding.
2. The statements cited for the numbered results of Sections 2–7 and the unnumbered obligations were
   checked against the source by an independent coverage review (INDEPENDENT_REVIEW.md); its corrections
   are incorporated here. No independent reviewer read the *proofs* of `Cyclic/`, `Bridge/`,
   `RegularVariation/`, `RootDeclumping/`, `Patterns/`, `Applications/`, `ExtremesAnalysis/`,
   `Extremes/Max*` or `DirectApplications/`; the kernel checks them, and the four theorems' statements,
   the stable toolbox derivation (statements and route), the Bienaymé law, the Łukasiewicz coding,
   Chen–Stein and the leaf-height asymptotics were reviewed as listed there.
3. The Challenge was reviewed as a standalone document (PASS-WITH-FINDINGS; docstring-level notes
   addressed).

### Whole-source omission scan (performed for this report)

- **Theorem-like environments.** The source declares `theorem`, `lemma`,
  `proposition`, `corollary`, `remark`, `definition` (lines 53–58) and contains
  38 such environments, none commented out: 4 theorems, 21 lemmas,
  4 propositions, 6 corollaries, 1 definition, 2 remarks. This matches the
  inventory's 35 results, 1 definition and 2 remarks, label by label (the
  remark at line 3007 is unlabelled; it is R7.2). The three framed boxes at
  lines 214, 238 and 291 are Assumptions (M), (S), (C), inventory rows D-M, D-S,
  D-C.
- **Unnumbered claims.** Outside proofs and theorem environments, the source was
  searched for "one can show", "it is easy", "easily", "we have", "clearly",
  "it follows", "implies", "is equivalent", "well known", "standard",
  "in particular", "observe", "note that", "recall", "equivalently", citations
  and similar phrases. Every mathematical assertion found is covered by an
  inventory row: lines 227 and 359–364 (U01), 266–267 (L3.4), 371–379 and
  1424–1430 (U02), 574–581 (U03), 691 (B02), 712 (B06), 724 (B03), 846–850
  (B06, B07), 860 (aperiodic eventual admissibility, part of B09; proved by
  `StableToolkit.eventually_walkProb_neg_one_pos_iff`), 2467–2476 (U07),
  2501–2502 (U08), 3021 (R7.2), 3441–3496 (Q01–Q04, U12, U13). Figure captions
  at lines 2793–2801 and 3236–3251 illustrate the proofs of L6.3 and L7.5.
- **Not in the inventory, found by the scan.** Only bibliographic statements:
  lines 340–346 (the corollaries recover results of CD17 and BHJ26), 582–586
  (earlier first-order results of DGZ23, HSW24), 653–662 (history of
  Chen–Stein arguments), 1424–1430 (scope of CD17 Theorem 1.6), 3024 (in R7.2,
  the estimates extend DGZ23 Lemma 9) and 3391–3405 (related work on protection
  numbers and leaf-height counts: DJ14, Jan16, GGLS23, BP17, MS26). These are
  attributions, not mathematical obligations, and are not formalized. No
  mathematical claim missing from the inventory was found.

### Other remaining items

- The 'Caveats' of the final review that are not defects but must stay disclosed: all limits run along
  admissible sizes with the actual `n`; several Lean hypotheses are slightly weaker than the paper's
  (eventual boundedness of $n\pi_n$, eventual interior phase, nondecreasing instead of strictly increasing
  $a$, free $M_0$), so the theorems are slightly stronger. `(H_α)` now uses normalized weak
  convergence directly; the redundant truncated-moment clause has been removed, and its general
  equivalence is not a prerequisite of the selected results. `maxCompleteHeight 0` is a junk
  value that no statement uses.
- [HANDOVER_CLAUDE.md](HANDOVER_CLAUDE.md) is marked as superseded and kept for history; module docstrings
  cite the correction labels F1–F15 of [docs/BRIDGE_PLAN.md](docs/BRIDGE_PLAN.md) (summarized as R1–R9 in
  [MANUSCRIPT_RECOMMENDATIONS.md](MANUSCRIPT_RECOMMENDATIONS.md); not to be confused with finding F1 of the
  statement review).

### Publication status

The mathematically reviewed publication candidate selects the four Introduction theorems for Palomar.
All library modules build; the current axiom audit covers 1,986 declarations with zero forbidden
dependencies. The local semantic comparison passes for 25,899 constants (71 project constants).
The exact selected proof export passes both independent NanoDa replay (56,903 declarations,
zero type-checker errors) and Lean's kernel replay; NanoDa logs a nonfatal pretty-printer
message described in `verification/README.md`.

Apache-2.0, Igor Kortchemski as formalization author and responsible maintainer, and the new
repository name `igor-kortchemski/rare-subtree-patterns` were explicitly confirmed by the user.
Canonical metadata, citation, license and a pinned manual full-preflight workflow are prepared.
The default Comparator was attempted and cannot start on macOS because it requires Linux
namespaces. No sandbox was disabled.

The repository has been created and the proof candidate pushed; its Ubuntu CI is successful.
Public visibility and fresh checks of the documentation revision are authorized. The initial
full Palomar run failed at private-source fetching, before Comparator or kernel verification.
The first public-source run then stopped at license detection; the root Apache-2.0
license text has been normalized without changing the license choice or proofs.
At this documentation freeze, a passing full report remains pending. Original B06/B07
obligations remain explicitly open. No registry intake, submission or registration has
occurred. See [PUBLICATION.md](PUBLICATION.md) for exact commits, runs and the certification scope.
