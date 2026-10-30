# Independent statement and milestone review

## Final publication scope and reduced hypothesis review (30 October 2026)

This is the current interface review. Earlier milestone sections are historical;
where they describe the old two-clause `StableDomain`, this section supersedes them.

- `/root/final_stable_scope` independently reconstructed the source's operational
  domain-of-attraction assumption, inspected every use of the old moment field,
  and gave **PASS** to removing that unused conjunct. No proof consumed it. The
  two shared declarations and three witness constructors were updated; separately
  proved moment lemmas remain. The main statements now require normalized weak
  convergence directly, with no additional unproved characterization hypothesis.
- `/root/final_challenge` independently reviewed the revised standalone Challenge:
  **PASS** for all four statements, their carriers, quantifiers, common constants,
  admissible-size limits and lattice corrections. The shared definitions agree
  textually with `Statements/Defs.lean`; the retained slow-variation definition is
  unused background. No local-limit or process convergence estimate is assumed.
- `/root/final_functional_scope` traced the source's uses of functional convergence
  at lines 1763–1770, 1912 and 1987–1994 through the actual proofs: **PASS for
  independence of the main results from full functional J1 convergence**. Scalar
  tails, truncation, deterministic endpoint equicontinuity, actual maximal
  tightness and the precise real-valued trimmed-walk coupling are proved instead.
- The same reviewer reconciled the 35 source result environments against the 35
  named status rows. Publication descriptions retain the periodic-domain
  corrections (L4.2, L4.9), nonempty cut-and-graft convention and proof departures.
- The user agreed to the actual normalization-factor Potter specialization and
  confirmed Apache-2.0, Igor Kortchemski as author/responsible maintainer, and the
  intended repository `igor-kortchemski/rare-subtree-patterns`.

The selected Comparator claims are the four Introduction results. B06's general
characterization and B07's full functional theorem remain open in the original
whole-source inventory; this review does not silently exclude or prove them.
Source fidelity, local builds, standalone kernel replay, sandboxed Comparator and
full Palomar mechanical verification are distinct checks; see `PUBLICATION.md`.


## Completion work after the Codex audit (30 October 2026)

The same paper SHA-256 and inventory IDs apply. This milestone does not certify
whole-paper completion or publication verification.

- **C4.3:** `/root/finish_background` independently reviewed the generalized
  `Bridge.exists_qProb_le_mul_markProb` target against source lines 1651–1658:
  **PASS**. Only $M_n=o(n)$ remains; positivity and divergence were removed.
  Root changed the proof and its two consumers; the affected main proof chain builds.
- **U02:** root independently reviewed the proposed targets and final
  `DirectApplications/UnaryClustering.lean` implementation: **PASS**. The actual
  zero probability tends to $\exp(-(1-\mu_1)\lambda)$, giving positive TV separation
  from both the limiting and varying-parameter Poisson laws. The explicit ceiling
  subsequence proves non-vacuity. The proof derives the assertion from T1.3(i),
  rather than checking CD17's proof.
- **B09 / finite-variance B06:** root approved the early targets;
  `/root/finish_background` independently read all of `Stable/FiniteVariance.lean`:
  **PASS**. Genuine offspring second moments give centering, positive step variance,
  CLT convergence, the stated normalization, index $2$, and a constructed
  `StableDomain` witness. This is not the full characterization, which also
  includes infinite-variance Gaussian attraction and heavy-tailed stable laws.
- **B08:** root reviewed the early target and final `RegularVariation/Functions.lean`:
  **PASS for the actual normalizing slow factor**, at all sufficiently large real
  arguments with one shared threshold. It does not prove a generic ratio-only
  Potter theorem. R9 records the missing regularity convention in that literal claim.
- **B14:** root reviewed the quantile construction and completed
  `Probability/Skorokhod.lean`: **PASS**. The independent reviewers
  `/root/finish_unary_counterexample` and `/root/finish_background` reviewed the
  root-authored CDF and time-change bridges; the latter also reviewed the final
  measurable coupling: **PASS**. Exact marginal laws, positive scaling, atomlessness
  and almost-sure convergence are established. This certifies the real-valued
  representation used at lines 1987–1994; the existing smoothing proof still takes
  its documented deterministic route.
