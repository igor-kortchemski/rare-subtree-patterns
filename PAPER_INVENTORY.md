# Paper inventory and initial source audit

## Scope and audit identity

This inventory covers the complete local source
`poisson-declumping-arxiv.tex`, arXiv:2607.22291v1, read in full on
30 October 2026. Source SHA-256:
`3b75c02ec5e8a7e12d32cccddfe463ae79ca596d1b8b239bc0352110b6472595`.
Line references below refer to this 3,504-line source, not a later arXiv version.

The initial audit was performed independently of the Lean implementation by
the `paper_inventory` reviewer, using `lean-statement-audit`. The source has
**35 theorem-like results: 4 theorems, 21 lemmas, 6 corollaries, and 4
propositions**. It also has **one numbered definition and two numbered remarks**.
The environment count was checked against a scan of every source line. The
Introduction contains all four main theorems.

Every numbered result is listed below. Additional tables retain mathematical
definitions, cited prerequisites, unnumbered consequences, and substantive
proof steps that must not disappear behind an assumed interface. Related
calculations within one proof are grouped into a single obligation rather
than counted as separate paper results. The final section's four expected
distributional limits are explicitly conjectural, not proved paper results.

**Status at this initial inventory: Pending for every mathematical obligation.**
This is a source-coverage audit, not a claim that the paper's proofs have been
fully checked or that any Lean declaration passes statement review. Later
implementation status belongs in `FORMALIZATION_REPORT.md`; keep these IDs
stable when linking proofs, refinements, and unresolved obligations.

## Implementation status overlay (30 October 2026)

This overlay records the implementation status of every stable ID below. It
supersedes the `Pending` entries of the audit-baseline tables, which are left
unchanged. Notes on generalizations, hypotheses and proof routes are in
[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md), Section 3. Names are
relative to the namespace `PoissonDeclumping`; the module is given in
parentheses. "From `h1`/`h2`/`h`" means the theorem takes the proved
T1.1/T1.2/T1.4 statement as a hypothesis; the `Main.*` names are the
unconditional forms in `MainConsequences` (from the conditional lemma and the
proved main theorem). "Toolkit" means it is stated under `StableToolkit`,
derived from `(H_α)` by `Stable.stableToolkit`.

Status values: **Proved**, **Proved (route differs)**, **Proved (corrected
statement, R…)** (periodic-case correction of the statement, see the report's
Section 4), **Helper/partial**, **Bypassed**, **Not formalized (disclosed)**,
**Conjecture (not claimed)**; **Defined** for the three assumption definitions.