- **B06 existence bridges:** `/root/finish_background` independently reviewed
  `Stable/DomainCharacterization.lean`: **PASS as conditional bridges**. Tightness
  and Prokhorov construct the probability law and weak convergence from explicit
  CF asymptotics, without `StableDomain` or an assumed limit measure. The required
  analytic CF estimate is not yet derived from the general truncated-moment condition.
- **B07 maximum:** root independently reviewed the proposed target and completed
  `Stable/MaximalTightness.lean`: **PASS**. Disjoint first-exit events, the proved
  prefix/suffix factorization and scalar tightness give a uniform bound on the
  actual path maximum. No functional convergence or maximal estimate is assumed.
  This proves the maximal-tightness consequence, not the functional $J_1$ theorem.
- **B06 lower analytic bound:** root reviewed `Stable/TruncatedMoment.lean`:
  **PASS for the partial bound**. It uses the actual shifted offspring CF and
  accounts for the vanishing contribution at offspring one. Its explicit positive
  cosine lower bound is not an Abelian asymptotic or a full characterization.

Fresh build and axiom evidence for the integrated tree is recorded in
`FORMALIZATION_REPORT.md` and `verification/README.md`. Earlier clean-copy evidence
applies to its recorded earlier source hash, not automatically to this changed tree.

## Initial deterministic statement checkpoint

- **Date:** 30 October 2026.
- **Reviewer:** `/root/main_architecture`, a separate agent that did not author
  the Lean definitions or the proposed declarations.
- **Source:** `poisson-declumping-arxiv.tex`, arXiv:2607.22291v1; the plane-tree
  setting at lines 679–713 and the deterministic argument inside
  `lem:declump_to_raw` at lines 2334–2399.
- **Semantic definitions reviewed:** `PoissonDeclumping.PlaneTree` and its
  `children`, `rootDegree`, `fringeTrees`, `vertexCount`, `markCount`,
  `declumpedMark`, and `PropagatesOutside` definitions in
  `PoissonDeclumping/PlaneTree/Basic.lean`.
- **Verdict:** **PASS** for the two deterministic targets below. This permits
  their proof development without further user approval.

The exact types checked were:

```lean
∀ (B : Set ℕ) (G : PlaneTree → Prop) (T : PlaneTree),
  PropagatesOutside B G →
  0 < markCount G T →
  markCount (declumpedMark B G) T = 0 →
  G T

∀ (B : Set ℕ) (G : PlaneTree → Prop) (T : PlaneTree),
  0 < markCount (declumpedMark B G) T →
  0 < markCount G T
```

The planned theorem names are `marked_root_of_no_declumped` and
`declumped_count_pos_imp_raw_count_pos`, respectively, in namespace
`PoissonDeclumping.PlaneTree`.

### Mathematical findings

The reviewer reconstructed the source argument before inspecting the proposed
Lean interface. A finite plane tree is a root with an ordered finite list of
child trees; the inductive `PlaneTree.node` representation directly encodes
that object. A leaf has an empty child list and one vertex. No binary-tree
restriction, labels, infinite branches, or extra probabilistic assumptions
have been introduced.

`fringeTrees` recursively lists the root followed by the fringe lists of each
child in order. Equal subtrees at distinct vertices remain repeated list entries.
Thus `markCount` counts occurrences, as the paper requires, rather than distinct
isomorphism classes. The arbitrary predicate `G` is the proposition-valued
equivalent of a zero-one mark.

`declumpedMark B G T` expands to exactly the paper's conjunction: the root
degree lies in `B`, and at least one child is marked. In particular, a leaf is
never declumped-marked, even when `0 ∈ B`.

`PropagatesOutside B G` quantifies over every parent tree and every child and
contains exactly the source's child-to-parent implication. It is equivalent to
the source's formulation over every tree and every vertex, by applying it to
each fringe tree; conversely the source formulation applies at a root. The
reviewed targets concern one fixed mark and therefore faithfully apply at each
index of the paper's mark sequence.

No unresolved characterization bridge is needed for this deterministic scope.
The finite-tree induction proof can follow the same upward propagation as the
paper's minimal-depth argument. The probability law and stable offspring
hypotheses are intentionally absent because neither deterministic statement
uses them.

### Elaboration evidence and limits

The coordinator compiled the definition module with
`lake build PoissonDeclumping.PlaneTree.Basic` and then ran:

```sh
lake env lean /tmp/poisson-declumping-statement-check.lean
```

The probe imports `PoissonDeclumping.PlaneTree.Basic` and uses `#check` on the
two exact universal propositions above, without proof holes. The coordinator
reported exit status zero and both elaborated types ending in `: Prop`; the
reviewer independently inspected the probe source and semantic definitions.
The reviewer did not start a competing Lean build. The probe is temporary;
the exact types and command are retained here for reproducibility.

This pass establishes **statement fidelity**, not a proof-completion claim.
The full probabilistic `lem:declump_to_raw`, the four Introduction theorems,
whole-paper coverage, axiom evidence, Comparator, and Palomar verification
are not certified by this checkpoint. A later milestone review must inspect
the actual completed theorem types and proof routes. Revisit this pass if the
reviewed types or semantic definitions change.

## Probability reduction: early statement checkpoint

The same independent reviewer checked the proposed probability reduction against
`lem:declump_to_raw`, lines 2343–2399. **Statement-fidelity verdict: PASS.**
The exact target in `/tmp/poisson-declumping-probability-check.lean` was inspected
independently. The coordinator ran `lake env lean` on that probe and reported
exit status zero with no additional premises in the elaborated type. This
closes the early checkpoint; final implementation and axiom evidence remain
subject to the completion review.

The checked universal proposition, under `[MeasurableSpace PlaneTree]`, is:

```lean
∀ (l : Filter ι) (μ : ι → Measure PlaneTree)
  [∀ i, IsProbabilityMeasure (μ i)]
  (B : Set ℕ) (G : ι → PlaneTree → Prop) (rate : ι → ℝ≥0),
  (∀ i, PropagatesOutside B (G i)) →
  (∀ i, Measurable (markCount (declumpedMark B (G i)))) →
  Tendsto (fun i => (μ i).real {T | G i T}) l (𝓝 0) →
  Tendsto (fun i => paperTVDist
    ((μ i).map (markCount (declumpedMark B (G i))))
    (poissonMeasure (rate i))) l (𝓝 0) →
  Tendsto (fun i => (μ i).real {T | markCount (G i) T = 0} -
    Real.exp (-(rate i : ℝ))) l (𝓝 0)
```

For an arbitrary index type and filter, the proposal takes probability measures
$\mu_i$ on plane trees, marks $G_i$, a fixed degree set $B$, and nonnegative
Poisson rates $\lambda_i$. It assumes:

- the already reviewed propagation property for each $G_i$;
- measurability of each declumped count, so its pushforward is a probability law;
- $\mu_i(\{T:G_i(T)\})\to0$;
- probability-normalized total variation between the declumped count law and
  $\operatorname{Po}(\lambda_i)$ tending to zero.

Its conclusion is

$$
\mu_i(\{T:N_{G_i}(T)=0\})-\exp(-\lambda_i)\longrightarrow0.
$$

The paper's proof uses no additional feature of the conditioned Bienaymé law.
Generalizing to arbitrary tree laws and filters therefore preserves that
argument; the concrete conditioned-tree construction and application remain
separate obligations. No boundedness or convergence of the rates is required.
The nonnegative rate type preserves the domain of the Poisson law.

If the implementation permits an arbitrary measurable space and does not
assume raw/root event measurability, its inequalities are statements about
the measure's outer extension on those sets. The sandwich still holds by
monotonicity and subadditivity. Document that generality and use measurable
events or the discrete measurable space in applications. This is not a reason
to assume an unproved probability estimate or to change the paper's target.

## Total variation normalization review

The independent reviewer inspected
`PoissonDeclumping/Probability/TotalVariation.lean`, including its proof bodies.
The source of this bridge is mathlib's inspected total variation convention,
together with the paper's event-discrepancy use at lines 2390–2396.