| ID | Status | Lean declaration(s) (module) |
| --- | --- | --- |
| T1.1 | Proved | `poissonApproximation : PoissonApproximationStatement` (`MainTheorems`) |
| T1.2 | Proved; statement re-reviewed after F1 (final review: PASS-WITH-FINDINGS) | `poissonApproximation2 : PoissonApproximation2Statement` (`MainTheorems`) |
| T1.3 | Proved (route differs) | `maxString : MaxStringStatement` (`MainTheorems`); `Extremes.maxString_of` (`Extremes/MaxString`) |
| T1.4 | Proved (route differs) | `maxLeafHeight : MaxLeafHeightStatement` (`MainTheorems`); `MaxLeafHeight.maxLeafHeight_of` (`Extremes/MaxLeafHeight`) |
| D-M | Defined | `Microscopic` (`Setup/Marks`) |
| D-S | Defined; re-reviewed after F1 (final review) | `StructuralMicroscopic`, `Skeleton` (`Setup/Marks`) |
| D-C | Defined | `pairProb`, `NonClustering` (`Setup/Marks`) |
| D2.1 | Proved | `Cyclic.firstIndicator`, `Cyclic.cyclicSum`, `Cyclic.firstIndicator_take`, `Cyclic.cyclicSum_mono`, `Cyclic.cyclicSum_dfsSeq` (`Cyclic/Indicators`) |
| L2.2 | Proved | `Cyclic.map_cyclicSum_conditioned`, `Cyclic.markedCountLaw_eq` (`Cyclic/RandomWalk`) |
| C2.3 | Proved | `Cyclic.uniformFringeLaw_real_eq` (`Cyclic/UniformVertex`) |
| C3.1 | Proved | `Main.poisson_fringe`, unconditional (`MainConsequences`); `DirectApplications.poisson_fringe_of`, from `h1` (`DirectApplications/FringeCorollary`) |
| R3.2 | Proved; bibliographic comparisons not formalized | `Main.poisson_fringe_prescribed_tree`, `Main.poisson_fringe_size`, `Main.poisson_fringe_degreeStatistic`, unconditional (`MainConsequences`); `DirectApplications.poisson_fringe_prescribed_tree`, `poisson_fringe_size`, `poisson_fringe_degreeStatistic`, from `h1` (`FringeCorollary`) |
| L3.3 | Proved | `Bridge.microscopic_of_tail_of_eventually_pos`, `Bridge.microscopic_of_tail`, toolkit (`Bridge/CriterionM`) |
| L3.4 | Proved | `Bridge.critM`, toolkit (`Bridge/CriterionS`) |
| L3.5 | Proved | `Bridge.forest_tail_le`, `Bridge.forest_weighted_tail_div_le`, `Bridge.forest_weighted_tail_sup_le`, toolkit (`Bridge/ForestEstimates`) |
| L3.6 | Proved (route differs) | `Bridge.consequenceM_tail`, `Bridge.consequenceM_weighted_div`, toolkit (`Bridge/Microscopic`) |
| C3.7 | Proved | `Bridge.microscopic_of_structural`, `Bridge.integral_markCount_isEquivalent`, `Bridge.conditioned_mark_tendsto_zero`, toolkit (`Bridge/Microscopic`) |
| C3.8 | Proved | `Main.nonfringe_poisson`, unconditional (`MainConsequences`); `DirectApplications.nonfringe_poisson_of`, from `h1` (`DirectApplications/NonFringe`) |
| P3.9 | Proved | `Main.large_outdegree`, unconditional (`MainConsequences`); `DirectApplications.large_outdegree_of`, from `h1` (`DirectApplications/Outdegree`) |
| P4.1 | Proved (route differs) | `ChenStein.prop_AGG` (`ChenStein/AGG`) |
| L4.2 | Proved (corrected statement, R2: compatible endpoints only) | `Bridge.exists_cond_take_le`, toolkit (`Bridge/BridgeRemoval`) |
| C4.3 | Proved | `Bridge.exists_qProb_le_mul_markProb`, toolkit, admissible `n`, only `M=o(n)` (`Bridge/BridgeRemoval`) |
| L4.4 | Proved | `Bridge.tendsto_paperTVDist_cyclicSum_truncated`, `Bridge.tendsto_mul_qProb_sub_mul_markProb`, `Bridge.tendsto_paperTVDist_poisson_qProb_markProb` (`Bridge/Truncation`) |
| L4.5 | Proved (route differs) | `Bridge.isLittleO_walkVecLaw_firstMarked_abs_sum_gt_admissible`, `Bridge.isEquivalent_pProb_qProb_markProb`, toolkit (`Bridge/Truncation`) |
| P4.6 | Proved | `Bridge.tendsto_errorB1`, toolkit (`Bridge/ErrorTerms`) |
| L4.7 | Proved | `Bridge.tendsto_errorB2`, toolkit (`Bridge/ErrorTerms`) |
| P4.8 | Proved (route differs) | `Bridge.tendsto_errorB3`, `Bridge.eventually_errorB3_le`, toolkit (`Bridge/EndpointSmoothing`) |
| L4.9 | Proved (corrected statement, R4; route differs) | `Bridge.tendsto_lem1`, toolkit (`Bridge/EndpointSmoothing`) |
| L4.10 | Proved | `Bridge.tendsto_bridgeLaw_one_le_cyclicSum`, `Bridge.tendsto_bridgeLaw_abs_cyclicSum_div_sub_one` (`Bridge/ExtremeMeans`) |
| L5.1 | Proved; (iii) route differs | `RootDeclumping.lem_root_declumping` (`RootDeclumping/Lemma51`), `Bridge.microscopic_declumped`, toolkit (`Bridge/RootMicroscopic`) |
| L5.2 | Proved | `PlaneTree.declump_to_raw` (`Declumping/Probability`), `PlaneTree.conditioned_declump_to_raw` (`Declumping/Conditioned`) |
| C5.3 | Proved | `Main.declump_zero`, unconditional (`MainConsequences`); `DirectApplications.declump_zero_of`, from `h2` (`DirectApplications/DeclumpZero`) |
| L5.4 | Proved | `tendsto_zero_of_tendsto_lintegral_zero`, `tendsto_one_of_witness` (`Extremes/Ineqs`) |
| L6.1 | Proved | `PlaneTree.lem_cut_graft`, `PlaneTree.lem_cut_graft_real` (`Patterns/CutGraftBound`) |
| L6.2 | Proved (i)–(iii); (ii) (summed pair bound) route differs: P19 by cut-and-graft | `Applications.lem_S_rary_i`, `Applications.lem_S_rary_ii`, `Applications.lem_S_rary` (`Applications/CompleteArySC`); `Applications.lem_S_rary_iii` (`MainConsequences`) |
| L6.3 | Proved | `Applications.lem_C_rary` (`Applications/CompleteArySC`) |
| L7.1 | Proved; (ii) route differs | `LeafHeight.lem_ell_asymp_i_tree`, `LeafHeight.lem_ell_asymp_ii_tree` (`LeafHeight/Tree`) |
| R7.2 | Proved | `LeafHeight.ellSeq_isEquivalent_of_pos`, `LeafHeight.ellSeq_isEquivalent_of_zero`, `LeafHeight.tendsto_piSeq_succ_div` (`LeafHeight/Consequences`) |
| L7.3 | Proved (i), (ii) | `Applications.lem_S_lh`, toolkit (`Applications/LeafHeightSC`); `Applications.lem_S_lh_ii` (`MainConsequences`) |
| L7.4 | Proved | `RootDeclumping.lem_lh_conditional_mark` (`RootDeclumping/LeafHeightMark`) |
| L7.5 | Proved (route differs) | `Applications.lem_C_lh`, `Applications.pair_lhDeclumped_le` (`Applications/LeafHeightSC`) |
| B01 | Proved | `PlaneTree.bienayme_apply_singleton`, `PlaneTree.bienayme_children_eq` (`Bienayme/Basic`), `PlaneTree.bienayme_isProbabilityMeasure` (`Bienayme/Normalization`) |
| B02 | Proved | `PlaneTree.mem_range_dfsSeq_iff`, `PlaneTree.ofSeq_rotate_dfsSeq` (`Lukasiewicz/Coding`) |
| B03 | Proved | `PlaneTree.map_dfsSeq_conditioned`, `PlaneTree.map_shift_conditioned` (`Lukasiewicz/BridgeLaw`) |
| B04 | Proved | `Cyclic.cyclicSum_rotate` (`Cyclic/Indicators`), `Cyclic.bridgeLaw_shiftIndicator_eq_one` (`Cyclic/RandomWalk`) |
| B05 | Proved | `Cyclic.walkVecLaw_zeta_eq_inter`, `Cyclic.walkVecLaw_firstIndicator_eq` (`Cyclic/Markov`) |
| B06 | Helper/partial | `Stable.regularlyVaryingSeq`, `slowlyVarying`; finite-variance converse `stableDomain_of_finiteVariance`; conditional CF-to-limit bridge (`Stable/DomainCharacterization`). General equivalence remains open. |
| B07 | Helper/partial | `Stable.maximal_tight`, `tendsto_maximal_tail` (`Stable/MaximalTightness`): actual path maximum; full functional $J_1$ limit remains open |
| B08 | Required specialization proved; general theorem cited background | `RegularlyVaryingSeq.potter_floor_slowlyVarying` (`RegularVariation/Functions`): all real arguments for the actual normalizing slow factor; agreed Potter scope |
| B09 | Proved (route differs) | `Stable.localLimit`, `localLimit_aperiodic`, `latticeLocal`, `exists_norming_isEquivalent_sqrt`, `alpha_eq_two_of_finiteVariance` |
| B10 | Proved | `StableToolkit.exists_lower_bound_neg_one`, `StableToolkit.eventually_abs_div_sub_one_le` (`Setup/Toolkit`), `Stable.exists_walkProb_le` (`Stable/ToolkitProof`) |
| B11 | Proved | `Bridge.natCast_mul_forestSizeWeight` (`Bridge/Kemperman`), `Bridge.tree_size_asymp` (`Bridge/ForestEstimates`) |
| B12 | Proved | `RegularlyVaryingSeq.karamata_tail`, `RegularlyVaryingSeq.karamata_sum` (`RegularVariation/Karamata`) |
| B13 | Proved (route differs) | `PlaneTree.bienayme_isProbabilityMeasure` (`Bienayme/Normalization`) |
| B14 | Proved for the real-valued application | `RealCoupling.exists_measurable_real_coupling`; `Stable.exists_timeScaled_coupling` (`Probability/Skorokhod`, `Stable/CDF`). Main proof route still bypasses it. |
| B15 | Proved | `paperTVDist_map_le_measureReal_ne`, `paperTVDist_poissonMeasure_le_abs_sub`, `abs_measureReal_zero_sub_exp_le_paperTVDist` (`Probability/PoissonTV`), `paperTVDist_le_iff` (`Probability/TotalVariation`) |
| U01 | Proved | `DirectApplications.integral_markCount_eq_mul_uniformFringeLaw`, `DirectApplications.nonClustering_of_iSup_pairProb`, `DirectApplications.hypotheses_of_convenient_criterion`, `DirectApplications.poisson_of_convenient_criterion`, from `h1` (`DirectApplications/Criteria`); `Main.poisson_of_convenient_criterion`, unconditional (`MainConsequences`) |
| U02 | Proved (route differs) | `DirectApplications.unary_raw_zero_tendsto`, `unary_raw_eventually_tv_pos`, `unary_raw_not_tendsto_poisson_mean`, `unary_counterexample_exists` (`DirectApplications/UnaryClustering`) |
| U03 | Proved | `MaxLeafHeightStatement` constants; `Main.leafHeight_div_log_tendsto`, `Main.leafHeight_div_logb_log_tendsto`, unconditional (`MainConsequences`); `MaxLeafHeight.leafHeight_div_log_tendsto`, `MaxLeafHeight.leafHeight_div_logb_log_tendsto`, from `h` (`Extremes/MaxLeafHeightFirstOrder`) |
| U04 | Proved | `PlaneTree.le_leafHeight_iff_markCount_pos` (`LeafHeight/Tree`), `PlaneTree.le_maxCompleteHeight_iff_markCount_pos` (`Patterns/Complete`), `PlaneTree.declumped_count_pos_imp_raw_count_pos` (`Declumping/Deterministic`) |
| U05 | Proved | `PlaneTree.not_forced_size_nested` (`Cyclic/Indicators`), `Cyclic.pairProb_eq_zero_of_forces_size` (`Cyclic/UniformVertex`) |
| U06 | Proved | `PlaneTree.bienayme_embeds_eq`, `PlaneTree.cond_embeds_leafTrees_pi`, `PlaneTree.skeleton_embeds` (`Patterns/NonFringe`) |
| U07 | Proved | `PlaneTree.internalCount_completeTree_of_two_le`, `PlaneTree.bienayme_embeds_completeTree_one`, `PlaneTree.bienayme_embeds_completeTree_of_two_le` (`Patterns/Complete`) |
| U08 | Proved | `PlaneTree.cut_graft`, `PlaneTree.graft_cut`, `PlaneTree.graft_inj`, `PlaneTree.cutEquiv` (`Patterns/CutGraft`) |
| U09 | Proved | `LeafHeight.support_subset_of_cConst_eq_zero`, `LeafHeight.leafD_of_cConst_eq_zero` (`LeafHeight/Consequences`), `PlaneTree.leafHeight_eq_maxCompleteHeight` (`Patterns/Complete`) |
| U10 | Proved | `LeafHeight.bienayme_real_le_rootLeafHeight` (`LeafHeight/Tree`), `LeafHeight.strictAnti_piSeq`, `LeafHeight.tendsto_piSeq_zero` (`LeafHeight/Recursion`) |
| U11 | Proved | `RootDeclumping.lh_declumped_prob_eq`, `RootDeclumping.lh_declumped_isEquivalent` (`RootDeclumping/LeafHeightMark`) |
| U12 | Proved (mean calculation only) | `DirectApplications.compoundPoisson_leafHeight_mean`, `DirectApplications.mean_isEquivalent_leafHeight` (`DirectApplications/CompoundPoisson`) |
| U13 | Proved | `LeafHeight.tendsto_natCast_mul_piSeq_succ` (`LeafHeight/Consequences`) |
| P01 | Proved | `Cyclic.walkVecLaw_bridge_inter_ofSeq` (`Cyclic/UniformVertex`) |
| P02 | Proved | `Bridge.eventually_abs_uniformFringeLaw_real_sub_le`, `Bridge.exists_uniformFringeLaw_real_le_mul` (`Bridge/CriterionM`) |
| P03 | Proved | `Bridge.forest_weighted_tail_sup_le` (`Bridge/ForestEstimates`) |
| P04 | Proved (route differs) | `Bridge.consequenceM_weighted` (`Bridge/Microscopic`) |
| P05 | Proved | `Bridge.conditioned_mark_tendsto_zero` (`Bridge/Microscopic`) |
| P06 | Proved | `DirectApplications.structuralMicroscopic_embeds` (`DirectApplications/NonFringe`) |
| P07 | Proved | `DirectApplications.embeds_star_iff`, `DirectApplications.bienayme_degSeq_pair_le` (`DirectApplications/Outdegree`) |
| P08 | Proved | `Bridge.exists_cond_take_le` (`Bridge/BridgeRemoval`) |
| P09 | Proved | `Bridge.integral_cyclicSum_sub_truncated`, `Bridge.paperTVDist_cyclicSum_truncated_le` (`Bridge/Truncation0`) |
| P10 | Proved (route differs) | `Bridge.walkVecLaw_firstMarked_abs_sum_gt_le` (`Bridge/Truncation0`) |
| P11 | Proved | `Bridge.walkVecLaw_real_pair_le_markProb` (`Bridge/PairBound`) |
| P12 | Proved (route differs) | `Bridge.eventually_abs_endpointMean_sub_le` (`Bridge/EndpointSmoothing`) |
| P13 | Proved | `Bridge.eventually_pairBridge_le`, `Bridge.sum_sum_cycEvent_inter_le` (`Bridge/ExtremeMeans`) |
| P14 | Proved | `Bridge.poissonApproximation_divergent` (`Bridge/MainTheorems`) |
| P15 | Proved | `RootDeclumping.parent_formula`, `RootDeclumping.pointwise_bounds`, `RootDeclumping.tendsto_parentFun_div` (`RootDeclumping/ParentFormula`) |
| P16 | Proved (route differs) | `Bridge.lintegral_declumped_le`, `Bridge.forest_bound_weighted` (`Bridge/RootMicroscopic`) |
| P17 | Proved | `PlaneTree.marked_root_of_no_declumped` (`Declumping/Deterministic`), `PlaneTree.zero_probability_sandwich` (`Declumping/Probability`) |
| P18 | Proved | `PlaneTree.MarkedTree.weight_graft`, `PlaneTree.bienayme_cut_mem` (`Patterns/CutGraft`), `PlaneTree.cut_graft_bound_aux` (`Patterns/CutGraftBound`) |
| P19 | Proved (route differs) | `Applications.pairSum_completeTree_le` (`Applications/CompleteArySC`), `PlaneTree.exists_replaceClass` (`Applications/TreeCompleteClass`) |
| P20 | Proved (route differs) | `Extremes.maxString_unary_of`, `Extremes.maxString_rary_of` (`Extremes/MaxString`), `ExtremesAnalysis.rary_twoPoint_thresholds` (`ExtremesAnalysis/Rary`) |
| P21 | Proved | `PlaneTree.embeds_completeTree_replaceAt` (`Applications/TreeCompleteClass`), `Applications.pair_declumped_completeTree_le` (`Applications/CompleteArySC`) |
| P22 | Proved (route differs) | `LeafHeight.lem_ell_asymp_i`, `LeafHeight.lem_ell_asymp_ii` (`LeafHeight/Asymptotics`) |
| P23 | Proved (route differs) | `RootDeclumping.tiltMean_le`, `RootDeclumping.lintegral_skelSize_add_genCount_cond_le` (`RootDeclumping/LeafHeightGenerations`), `RootDeclumping.lhSkeleton_skeleton` (`RootDeclumping/LeafHeightSkeleton`) |
| P24 | Proved (route differs) | `MaxLeafHeight.maxLeafHeight_unary`, `MaxLeafHeight.maxLeafHeight_superexp_of_cConst_pos`, `MaxLeafHeight.maxLeafHeight_of_cConst_eq_zero` (`Extremes/MaxLeafHeight`) |
| P25 | Proved (route differs) | `Applications.pair_lhDeclumped_le` (`Applications/LeafHeightSC`) |
| Q01–Q04 | Conjecture (not claimed) | none (U12, U13 are the separately proved calculations) |
| Q05 | Conjecture (not claimed) | none |