The definition `paperTVDist μ ν = MeasureTheory.tvDist μ ν / 2` has the
correct probability normalization. The event-bound theorem requires both
measures to be probability measures and the event to be measurable. It obtains
the factor two by restricting to the event and its complement and using equal
total masses. The attained-converse theorem uses a measurable Hahn decomposition;
equal probability mass turns its signed discrepancy into precisely half the
library distance. Thus `paperTVDist_le_iff` identifies uniform event discrepancy,
rather than merely providing an arbitrary metric that vanishes in the desired
limit.

The range, symmetry, equality, and triangle results retain the necessary
finite/probability assumptions, and the documentation warns that mathlib
totalizes the real distance to zero for infinite measures. No hidden
approximation hypothesis, normalization mismatch, or circular definition was
found. **Mathematical interface and proof-route review: PASS.** Build and axiom
evidence are coordinated by the parent agent: the module build succeeded with
exit status zero, and the final axiom evidence is reviewed below.
No independent build was run during this review. This bridge proves no Poisson
approximation for conditioned trees.

## Deterministic implementation and finite-measure milestone

The reviewer read the completed deterministic proof bodies in
`PoissonDeclumping/Declumping/Deterministic.lean`, the relevant fringe-list
and induction helpers in `PlaneTree/Basic.lean`, and the two completed
finite-measure inequalities in `Declumping/Probability.lean`.

**Statement fidelity and proof correspondence: PASS.** The actual deterministic
theorem types retain the accepted hypotheses and conclusions. A positive
declumped count supplies a child with a raw mark; transitivity of fringe
containment places that child in the original tree. The root-mark theorem
inducts on the finite child structure: absence of declumped marks passes to
every child, the induction hypothesis supplies a root mark in the relevant
child, and the propagation premise moves it to the parent. This is a local
reorganization of the paper's upward propagation argument, not an alternative
mathematical strategy.

`raw_zero_subset_declumped_zero` and
`declumped_zero_subset_raw_zero_union_root` are precisely the two source event
inclusions. `zero_probability_sandwich` applies finite-measure monotonicity and
the union bound to them; `abs_raw_zero_sub_declumped_zero_le` reverses the sign
inside an absolute value using the already proved nonnegative difference.
No probabilistic estimate is hidden in a definition or added as a premise.

The coordinator reported successful builds of the deterministic module and the
probability module containing these inequalities (the latter with 3207 jobs).
Final exported axioms, the Poisson quantitative estimate, and the full filter
limit are not yet certified by this intermediate milestone. No concurrent
reviewer build was started.

## Completed abstract probability reduction

The reviewer independently read the final types and proof bodies of
`PoissonDeclumping.PlaneTree.raw_zero_poisson_error_le` and
`PoissonDeclumping.PlaneTree.declump_to_raw` in
`PoissonDeclumping/Declumping/Probability.lean`, and checked the library
`poissonMeasure_real_singleton` statement used in the proof.

**Final mathematical statement and proof-correspondence verdict: PASS.**
The quantitative theorem proves the exact finite-parameter bound

$$
\left|\mu(N_G=0)-e^{-\lambda}\right|
\le \mu(G(T))+
d_{\rm TV}(\mathcal L_\mu(\widehat N_{G,B}),\operatorname{Po}(\lambda)).
$$

It combines the already reviewed raw/declumped sandwich with the normalized
total variation bound at the measurable singleton zero. The pushforward
probability is identified with the declumped zero event using the explicit
count-measurability hypothesis. The Poisson zero mass is exactly
$\exp(-\lambda)$, including rate zero. No boundedness or limit assumption on
the rate, no hidden BGW estimate, and no surrogate Poisson law appears.

The final filter theorem retains all binders and hypotheses accepted at the
early checkpoint. It applies the quantitative estimate pointwise and squeezes
the norm of the error by the sum of the two quantities assumed to vanish.
This is the paper's same event-sandwich/Poisson-zero-event argument. The change
from the paper's natural-number indexing and conditioned law to arbitrary
filters and tree laws is an explicit generalization, not a weakened result.

For future admissible-size applications, the instance
`∀ i, IsProbabilityMeasure (μ i)` must actually hold. Indexing by the subtype
of admissible sizes is one direct way to arrange this. Alternatively, extend
the conditioned law outside admissible sizes by an arbitrary probability law
and prove the extension irrelevant to the chosen filter. The raw conditional
measure of an impossible size is zero and does not meet this instance.

The actual conditioned Bienaymé construction, its measurability and admissibility
facts, and the estimates discharging the reduction's propagation/root/TV
hypotheses remain open. This review certifies the abstract reduction only, not
those specializations, the Introduction results, or whole-paper coverage.
The root entry point imports this module, whose imports include the reviewed
deterministic and total variation layers.

The coordinator reported a successful warning-free build of
`PoissonDeclumping.Declumping.Probability` with 3207 jobs. The final root-build
and axiom evidence is recorded below. The reviewer did not run a competing build.

## Final local proof evidence and remaining limits

On 30 October 2026, the independent reviewer inspected the actual saved logs,
the persistent axiom probe, and the maintained import root:

- [Root build log](verification/build.log): `lake build` completed successfully
  with 3209 jobs, exit status zero, and no warnings. The root imports
  `PoissonDeclumping.Declumping.Probability`, which includes all four maintained
  mathematical modules.
- [Axiom probe](verification/Axioms.lean) and
  [its output](verification/axioms.log): `lake env lean verification/Axioms.lean`
  completed with exit status zero. The displayed types of the root-propagation,
  quantitative Poisson-error, filter-reduction, and TV-characterization exports
  agree with the reviewed claims.
- All **40** requested named declaration/semantic-definition axiom queries have
  matching output entries. Every reported dependency is a subset of
  `{propext, Classical.choice, Quot.sound}`. None reports `sorryAx`, a custom
  axiom, or a native-evaluation axiom. The reviewer checked the query/output
  correspondence and allowed-axiom set, rather than relying only on a summary.
- A read-only scan of the maintained Lean sources found no `sorry`, `admit`,
  custom `axiom`, `native_decide`, or `bv_decide` declarations/usages. This scan
  supplements the transitive axiom reports; it does not replace them.

**Final scoped verdict: PASS** for the implemented finite-plane-tree count
foundation, probability-normalized total variation bridge, deterministic
declumping comparison, and abstract law-level reduction of
`lem:declump_to_raw`. Source correspondence and the local Lean evidence support
those claims. The source proof's upward propagation, event sandwich, and Poisson
zero-event arguments have been checked for this scope.

The result is still an initial mathematical milestone. The conditioned Bienaymé
law has not been constructed, the admissible-size specialization has not been
completed, and the propagation/root-probability/Poisson-approximation premises
have not been established for the paper's extremal applications. The four main
Introduction theorems and the remaining inventory obligations are unproved.
This review does not certify whole-paper coverage.

The logs establish a successful **local** build and axiom check; they are not
an independent kernel replay, a clean public-checkout build, a Comparator
comparison, or the complete Palomar preflight. No verified publication candidate
for the whole paper, publication, submission, or registration is certified by
this review. Those checks must target the eventual completed candidate and its
exact source revision. Refresh affected evidence after mathematical source,
dependency, configuration, or toolchain changes.

## Main-theorem statement interfaces (second pass, 30 October 2026)

- **Reviewer:** an independent agent that did not write the declarations (read-only; elaborated
  a scratch probe; no builds).
- **Reviewed:** `Setup/Walk.lean` (`StableDomain`, `InStableDomain`), `Setup/Marks.lean`
  (`admissibleSizes`, `IsCutoff`, `markProb`, `uniformFringeLaw`, `Microscopic`, `Skeleton`,
  `StructuralMicroscopic`, `pairProb`, `NonClustering`, `markedCountLaw`),
  `PlaneTree/Patterns.lean`, `Statements/Main.lean` (the four statement-level propositions
  `PoissonApproximationStatement`, `PoissonApproximation2Statement`, `MaxStringStatement`,
  `MaxLeafHeightStatement`), against source lines 173–181, 189–300, 305–586, 679–730, 837–883.
- **Verdicts (statement fidelity only; nothing is proved):** `Walk.lean` PASS;
  `Marks.lean` PASS except (S); `Patterns.lean` PASS; `PlaneTree/Basic, Countable`,
  `Bienayme/Defs`, `TotalVariation` PASS; T1.1, T1.3, T1.4 PASS; (S) and T1.2
  PASS-WITH-FINDINGS.