## Common semantics that every target must preserve

- A plane tree is finite, rooted, ordered, and nonempty. A leaf is a vertex
  with zero children; root and maximal leaf-height are distinct quantities.
- The offspring law is a probability law on natural numbers, is critical,
  and satisfies $\mu_1\ne1$. The standing stable-domain assumption uses
  $\alpha\in(1,2]$. The finite-variance case alone does not cover the paper.
- Conditioning on size $n$ is used only when
  $\mathbb P(|\mathcal T|=n)>0$. Limits for general offspring laws run along
  these admissible sizes, including periodic laws.
- A uniform vertex should be implemented as an independent uniform DFS index
  followed by selection of the vertex of the sampled tree. The selected
  vertex itself is not literally independent of its containing tree.
- Marks are arbitrary functions $G_k$ on finite plane trees with values in
  $\{0,1\}$. Preserve their dependence on $k_n$; do not replace them by one
  fixed mark, a fixed family of patterns, or a monotonicity assumption.
- A cutoff consists of positive integers $M_n\to\infty$ with $M_n=o(n)$.
  The same cutoff must be used by the assumptions combined in a theorem.
- Write $\pi_n=\mathbb P(G_{k_n}(\mathcal T)=1)$ and
  $N_n=\sum_{v\in\mathcal T^n}G_{k_n}(\mathcal T^n_v)$.
  Conditional marked laws are used along subsequences where their denominator
  is positive. Zero marking probabilities need an explicit treatment.
- The stable normalization is not arbitrary: $S_n/a_n$ tends to the law with
  Laplace transform $\mathbb E[e^{-\lambda Y_\alpha}]=e^{\lambda^\alpha}$.
  The density, local limits, regular variation, and forest estimates are
  mathematical obligations, not additional assumptions silently added to a
  claimed proof of an Introduction theorem.
- Total variation compares laws on natural numbers. Fix and document the
  normalization consistently with the Chen–Stein bound and zero-event bound.

The three principal assumptions are separate interfaces:

| ID | Source | Required content | Status |
| --- | --- | --- | --- |
| D-M | [215–225](poisson-declumping-arxiv.tex#L215-L225), `hyp:M` | The marked probability at a uniform vertex of the conditioned tree is asymptotic to $\pi_n$; conditional on being marked, that fringe tree exceeds $M_n$ with probability $o(1)$. | Pending |
| D-S | [239–257](poisson-declumping-arxiv.tex#L239-L257), `hyp:S` | Under the marked conditional law, $\lvert \mathcal T\rvert =C_k+\sum_{i=1}^{L_k}\lvert \mathcal T^{(i)}\rvert $, where $C_k,L_k$ are nonnegative integer-valued and, conditional on them, the attached trees are independent with the original tree law. For every fixed $\varepsilon>0$, $a_n\mathbb P_{k_n}(C_{k_n}>\varepsilon M_n)\to0$ and $\mathbb E_{k_n}[L_{k_n}]/a_{M_n}\to0$. | Pending |
| D-C | [275–300](poisson-declumping-arxiv.tex#L275-L300), `hyp:C` | $A_n(\ell)$ is the probability of simultaneous marks at the root and the existing DFS vertex $\ell+1$ in one unconditioned tree; $\sum_{\ell=1}^{M_n}A_n(\ell)=o(n\pi_n^2)$. The existence condition on that vertex is essential. | Pending |

## Introduction targets

These are the publication-facing targets. Each numbered theorem in the table
below includes all its parts.

**T1.1, marked Poisson approximation and law of large numbers.** Under the
standing law assumptions and D-M/D-C, bounded $n\pi_n$ gives
$d_{\mathrm{TV}}(\mathcal L(N_n),\operatorname{Poisson}(n\pi_n))\to0$.
If $n\pi_n\to\infty$, then $N_n/(n\pi_n)\to1$ in probability and consequently
$N_n\to\infty$ in probability. The second conclusion is a normalized law of
large numbers, not just divergence.

**T1.2, root declumping.** For a fixed set $B\subseteq\mathbb N$, put
$c_B=\mathbb E[D\mathbf 1_{\{D\in B\}}]\in(0,\infty)$ and

$$
\widehat G_k(T)=\mathbf 1_{\{\deg_T(\varnothing)\in B\}}
\mathbf 1_{\{\exists u\text{ child of the root}:G_k(T_u)=1\}}.
$$

Assume D-S for the raw marks and D-C for the declumped marks using the same
cutoff. Bounded $n\pi_n$ gives total-variation approximation of the declumped
count by $\operatorname{Poisson}(c_Bn\pi_n)$. Divergent $n\pi_n$ gives
divergence in probability of the declumped count. Do not assume raw and
declumped counts or their zero events are deterministically identical.

**T1.3, maximal complete non-fringe $r$-ary height.** The relation
$T'\prec T$ allows grafting arbitrary trees at the leaves of $T'$, while
preserving the exact offspring number at its internal vertices. For
$H_r(T)=\max\{k:\exists v,\ H_{r,k}\prec T_v\}$:

- If $\mu_1>0$, set
  $t_n^*=(\log n+\log(1-\mu_1))/\log(1/\mu_1)$. For every fixed real $t$,
  $\mathbb P(H_1(\mathcal T^n)\le\lfloor t_n^*+t\rfloor)
  -\exp(-\mu_1^{t+1-\{t_n^*+t\}})\to0$.
- If $r\ge2$ and $\mu_r>0$, set
  $t_n^{**}=\log_r\log n-\log_r(\log(1/\mu_r)/(r-1))$,
  $m_n=\lfloor t_n^{**}\rfloor$, and $\theta_n=\{t_n^{**}\}$.
  With $J_n=\{m_n-1,m_n\}$ when $\theta_n\le1/2$, and
  $J_n=\{m_n,m_n+1\}$ otherwise, $\mathbb P(H_r(\mathcal T^n)\in J_n)\to1$.
  If $\liminf_n\min(\theta_n,1-\theta_n)>0$, the sharper conclusion is
  $\mathbb P(H_r(\mathcal T^n)=m_n)\to1$.

**T1.4, maximum leaf-height.** Let $\lambda_v(T)$ be the minimum distance
from $v$ to a descendant leaf and $\lambda(T)=\max_v\lambda_v(T)$.

- For $\mu_1>0$, a single constant $C_\mu>0$ works for every fixed real $t$.
  With $k_n^*=(\log n+\log((1-\mu_1)C_\mu))/\log(1/\mu_1)$, the formula
  for T1.3(i) holds with $H_1,t_n^*$ replaced by $\lambda,k_n^*$.
- For $\mu_1=0$, let $\kappa=\min\{j\ge2:\mu_j>0\}$. A constant
  $D_\mu\in(0,1)$ gives
  $k_n^{**}=\log_\kappa\log n-\log_\kappa\log(1/D_\mu)$.
  The same two-point and interior one-point assertions as T1.3(ii) hold for
  $\lambda$, using this centering and base $\kappa$.

Constants $C_\mu,D_\mu$ must be identified with the limits in U03 below.
Finitely many levels obtained by floors can be negative; state asymptotics
with integer thresholds or justify restricting to eventually positive levels.

## Every numbered theorem, proposition, lemma, and corollary

In the dependency column, a bare number refers to the result in this table;
`B`, `U`, and `P` identifiers refer to the later tables. Dependencies record
the paper's route, not an assertion that a listed prerequisite is sufficient
without elementary measure, combinatorial, or asymptotic lemmas.

| ID / TeX label | Statement lines; proof lines | Full obligation, including parts | Main dependencies | Status |
| --- | --- | --- | --- | --- |
| T1.1 `thm:PoissonApproximation` | [305–329](poisson-declumping-arxiv.tex#L305-L329); [2097–2143](poisson-declumping-arxiv.tex#L2097-L2143) | Both regimes of the general marked-tree theorem described above. | 2.2, 4.1, 4.4–4.10, P14 | Pending |
| T1.2 `thm:PoissonApproximation2` | [396–442](poisson-declumping-arxiv.tex#L396-L442); [2305–2330](poisson-declumping-arxiv.tex#L2305-L2330) | Both regimes of the declumped theorem described above, with constant $c_B$. | T1.1, 5.1, B15 | Pending |
| T1.3 `thm:max_string` | [475–501](poisson-declumping-arxiv.tex#L475-L501); [2808–2897](poisson-declumping-arxiv.tex#L2808-L2897) | Unary lattice-modulated limit; $r\ge2$ two-point localization and its interior one-point refinement. | T1.1, 3.7, 5.3–5.4, 6.2–6.3, U07, P20 | Pending |
| T1.4 `thm:max_lh` | [533–558](poisson-declumping-arxiv.tex#L533-L558); [3257–3387](poisson-declumping-arxiv.tex#L3257-L3387) | Leaf-height lattice-modulated limit; $\mu_1=0$ two-point and interior one-point localization, including the two-point-support offspring law. | T1.2–T1.3, 3.7, 5.3–5.4, 7.1, 7.3–7.5, U03, U09, P24 | Pending |
| L2.2 `lem:RW` | [760–764](poisson-declumping-arxiv.tex#L760-L764) | For any mark and cutoff, equality in law between the cyclic indicator sum for $\mathcal T^n$ and the sum for $n$ increments conditioned on $S_n=-1$. | B02–B04, D2.1 | Pending |
| C2.3 `cor:cyclicshift` | [777–791](poisson-declumping-arxiv.tex#L777-L791); [793–825](poisson-declumping-arxiv.tex#L793-L825) | Uniform-vertex marked probability equals $\mathbb E[\mathbf1_{\{G(\mathcal T)=1\}}\Psi_{n-\lvert \mathcal T\rvert }(0)]/\Psi_n(-1)$, with zero kernel for negative time. | B03–B05, P01 | Pending |
| C3.1 `cor:Poisson_fringe` | [924–958](poisson-declumping-arxiv.tex#L924-L958); [960–969](poisson-declumping-arxiv.tex#L960-L969) | If marks force size $k$, with $k_n\to\infty$, $k_n=o(n)$, obtain both T1.1 conclusions and divergence. | T1.1, 2.3, B10, U05 | Pending |
| L3.3 `lem:M` | [1015–1026](poisson-declumping-arxiv.tex#L1015-L1026); [1028–1049](poisson-declumping-arxiv.tex#L1028-L1049) | For eventually positive $\pi_n$, $a_n\mathbb P(\lvert \mathcal T\rvert >M_n\mid G_{k_n}=1)\to0$ implies D-M. This lemma is retained although unused later. | 2.3, B10, P02 | Pending |
| L3.4 `lem:critM` | [1055–1079](poisson-declumping-arxiv.tex#L1055-L1079); [1081–1109](poisson-declumping-arxiv.tex#L1081-L1109) | The exact conditional independent-forest decomposition plus $\mathbb E_{k_n}[C_{k_n}+L_{k_n}]=n^{o(1)}$ implies D-S for every fixed $\eta\in(0,1-1/\alpha)$ and $M_n=\lfloor n^{1-\eta}\rfloor$. | B06–B08, Markov inequality | Pending |
| L3.5 `lem:forest_estimates` | [1119–1134](poisson-declumping-arxiv.tex#L1119-L1134); [1136–1180](poisson-declumping-arxiv.tex#L1136-L1180) | One $C>0$, uniform in forest size $\ell\ge1$ and $1\le m\le n/2$, bounds both $\mathbb P(\lvert \mathcal G_\ell\rvert >m)$ and the supremum-endpoint bridge-weighted tail by $C\ell/a_m$. | B09–B12, P03 | Pending |
| L3.6 `lem:consequenceM` | [1182–1194](poisson-declumping-arxiv.tex#L1182-L1194); [1196–1251](poisson-declumping-arxiv.tex#L1196-L1251) | D-S implies both the conditional tail beyond $M_n/4$ and its weight $\sup_x\Psi_{n-\lvert \mathcal T\rvert }(x)/\Psi_n(-1)$ tend to zero. | 3.5, D-S, P04 | Pending |
| C3.7 `cor:SM` | [1256–1276](poisson-declumping-arxiv.tex#L1256-L1276); [1278–1365](poisson-declumping-arxiv.tex#L1278-L1365) | D-S implies (i) D-M, (ii) expected total mark count $\sim n\pi_n$, and (iii) root marking in $\mathcal T^n$ has probability $o(1)$ if $\pi_n=O(1/n)$. | 2.3, 3.6, B10–B12, P05 | Pending |
| C3.8 `cor:Non-fringe Poisson` | [1387–1422](poisson-declumping-arxiv.tex#L1387-L1422); [1433–1445](poisson-declumping-arxiv.tex#L1433-L1445) | For deterministic patterns of size $k$, internal count $C_k$, leaf count $L_k$, require $C_{k_n}=o(M_n)$, $L_{k_n}=o(a_{M_n})$, and the stated uniform two-mark bound; obtain Poisson approximation or normalized LLN. Aperiodicity is explicit here. | T1.1, 3.7, U01, P06 | Pending |
| P3.9 `prop:largeoutdegree` | [1458–1486](poisson-declumping-arxiv.tex#L1458-L1486); [1487–1538](poisson-declumping-arxiv.tex#L1487-L1538) | For positive degrees $d_n\to\infty$ with eventually $\mu_{d_n}>0$ and $d_n=o(a_{M_n})$, prescribed-degree count has bounded-mean Poisson approximation and limiting Poisson law when its mean tends to $\lambda\ge0$; divergent-mean normalized LLN. | T1.1, 3.7, P07, B15 | Pending |
| P4.1 `prop:AGG` | [1600–1614](poisson-declumping-arxiv.tex#L1600-L1614) | For arbitrary finite indicator family and neighborhoods containing their indices, there exists one bounded test function $\lVert f_n\rVert_\infty\le1$ giving $d_{\mathrm{TV}}\le2(b_1+b_2+b_3)$ with precisely the displayed conditional-test-function third term. Cited from the proof of AGG89, not proved in this source. | Stein/Poisson theory; verify exact cited bound | Pending |
| L4.2 `lem:error_est` | [1633–1638](poisson-declumping-arxiv.tex#L1633-L1638); [1640–1648](poisson-declumping-arxiv.tex#L1640-L1648) | For $m_n=o(n)$, $z_n=o(a_n)$, any indicator of the first $m_n$ increments, bound its bridge expectation uniformly over compatible $\lvert k\rvert \le z_n$ by $C$ times its unconditioned expectation, with $C$ independent of $n,H$. | B09–B10, P08; periodic restriction below | Pending |
| C4.3 `cor:pip` | [1651–1658](poisson-declumping-arxiv.tex#L1651-L1658) | Truncated marked probability under the bridge is at most $C\pi_n$ for $M_n=o(n)$; absorb admissible finite exceptions correctly. | 4.2, D2.1 | Pending |
| L4.4 `lem:truncate` | [1673–1688](poisson-declumping-arxiv.tex#L1673-L1688); [1691–1696](poisson-declumping-arxiv.tex#L1691-L1696) | Under D-M and bounded $n\pi_n$, (i) full/truncated sums approach each other in TV, (ii) $nq_n-n\pi_n\to0$ and corresponding Poisson laws approach in TV. | 2.2–2.3, D-M, B15, P09 | Pending |
| L4.5 `lem:pnqn` | [1732–1739](poisson-declumping-arxiv.tex#L1732-L1739); [1740–1788](poisson-declumping-arxiv.tex#L1740-L1788) | Under D-M, for $p_n=\mathbb P(I_1^{(M_n)}=1)$ and $r_n=\sqrt{a_{M_n}a_n}$: marked endpoint tail is $o(p_n)$ and $p_n\sim q_n\sim\pi_n$. | B06–B10, P10 | Pending |
| P4.6 `prop:b1` | [1797–1798](poisson-declumping-arxiv.tex#L1797-L1798); [1800–1807](poisson-declumping-arxiv.tex#L1800-L1807) | Under subsection standing assumptions and bounded $n\pi_n$, $b_1^n\to0$. | 4.3, $\#B_i^n\le2M_n$ | Pending |
| L4.7 `lem:boundb2` | [1815–1818](poisson-declumping-arxiv.tex#L1815-L1818); [1822–1857](poisson-declumping-arxiv.tex#L1822-L1857) | Under D-C and bounded $n\pi_n$, $b_2^n\to0$. | 4.2, P11 | Pending |
| P4.8 `prop:b3bis` | [1862–1864](poisson-declumping-arxiv.tex#L1862-L1864); [1880–1886](poisson-declumping-arxiv.tex#L1880-L1886) | Under subsection D-M and bounded $n\pi_n$, $b_3^n\to0$ for every $f_n$ bounded by one. | 4.9, conditional independence of two blocks | Pending |
| L4.9 `lem:1` | [1872–1876](poisson-declumping-arxiv.tex#L1872-L1876); [1891–1995](poisson-declumping-arxiv.tex#L1891-L1995) | With the stated conditional remainder expectation $h_n(k)$ and $\Delta_n(k)=h_n(k)-h_n(0)$, $n\mathbb E[(I_1^{(M_n)}-q_n)\Delta_n(S_{M_n})\mid S_n=-1]\to0$. | 4.2, 4.5, P12 | Pending |
| L4.10 `lem:extreme_means` | [2006–2014](poisson-declumping-arxiv.tex#L2006-L2014); [2016–2089](poisson-declumping-arxiv.tex#L2016-L2089) | Under D-M, vanishing mean gives truncated count $\to0$ in probability; under D-M/D-C, diverging mean gives normalized truncated count $\to1$ in probability. | 4.2, 4.5, 4.7's pair bound, P13 | Pending |
| L5.1 `lem:root_declumping` | [2197–2215](poisson-declumping-arxiv.tex#L2197-L2215); [2217–2299](poisson-declumping-arxiv.tex#L2217-L2299) | With $b_B=\mathbb P(D\in B,D\ge1)>0$, always $\widehat\pi_n\ge b_B\pi_n$; (i) bounded raw mean gives $n\widehat\pi_n-c_Bn\pi_n\to0$, (ii) divergent raw mean gives divergent declumped mean, (iii) raw D-S gives declumped D-M at the same cutoff. | 3.5–3.6, 2.3, P15–P16 | Pending |
| L5.2 `lem:declump_to_raw` | [2343–2357](poisson-declumping-arxiv.tex#L2343-L2357); [2360–2401](poisson-declumping-arxiv.tex#L2360-L2401) | If a marked child propagates to a parent of degree outside $B$, root-mark probability in $\mathcal T^n$ tends to zero, and declumped count is TV-close to $\operatorname{Poisson}(\lambda_n)$, raw zero probability minus $e^{-\lambda_n}$ tends to zero. | P17, TV control of singleton events | Pending |
| C5.3 `cor:declump_zero` | [2403–2414](poisson-declumping-arxiv.tex#L2403-L2414); [2416–2422](poisson-declumping-arxiv.tex#L2416-L2422) | Under T1.2, propagation, and $\pi_n=O(1/n)$, raw zero probability is $\exp(-c_Bn\pi_n)+o(1)$. | T1.2, 3.7(iii), 5.2 | Pending |
| L5.4 `lem:ineqs` | [2426–2437](poisson-declumping-arxiv.tex#L2426-L2437) | If $\{H_n\ge h\}=\{N_n(h)\ge1\}$ and $\{L_n(h)\ge1\}\subseteq\{H_n\ge h\}$, then vanishing expected raw count gives upper-tail probability $\to0$; divergent lower witness in probability gives it $\to1$. | Markov inequality and event inclusion | Pending |
| L6.1 `lem:cut_graft` | [2512–2546](poisson-declumping-arxiv.tex#L2512-L2546); [2557–2621](poisson-declumping-arxiv.tex#L2557-L2621) | Given finite positive-probability conditions $\mathcal Q_m$, a cut-tree family and selector satisfying preservation and double-event conditions (a)/(b), bound two nested $\mathcal E$ occurrences by $\mathbb P(\mathcal E)\max_m\mathbb P(\mathcal E\mid\mathcal Q_m)$. | B01, U08, P18; nonempty index clarification below | Pending |
| L6.2 `lem:S_rary` | [2644–2653](poisson-declumping-arxiv.tex#L2644-L2653); [2655–2757](poisson-declumping-arxiv.tex#L2655-L2757) | If complete-pattern skeleton plus leaf size is $n^{o(1)}$, polynomial cutoff gives (i) raw D-S, (ii) raw D-C when $n\pi_{k_n}\to\infty$, and (iii) expected raw count $\sim n\pi_{k_n}$. | 3.4, 3.7, U07, P19 | Pending |
| L6.3 `lem:C_rary` | [2762–2766](poisson-declumping-arxiv.tex#L2762-L2766); [2768–2792](poisson-declumping-arxiv.tex#L2768-L2792) | Declumped complete $r$-ary marks satisfy D-C for every level sequence and every cutoff. | 6.1, P21 | Pending |
| L7.1 `lem:ell_asymp` | [2937–2951](poisson-declumping-arxiv.tex#L2937-L2951); [2953–3005](poisson-declumping-arxiv.tex#L2953-L3005) | If $\mu_1>0$, $\pi_k\sim C_\mu\mu_1^k$ for $C_\mu>0$; if $\mu_1=0$, $\pi_k\sim\mu_\kappa^{-1/(\kappa-1)}D_\mu^{\kappa^k}$ for $D_\mu\in(0,1)$. | B13, U10, P22 | Pending |
| L7.3 `lem:S_lh` | [3053–3064](poisson-declumping-arxiv.tex#L3053-L3064); [3066–3130](poisson-declumping-arxiv.tex#L3066-L3130) | If $k_n=n^{o(1)}$ for $\kappa=1$, or $\kappa^{k_n}=n^{o(1)}$ for $\kappa\ge2$, polynomial cutoff gives raw D-S and expected raw count $\sim n\pi_{k_n}$. | 3.4, 3.7, 7.1, P23 | Pending |
| L7.4 `lem:lh_conditional_mark` | [3148–3156](poisson-declumping-arxiv.tex#L3148-L3156); [3158–3181](poisson-declumping-arxiv.tex#L3158-L3181) | One $C>0$, uniform in $0\le m\le k$, bounds $\mathbb P(\widehat G_k=1,\lambda_\varnothing\ge m)$ by $C\pi_k\pi_m$. | Branching law, criticality, $\pi_m\ge\mu_\kappa\pi_{m-1}^\kappa$ | Pending |
| L7.5 `lem:C_lh` | [3183–3188](poisson-declumping-arxiv.tex#L3183-L3188); [3190–3236](poisson-declumping-arxiv.tex#L3190-L3236) | If $c=1-\kappa\mu_\kappa>0$, declumped leaf-height marks satisfy D-C for every level sequence and cutoff. | 6.1, 7.4, P25 | Pending |

## Numbered definition and remarks

| ID | Source | Required content | Status |
| --- | --- | --- | --- |
| D2.1 `def:indicators` | [740–757](poisson-declumping-arxiv.tex#L740-L757) | First hitting time $\zeta$ of $-1$, reconstruction of a finite tree from its valid prefix, truncated mark $I_1^{(M)}$, and cyclicly shifted $I_i^{(M)}$. Prove locality in the first $M$ increments, Boolean range, monotonicity in cutoff, and equality of the sum with the truncated tree count. | Pending |
| R3.2 `rem:implication_fringe` | [971–1006](poisson-declumping-arxiv.tex#L971-L1006) | Specializations of C3.1 to one prescribed tree, all trees of a prescribed size, and a prescribed degree statistic. Verify $\sum_i n(i)=1+\sum_i i n(i)=k$ for the degree-statistic family. The historical equivalence claims to CD17/BHJ26 are bibliographic comparisons, not new general theorems. | Pending |
| R7.2, unlabelled | [3007–3025](poisson-declumping-arxiv.tex#L3007-L3025) | Exact root leaf-height probability $\ell_k=\pi_k-\pi_{k+1}$ satisfies $\ell_k\sim(1-\mu_1)C_\mu\mu_1^k$ if $\mu_1>0$, and $\ell_k\sim\pi_k\sim\mu_\kappa^{-1/(\kappa-1)}D_\mu^{\kappa^k}$ otherwise. Requires the corresponding consecutive-tail ratios. | Pending |

## Background results and cited prerequisites

These are in scope as dependencies. A citation is not a Lean proof and does
not authorize an axiom or an opaque bundle containing the desired estimate.
Historical claims about which earlier paper first established a result need
bibliographic verification only if advertised; no re-formalization of every
theorem in the bibliography is intended.

| ID | Source | Mathematical obligation and provenance | Status |
| --- | --- | --- | --- |
| B01 | [682–704](poisson-declumping-arxiv.tex#L682-L704) | Plane-tree/DFS definitions, exact degree product $\mathbb P_\mu(T)=\prod_{v\in T}\mu_{\deg(v)}$, branching property, and finite-tree probability normalization for critical nondegenerate $\mu$; Le Gall background. | Pending |
| B02 | [685–696](poisson-declumping-arxiv.tex#L685-L696), `eq:fringe` | DFS-prefix characterization and its bijection with integer excursions of increments at least $-1$; a shifted tree sequence stopped at first $-1$ encodes exactly the selected fringe subtree. | Pending |
| B03 | [718–730](poisson-declumping-arxiv.tex#L718-L730), `eq:shifts` | DFS law of $\mathcal T^n$ equals increments conditioned on $\zeta=n$; an independent uniform cyclic shift gives increments conditioned on $S_n=-1$. Requires the cycle lemma and normalization. | Pending |
| B04 | [751–764](poisson-declumping-arxiv.tex#L751-L764) | Sum of cyclic indicators is invariant under rotation; under the bridge their individual expectations are equal. | Pending |
| B05 | [793–825](poisson-declumping-arxiv.tex#L793-L825), [1740–1772](poisson-declumping-arxiv.tex#L1740-L1772) | First-tree stopping time, measurability of an event at $\zeta=j$, and independent fresh increments after that time; countable Markov decomposition. | Pending |
| B06 | [174–179](poisson-declumping-arxiv.tex#L174-L179), [707–712](poisson-declumping-arxiv.tex#L707-L712), [844–850](poisson-declumping-arxiv.tex#L844-L850) | Stable domain characterized by regularly varying truncated second moment; increasing positive normalization $a_n$, normalized walk convergence, regular variation of index $1/\alpha$. Source cites Feller. | Pending |
| B07 | [846–850](poisson-declumping-arxiv.tex#L846-L850), `eq:cvlaw` | Functional convergence to spectrally positive stable Lévy process in Skorokhod $J_1$; in particular tightness of $\max_{i\le m}\lvert S_i\rvert /a_m$. Only proving scalar convergence does not establish the maximum estimate used later. | Pending |
| B08 | [850–853](poisson-declumping-arxiv.tex#L850-L853), `eq: potter_bound` | Potter bounds for slowly varying real-variable functions, uniformly for all sufficiently large real arguments. Source cites Bingham–Goldie–Teugels; regularity clarification R9 is recorded in the implementation overlay. | Pending |
| B09 | [855–883](poisson-declumping-arxiv.tex#L855-L883), `eq:LL` | Stable local limit theorem, stable density continuity/uniform continuity and positivity at zero, support-span definition, finite-variance normalization, and eventual admissibility in the aperiodic case. Source cites Ibragimov–Linnik. | Pending |
| B10 | [1029–1041](poisson-declumping-arxiv.tex#L1029-L1041), [1138–1177](poisson-declumping-arxiv.tex#L1138-L1177), [1640–1647](poisson-declumping-arxiv.tex#L1640-L1647) | Uniform bounds $\sup_x\Psi_m(x)\le C/a_m$, $\Psi_n(-1)\asymp1/a_n$, microscopic ratios $\Psi_{n-m}(0)/\Psi_n(-1)\to1$ uniformly over compatible $m=o(n)$, global ratio $\le Ca_n$, and analogous small-endpoint ratios. | Pending |
| B11 | [1137–1143](poisson-declumping-arxiv.tex#L1137-L1143), [1326–1342](poisson-declumping-arxiv.tex#L1326-L1342) | Dwass formula for a forest of $\ell$ independent trees: $\mathbb P(\lvert \mathcal G_\ell\rvert =q)=(\ell/q)\mathbb P(S_q=-\ell)$; one-tree consequence $\mathbb P(\lvert \mathcal T\rvert =n)\asymp1/(na_n)$. Handle empty forests separately. | Pending |
| B12 | [1141–1148](poisson-declumping-arxiv.tex#L1141-L1148), [1173–1179](poisson-declumping-arxiv.tex#L1173-L1179) | Karamata tail and partial-sum bounds $\sum_{q>m}1/(qa_q)\le C/a_m$ and $\sum_{h\le n}1/a_h\le Cn/a_n$ for index $1/\alpha\in(0,1)$. | Pending |
| B13 | [2953–2958](poisson-declumping-arxiv.tex#L2953-L2958) | Critical nondegenerate extinction and finiteness of the tree; PGF and its analytic expansion near zero, including differentiated expansions used in P23. | Pending |
| B14 | [1987–1994](poisson-declumping-arxiv.tex#L1987-L1994) | Skorokhod representation and dominated convergence as used for endpoint smoothing; a direct uniform-density bound could replace the representation step, but record this proof departure if adopted. | Pending |
| B15 | [1693–1696](poisson-declumping-arxiv.tex#L1693-L1696), [2117–2120](poisson-declumping-arxiv.tex#L2117-L2120), [2392–2398](poisson-declumping-arxiv.tex#L2392-L2398) | TV coupling bound, triangle inequality, event-probability bound, $d_{\mathrm{TV}}(\operatorname{Poisson}(a),\operatorname{Poisson}(b))\le\lvert a-b\rvert $, Poisson zero mass $e^{-a}$, and continuity in the parameter. | Pending |

## Unnumbered consequences and structural claims

| ID | Source | Obligation | Status |
| --- | --- | --- | --- |
| U01 | [227–300](poisson-declumping-arxiv.tex#L227-L300), [359–364](poisson-declumping-arxiv.tex#L359-L364) | Expected count equals $n$ times the uniform-vertex mark probability; a uniform pair bound implies D-C; subpolynomial conditional skeleton expectation and $\sup_\ell A_n(\ell)\le n^{o(1)}\pi_n^2$ imply T1.1's hypotheses for every $\eta\in(0,1-1/\alpha)$. | Pending |
| U02 | [373–379](poisson-declumping-arxiv.tex#L373-L379), [1424–1430](poisson-declumping-arxiv.tex#L1424-L1430) | Raw complete unary non-fringe counts need not be asymptotically Poisson when $n\mu_1^{k_n}\to\lambda>0$; overlapping occurrences cluster. Source cites CD17, Lemma 5.5. | Pending |
| U03 | [562–586](poisson-declumping-arxiv.tex#L562-L586) | $C_\mu=\lim_k\pi_k/\mu_1^k$ and $D_\mu=\lim_k\pi_k^{1/\kappa^k}$; T1.4 implies $\lambda(\mathcal T^n)/\log n\to1/\log(1/\mu_1)$ or $\lambda(\mathcal T^n)/(\log_\kappa\log n)\to1$ in probability. | Pending |
| U04 | [827–833](poisson-declumping-arxiv.tex#L827-L833) | A maximum exceeds level $k$ iff its raw marked count is positive; declumped positivity implies raw positivity but the converse is not generally deterministic. | Pending |
| U05 | [914–920](poisson-declumping-arxiv.tex#L914-L920), [960–969](poisson-declumping-arxiv.tex#L960-L969) | A proper fringe subtree has strictly smaller size, hence two nested marks forcing the same size are impossible and all $A_n(\ell)=0$. | Pending |
| U06 | [1433–1444](poisson-declumping-arxiv.tex#L1433-L1444) | Conditional on a deterministic non-fringe pattern, the tree consists of its internal skeleton plus independent unconditioned trees at its leaves. Preserve conditional law and the exact number of grafted trees. | Pending |
| U07 | [2468–2476](poisson-declumping-arxiv.tex#L2468-L2476), [2625–2642](poisson-declumping-arxiv.tex#L2625-L2642) | Complete $r$-ary pattern has $k$ internal vertices and one leaf for $r=1$, or $(r^k-1)/(r-1)$ internal vertices and $r^k$ leaves for $r\ge2$; root occurrence probability is $\mu_1^k$ or $\mu_r^{(r^k-1)/(r-1)}$. | Pending |
| U08 | [2495–2509](poisson-declumping-arxiv.tex#L2495-L2509) | Cutting at DFS position $\ell+1$ and grafting are inverse, preserve the marked DFS position, and give a unique decomposition; needed to justify disjoint counting in L6.1. | Pending |
| U09 | [3031–3042](poisson-declumping-arxiv.tex#L3031-L3042), [3274–3296](poisson-declumping-arxiv.tex#L3274-L3296) | $c=1-\kappa\mu_\kappa\ge0$; $c=0$ forces support $\{0,\kappa\}$ and $\mu_\kappa=1/\kappa$. On trees with those degrees, $\lambda(T)=H_\kappa(T)$, $D_\mu=\mu_\kappa^{1/(\kappa-1)}$, and the centerings agree. | Pending |
| U10 | [2922–2930](poisson-declumping-arxiv.tex#L2922-L2930), [2953–2958](poisson-declumping-arxiv.tex#L2953-L2958) | With $\pi_0=1$ and $g(x)=\sum_{j\ge1}\mu_jx^j$, the branching recurrence is $\pi_{k+1}=g(\pi_k)$ and $\pi_k\downarrow0$. The source also sets $\pi_k=1$ for negative levels. | Pending |
| U11 | [3132–3144](poisson-declumping-arxiv.tex#L3132-L3144) | Leaf-height declumped root formula and $\widehat\pi_k\sim(1-\kappa\mu_\kappa)\pi_k$ when $c>0$. | Pending |
| U12 | [3454–3471](poisson-declumping-arxiv.tex#L3454-L3471) | The proposed compound Poisson law is well-defined with geometric jumps on positive integers, has mean $n\ell_{k_n}/(1-\mu_1)$, and this is asymptotic to $n\pi_{k_n}$. This mean calculation is asserted, although the proposed limiting law is conjectural. | Pending |
| U13 | [3473–3491](poisson-declumping-arxiv.tex#L3473-L3491) | If $\mu_1=0$ and $n\pi_{k_n}$ is bounded, then $n\pi_{k_n+1}\to0$, so $n\lvert \pi_{k_n}-\ell_{k_n}\rvert \to0$ and the two displayed Poisson parameters are asymptotically interchangeable. | Pending |

## Substantive proof obligations that must remain visible

These rows prevent a future formalization from hiding the paper's hard steps
inside a theorem hypothesis. They refine the preceding result rows rather
than add a second count of headline paper results.

| ID | Source | Obligation and role | Status |
| --- | --- | --- | --- |
| P01 | [806–824](poisson-declumping-arxiv.tex#L806-L824) | Exact stopped-tree convolution for the uniform-vertex identity; verify the remainder endpoint is $0$, not $-1$. | Pending |
| P02 | [1030–1049](poisson-declumping-arxiv.tex#L1030-L1049) | Split small marked trees and large marked trees; use uniform ratio convergence and $Ca_n$ tail domination to obtain both halves of D-M. | Pending |
| P03 | [1151–1179](poisson-declumping-arxiv.tex#L1151-L1179) | Forest bridge-tail sum split at $n/2$, including remainder length zero and the uniformity in the number of trees. | Pending |
| P04 | [1200–1250](poisson-declumping-arxiv.tex#L1200-L1250) | Conditional skeleton/forest union bound and weighted bound uniform in skeleton size $c\le M_n/8$; handle $L_n=0$. | Pending |
| P05 | [1320–1364](poisson-declumping-arxiv.tex#L1320-L1364) | Rare mark at the root of a size-conditioned tree is negligible: use local forest masses for $C_n\le n/2$, and the structural large-skeleton tail for its complement. | Pending |
| P06 | [1433–1444](poisson-declumping-arxiv.tex#L1433-L1444) | Deterministic skeleton conditions imply the probabilistic D-S tail condition for every $\varepsilon>0$; the uniform two-point condition implies summed D-C. | Pending |
| P07 | [1490–1537](poisson-declumping-arxiv.tex#L1490-L1537) | Star-pattern equivalence with root degree, conditional decomposition $C_d=1,L_d=d$, and uniform descendant pair bound $A_n(\ell)\le\mu_{d_n}^2$ by DFS exposure. | Pending |
| P08 | [1640–1647](poisson-declumping-arxiv.tex#L1640-L1647) | Deterministic-time bridge Radon–Nikodym ratio $\Psi_{n-m}(k-S_m)/\Psi_n(k)$ and its uniform domination. | Pending |
| P09 | [1691–1696](poisson-declumping-arxiv.tex#L1691-L1696) | Coupled count difference is nonnegative and has expectation $n\mathbb P(\text{uniform marked fringe exceeds cutoff})$; its expectation controls both TV truncation and mean error. | Pending |
| P10 | [1747–1787](poisson-declumping-arxiv.tex#L1747-L1787) | $r_n/a_{M_n}\to\infty$, $r_n/a_n\to0$; marked endpoint tail from a stopping-time decomposition plus walk-maximum tightness; bridge ratio then proves $p_n\sim q_n\sim\pi_n$. | Pending |
| P11 | [1822–1856](poisson-declumping-arxiv.tex#L1822-L1856) | Unconditioned two-start bound $\mathbb E[I_1^{(M)}I_{1+\ell}^{(M)}]\le\pi_n^2+A_n(\ell)$, distinguishing nested occurrences from different components of the infinite forest; bridge domination yields the $b_2$ estimate. | Pending |
| P12 | [1891–1995](poisson-declumping-arxiv.tex#L1891-L1995) | Core bridge removal: small/large endpoint split, then $\sup_{\lvert k\rvert \le r_n}\lvert \Delta_n(k)\rvert \to0$. Keep both intermediate estimates visible: uniform $O(\varepsilon)$ deletion error (`eq:approx1`) and fixed-$\varepsilon$ endpoint smoothing (`eq:approx3`), followed by the correct order of limits. | Pending |
| P13 | [2027–2088](poisson-declumping-arxiv.tex#L2027-L2088) | Second moment split into diagonal, nearby, and separated pairs; separated joint probability is $q_n^2+o(\pi_n^2)$ uniformly in the second position. The two blocks are independent only under the unconditioned law. | Pending |
| P14 | [2128–2142](poisson-declumping-arxiv.tex#L2128-L2142) | Transfer the divergent-mean LLN from truncated to full count using expectation $o(n\pi_n)$ and Markov; then transfer law back to trees. | Pending |
| P15 | [2217–2231](poisson-declumping-arxiv.tex#L2217-L2231), `eq:parent_formula` | Exact root formula $\widehat\pi=\mathbb E[\mathbf1_{\{D\in B\}}(1-(1-\pi)^D)]$; pointwise $p\le1-(1-p)^d\le dp$ for $d\ge1$; $b_B\pi\le\widehat\pi\le c_B\pi$; dominated-convergence derivative at zero, preserving finite-first-moment rather than finite-second-moment assumptions. | Pending |
| P16 | [2233–2298](poisson-declumping-arxiv.tex#L2233-L2298) | Declumped unweighted and bridge-weighted tails: marked-child/other-forest split, convolution inequality, $\min(1,D/a_{M_n})$ domination, and the shift from $n$ to $n-1$. This is the principal new step in L5.1(iii). | Pending |
| P17 | [2360–2390](poisson-declumping-arxiv.tex#L2360-L2390) | Deterministic comparison: declumped positivity implies raw positivity; under propagation, raw positivity and zero declumped count force a root mark. Therefore the difference of zero probabilities lies between zero and the root-mark probability. | Pending |
| P18 | [2557–2621](poisson-declumping-arxiv.tex#L2557-L2621) | Product weight factorization under grafting, countable sums of cut-tree weights, disjointness/uniqueness, and the weighted maximum-of-conditional-probabilities bound. | Pending |
| P19 | [2670–2753](poisson-declumping-arxiv.tex#L2670-L2753) | Raw $r$-ary pair sum $\sum_{\ell\le M_n}A_n(\ell)\le C\pi_{k_n}+M_n\pi_{k_n}^2$. Includes unary geometric continuation; for $r\ge2$, $\pi_a^{r^{k-a}}=\pi_k/\pi_{k-a}$ and uniform boundedness of the skeleton contribution; DFS positions in the grafted forest. | Pending |
| P20 | [2815–2895](poisson-declumping-arxiv.tex#L2815-L2895) | Unary centering identity and propagation; for $r\ge2$, $n\pi_{m_n+j}\sim\mu_r^{-1/(r-1)}n^{1-r^{j-\theta_n}}$, threshold implications `eq:threshold_rary`, subsequence splitting at $\theta_n=1/2$, and interior one-point concentration. | Pending |
| P21 | [2768–2791](poisson-declumping-arxiv.tex#L2768-L2791) | In a double declumped $r$-ary event, the cut is outside the root witness or beyond its internal skeleton; arbitrary grafting preserves it, giving the uniform pair bound $\widehat\pi_k^2$. | Pending |
| P22 | [2953–3004](poisson-declumping-arxiv.tex#L2953-L3004) | Iterated PGF analysis: in the unary case, summable geometric decay and a positive convergent product; otherwise superexponential bound, absolutely summable logarithmic increments, negative limiting log, and tail error after multiplying by $\kappa^n$. This proves an asymptotic equivalent, not merely logarithmic order. | Pending |
| P23 | [3066–3129](poisson-declumping-arxiv.tex#L3066-L3129) | Conditional first-$k$-generation tree law; offspring tilt $\widetilde\mu_s(j)=\mu_j\pi_{s-1}^j/\pi_s$; mean $m_s=\pi_{s-1}g'(\pi_{s-1})/\pi_s$; expected generation products bounded by $C$ or $C\kappa^i$, and expected skeleton-plus-frontier bounded by $Ck$ or $C\kappa^k$. | Pending |
| P24 | [3274–3385](poisson-declumping-arxiv.tex#L3274-L3385) | Two-support reduction, unary propagation and bounded mean centering, and for $\mu_1=0,c>0$ the asymptotic level intensities, `eq:threshold_lh`, two-point subsequence assembly, and one-point interior refinement. | Pending |
| P25 | [3190–3235](poisson-declumping-arxiv.tex#L3190-L3235) | Leaf-height cut-tree selector $\tau(A)=0$ for an unaffected witness, otherwise $(k-h(A))_+$; verify both cut-and-graft hypotheses, then use L7.4 and $\widehat\pi_k\ge b\pi_k$ to get a uniform $C\widehat\pi_k^2$ pair bound. | Pending |

## Conjectural and prospective statements

These remain visible in the declared source scope, but cannot be recorded as
proved paper results. Do not silently promote them to claims of the paper or
discard them. A decision to prove them would extend the current proof campaign.

| ID | Source | Status and content |
| --- | --- | --- |
| Q01 | [3439–3447](poisson-declumping-arxiv.tex#L3439-L3447) | **Conjectural:** for $\mu_1>0$, bounded-mean exact leaf-height count approaches $\operatorname{Poisson}(n\ell_{k_n})$. |
| Q02 | [3448–3462](poisson-declumping-arxiv.tex#L3448-L3462) | **Conjectural:** for $\mu_1>0$, the exceedance count approaches a compound Poisson law with intensity $n\ell_{k_n}$ and positive geometric jumps of parameter $1-\mu_1$. |
| Q03 | [3473–3481](poisson-declumping-arxiv.tex#L3473-L3481) | **Conjectural:** for $\mu_1=0$, bounded-mean exact leaf-height count approaches $\operatorname{Poisson}(n\ell_{k_n})$. |
| Q04 | [3482–3496](poisson-declumping-arxiv.tex#L3482-L3496) | **Conjectural:** for $\mu_1=0$, the exceedance count approaches $\operatorname{Poisson}(n\pi_{k_n})$. Parameter interchange is the separate proved-intended claim U13. |
| Q05 | [664–667](poisson-declumping-arxiv.tex#L664-L667), [3431–3436](poisson-declumping-arxiv.tex#L3431-L3436), [3463–3464](poisson-declumping-arxiv.tex#L3463-L3464) | **Perspectives/heuristics:** a general divergent-mean CLT, other distance-to-boundary models, other declumping models, and a geometric cluster-length interpretation. No precise theorem or proof is asserted. |

## Initial audit findings and proof-route cautions

1. **Periodic laws cannot be dropped.** The four Introduction theorems allow
   them. The proofs deliberately use the aperiodic notation; lines 868–883
   claim lattice adaptation. Implement compatible endpoint restrictions and
   limits along admissible sizes. In particular, the uniform conditional
   bound in L4.2 cannot quantify over a zero-probability endpoint as though
   its conditional law were the intended bridge law. Likewise uniform ratios
   in B10 are only asserted at compatible sizes. This is an explicit pending
   extension obligation, not an established formalization.
2. **A proof citation should be corrected in T1.3(ii).** Lines 2853–2855
   invoke C3.8(ii) after obtaining summed D-C from L6.2(ii). C3.8 assumes the
   stronger uniform pair bound, which was not established there. Apply
   T1.1(ii) directly using D-M from C3.7(i) and D-C from L6.2(ii). This
   preserves the mathematical argument and conclusion without inventing a
   stronger hypothesis. Record this local correction in proof correspondence.
3. **The maximum in L6.1 needs a convention or a nonempty index.** The source
   says a finite family indexed by $I$ but writes $\max_{m\in I}$ without
   expressly requiring $I\ne\varnothing$. All applications have $I=\{0\}$
   or $I=\{0,\ldots,k\}$ and are nonempty. Use a nonempty finite type in
   that interface or prove the empty case with an explicitly documented
   convention; do not leave an undefined maximum hidden in notation.
4. **Boundary, zero, and strictness conditions require proofs.** Treat
   $\pi_n=0$, empty forests, zero remainder time, small inadmissible $n$,
   possibly negative floored levels, and the distinction between $\ge k$
   and $>k$ explicitly. The $+1$ in the unary maximum formula is essential.
5. **The infinite-forest pair argument needs actual conditional reasoning.**
   The event that a deterministic DFS position lies after the first tree
   depends on that first tree's size. The bound in P11 is justified by
   conditioning at its endpoint and fresh increments, not by asserting
   unconditional independence of the two marked events on a dependent
   membership event.
6. **Two key interfaces must not swallow the theorem.** A stable-walk
   toolkit structure is useful only with a later theorem deriving it from
   the stated stable-domain hypothesis; a generic declumping identity is
   useful only after identifying it with the Bienaymé branching law. Until
   those bridges are proved, main results using them remain conditional.

These findings arose from a full-source inventory read. They are not an
exhaustive correctness verdict on all probabilistic arguments. No source
files were edited. Each main Lean statement still requires a reviewer to
compare its elaborated type and semantic definitions with the exact source.

## Priority dependency route for continuation

1. Settle finite ordered trees, DFS vertices, fringe size, exact non-fringe
   grafting, marked/raw/declumped counts, and P17. These support every main
   result and expose semantic mistakes early.
2. Construct the actual critical Bienaymé law and its branching/product law;
   connect finite trees to walks, stopping times, cycle shifts, and Dwass.
   Implement admissibility before defining size-conditioned tree laws.
3. Prove the stable random-walk toolkit with the full range $\alpha\in(1,2]$
   and periodic support handling. Independently review the exact T1.1
   interface before substantial dependent work.
4. Establish C2.3, D-S $\Rightarrow$ D-M, truncation, P4.1, and all three
   Chen–Stein errors. The endpoint-smoothing P12 is the distinctive hard
   bounded-mean step; the separated-pair P13 supplies the LLN.
5. Finish T1.1, then the root mean and microscopicity estimates L5.1, T1.2,
   and the zero-event transfer L5.2/C5.3.
6. Complete the $r$-ary application first: exact occurrence probabilities,
   cut-and-graft, D-S/D-C, thresholds, and T1.3.
7. Prove the leaf-height PGF asymptotics, conditional generation estimates,
   and cut-and-graft bounds; finish T1.4 including the two-support case.
8. Reconcile C3.1, R3.2, L3.3, C3.8, P3.9, R7.2, and every remaining U/P/B
   obligation; distinguish the conjectures. Then perform the full omission
   scan and the publication-interface/source review before claiming coverage.