- **F1 (applied):** `StructuralMicroscopic` required a decomposition `Skeleton` at *every* mark
  index, silently forcing `P(G_j(𝒯)=1) > 0` for all `j` (a null mark makes
  `cond (bienayme μ) {G j}` zero, which no probability measure `ρ` matches). The source
  (line 206) works only along positive marking probabilities. Fixed: the decomposition is now
  required only for `j` with `0 < bienayme μ {G j}`; at null indices it is unconstrained.
  Re-review of `StructuralMicroscopic` and `PoissonApproximation2Statement`: **closed** by the final review below.
- **N2 (applied):** the `E_k[L]/a_{M_n}` clause is now stated in `ℝ≥0∞`
  (`∫⁻ … / ENNReal.ofReal (a (M n)) → 0`), so a junk `toReal` value of an infinite expectation
  cannot satisfy it.
- **Notes retained as proof cautions:** the second-moment clause of `StableDomain` is redundant
  with the convergence clause (not a defect; do not apply Potter bounds to the non-measurable
  witness `ℓ`); `maxCompleteHeight` is an `sSup` on `ℕ` whose characterization as the true maximum
  (for `r ≥ 1`) must be proved before proofs rely on it; the first-order corollaries at source
  lines 574–581 belong in the inventory (added as obligation U03 below); recommended early lemma:
  `admissibleSizes μ` is `NeBot` under `(H_α)`.

## Completed components: statement fidelity and proof correspondence (30 October 2026)

An independent read-only reviewer (not an author of any reviewed file) reconstructed each source
passage before reading the Lean statements and elaborated probes (`#check`, `#print axioms`;
no builds). Scope and verdicts:

| Component | Files | Verdict |
| --- | --- | --- |
| Bienaymé law: weights, normalization, branching, admissible sizes, conditioned laws | `Bienayme/{Defs,Basic,Normalization,Conditioned}.lean` | **PASS** |
| Łukasiewicz coding, cycle lemma, eq:fringe, eq:shifts (as measures), Kemperman | `Lukasiewicz/*.lean` | **PASS-WITH-FINDINGS** |
| Chen–Stein (Prop. 4.1) and B15 Poisson/TV facts | `ChenStein/*.lean`, `Probability/PoissonTV.lean` | **PASS** |
| Leaf-height asymptotics (L7.1, R7.2, U03, U09 analytic half, U10, U13) | `LeafHeight/*.lean` | **PASS** |
| Concrete L5.2 along admissible sizes; `lem:ineqs` | `Declumping/Conditioned.lean`, `Extremes/Ineqs.lean` | **PASS** (as faithful generalizations) |

Findings: (1) documentation (`FORMALIZATION_REPORT.md`, root docstring) was stale — addressed by this
update; (2) Definition 2.1, Lemma 2.2 and the probability form of Corollary 2.3 had no Lean
declaration and the statement-level `Setup/Walk` objects were not linked to the Łukasiewicz-side
`stepPMF`/`walkVecLaw`/`walkMass`/`uniformIndex`/`admissibleAtTop` (assigned to the
`Cyclic/` worker; unified filters are definitionally equal); (3) `tendsto_one_of_witness` needs
`IsProbabilityMeasure` at every index (use an eventual-probability variant or the subtype of
admissible sizes); (4) `tendsto_zero_of_tendsto_lintegral_zero` is stated with `∫⁻ ofReal N` (a Bochner
`E[N]` needs `ofReal_integral_eq_lintegral_ofReal`); (5) L7.1(ii): the paper's superexponential bound
(`eq:ell_superexp`) is replaced by a monotone sandwich `v_k ≤ log D ≤ u_k` — a recorded proof
departure; (6) only the elementary computation U13 is formalized; the conjectures Q01–Q05 are not.
The reviewer also confirmed `admissibleSizes μ = PlaneTree.admissibleAtTop μ` by `rfl` and that
`prop_AGG` has no hidden binders. Axiom evidence: the whole-library audit
(`verification/AxiomAudit.lean`) reports 608 declarations and no axiom outside
`propext`, `Classical.choice`, `Quot.sound`.

Claims the report may state as proved: every export named in the "faithfully" list of the reviewer
(normalization and branching, conditioned laws, eq:fringe, cycle lemma, eq:shifts, Kemperman,
`prop_AGG` by a non-paper proof of a cited result, B15, L7.1/R7.2/U03/U09-analytic/U10/U13, L5.2, L5.4).
The weighted Corollary 2.3 `tsum_sum_weight_mul_fringe` and the sharper internal AGG bound are helpers only.

## Stable random-walk toolbox derivation (30 October 2026)

An independent read-only reviewer checked the derivation `PoissonDeclumping.Stable.stableToolkit :
StableDomain μ α a → StableToolkit μ α a` (files `Stable/*.lean`, 2,692 lines):

- **Non-vacuity: PASS, checked in Lean.** The reviewer elaborated a witness
  `StableDomain μ 2 a` for the *periodic* law `μ = (δ₀+δ₂)/2` (span 2), `α = 2`, `a_n = √(n/2)`, limit
  law `N(0,2)`, and `StableToolkit μ 2 a := stableToolkit witness`. It is now committed as
  `PoissonDeclumping/Examples/SimpleWalk.lean` and rebuilt with the library. The infinite-variance sign
  conventions (`E e^{-λY}=e^{λ^α}`, spectrally positive) were checked conceptually; no junk-value trap
  (Bochner integral 0, `toReal`, floors, `Monotone a` at 0) makes the hypothesis unsatisfiable.
- **Statement fidelity: PASS-WITH-FINDINGS (notes).** `localLimit` is the lattice local limit
  `sup_{k ≡ −n (d)} |a_nΨ_n(k) − d·d_α(k/a_n)| → 0`; `localLimit_of_support` gives the paper's
  `nb + dℤ` form; `latticeSpan` is `gcd{i−j : μ_iμ_j>0}` (singleton support excluded by criticality and
  `μ_1 ≠ 1`); `stableDensity` is the density of `Y_α` with `d_α(0) = Γ(1+1/α) sin(π/α)/π > 0`;
  `latticeLocal` proves `support`, `origin`, `equicont`, `L>0` without extra hypotheses.
  F1: the density facts for α < 2 are stated under `StableDomain` (harmless); F2: the finite-variance
  remark `a_n ∼ c√n` and the claimed *equivalence* of the domain of attraction with the truncated-moment
  clause (line 712) are not formalized — `StableDomain` assumes both clauses; the second-moment clause
  is never used in any proof.
- **Proof route: PASS.** Laplace transform continued analytically (`complexMGF`) to the characteristic
  function; convergence of types for regular variation of `a_n`; CF bounds from uniform convergence of
  `|φ(s/a_m)|^m` on `[1,2]`, `a_{m+1}/a_m → 1` and Potter bounds (not the Ibragimov–Linnik
  truncated-moment estimate); Fourier inversion on `ℤ` (folded to `[−π/d,π/d]`) with dominated convergence.
- **Disclosures:** functional `J_1` convergence (B07) and the Skorokhod step (B14) are *bypassed*, not
  proved: marginal tightness (`tight`) and the deterministic `LatticeLocal.equicont` replace them.

## Final review of the four Introduction theorems (30 October 2026)

A further independent reviewer (reading the source first, then the Lean) re-reviewed the definitions
changed after the first statement review and the final composition. **Overall: PASS-WITH-FINDINGS; no
blocking finding.**

- **Changed definitions: PASS.** (a) F1: `StructuralMicroscopic` requires a decomposition only at mark indices
  with positive probability (never stronger than the paper's (S), line 206; a trivial decomposition exists at
  every non-null index, so the relaxation costs nothing), the `E[L]/a_{M_n}` clause is in `ℝ≥0∞`,
  `conditionally_iid` is exactly the product formula. (b) `IsCutoff.pos` only for `n ≥ 1` appears only as a
  hypothesis, so the theorems are no weaker. (c) the foldr-form `rootLeafHeight` equals the min-over-children
  definition (checked by `#eval` on six trees and by `succ_le_rootLeafHeight_iff`).
- **Statement fidelity and junk values: PASS.** Independent reconstructions of T1.1 and T1.4 with `tvDist/2`,
  `atTop ⊓ 𝓟 {Admissible}`, explicit `rpow`/`sInf` elaborate by `Iff.rfl`. No junk-value trap: `uniformFringeLaw`
  is a probability measure, all `Measure.map` are on discrete countable spaces, every `toReal` acts on a finite
  value and every `toNNReal` on a nonnegative one, the LLN divides only where `nπ_n → ∞`, the `κ` set is
  nonempty, `maxCompleteHeight r` is the true maximum for `r ≥ 1`. At null marks `(M)` and `(C)` hold
  automatically (every fringe subtree of a positive-weight tree has positive weight), so the Lean hypotheses
  are equivalent to the paper's. `admissibleSizes μ` is `NeBot` under `InStableDomain`.
- **Proof route: PASS.** `MainTheorems.lean` composes `Bridge.tendsto_errorB3` with the assembly lemmas;
  the toolkit's `a` is the same `a` that (S) refers to; periodic laws are covered (lattice field of any span;
  R4 repair for `b_3`).
- **Axioms: PASS** for the four theorems, `Stable.stableToolkit`, `Examples.SimpleWalk.witness`.
- **Findings:** S1 (stale statements in the report and the `Statements/Main.lean` header) and S2 (this record)
  are addressed by this update. Notes to disclose: N1 limits along admissible sizes with the actual `n`;
  N2 several hypotheses are weaker than the paper's (eventual boundedness, eventual interior phase, `Monotone a`
  instead of strictly increasing, free `M_0`), so the theorems are slightly stronger; N3 `(H_α)` is the paper's
  literal two-clause Setting (equivalence with the truncated-moment clause not formalized; that clause is unused);
  N4 proof departures (B07/B14 bypassed, Potter instead of Ibragimov–Linnik CF estimate, F8, R4, the L7.1(ii)
  sandwich, F11); N5 the only in-Lean `(H_α)` witness was periodic with `μ_1 = 0`; a second witness with
  `μ_1 > 0` (aperiodic) was requested separately; N6 `maxCompleteHeight 0` is a junk value that no statement uses.
  The evidence is a local build and probes only; Comparator and Palomar checks have not been run.

## Coverage review of Sections 2–7 and the unnumbered obligations (30 October 2026)

A separate independent reviewer checked the coverage record (`FORMALIZATION_REPORT.md`, the overlay in
`PAPER_INVENTORY.md`) against the Lean statements for D2.1, L2.2, C2.3, C3.1, L3.3–L3.6, C3.7, C3.8, P3.9,
L4.2–L4.10, C4.3, L5.1–L5.4, C5.3, L6.1–L6.3, L7.1, L7.3–L7.5, R3.2, R7.2, U01, U05–U09, U11, U12, P11, P15, P19,
P21, P23, P25, re-counted the theorem-like environments (38: 4 theorems, 21 lemmas, 4 propositions, 6 corollaries,
1 definition, 2 remarks; matches the inventory) and elaborated `#check` probes for all ~135 cited names and for the
unconditional instances of the conditional corollaries. **Result: every Lean statement reviewed covers its paper
claim; no mismatch of a statement with its source.** Required corrections to the record (all addressed by the
subsequent update): L6.2(iii) and L7.3(ii) had no Lean declaration (now exported); the P23 bound was misdescribed
(`tiltMean_le` is `m_s ≤ κ·exp(π_{s−1}/(κμ_κ))`); the corrected periodic statements of L4.2, C4.3 and L4.9 had to be
labelled as statement corrections (R2/R4/R5) and the stronger `IsCutoff M` hypothesis of C4.3 disclosed; the
conditional corollaries (C3.1, R3.2, C3.8, P3.9, C5.3, U01, U03) now have exported unconditional forms
(`MainConsequences.lean`); L3.5(ii) is exported in divided form with an endpoint selector and in `sup_x` form only in
numerator form; two bibliographic passages (tex line 3024, lines 3391–3405) were added to the not-formalized list.
Statements the reviewer found accurately described: the account of what is not formalized (U02, Q01–Q05, B07/B14, the
domain-of-attraction equivalence, the R3.2 bibliography, L4.9 at the base point 0).
