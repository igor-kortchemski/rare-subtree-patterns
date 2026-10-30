# Manuscript recommendations

These observations were recorded during the initial source audit on
30 October 2026 against `poisson-declumping-arxiv.tex`, arXiv:2607.22291v1.
They concern the source with SHA-256
`3b75c02ec5e8a7e12d32cccddfe463ae79ca596d1b8b239bc0352110b6472595`.
The audit read the complete source; it did not establish a complete proof
correctness verdict. No manuscript edits have been applied.

The first item is a local proof-reference correction. The other two clarify
domains and conventions that a formal statement must make explicit. None
requires changing an Introduction theorem's mathematical conclusion. These
observations also appear in [the paper inventory](PAPER_INVENTORY.md).

## R1 — Apply the general LLN directly in the complete arity argument

- **Location:** proof of Theorem `thm:max_string`(ii),
  [lines 2849–2855](poisson-declumping-arxiv.tex#L2849-L2855).
- **Category:** Correctness issue — local proof-reference correction.
- **Observation:** The argument invokes Corollary `cor:Non-fringe Poisson`(ii)
  after obtaining microscopicity from Corollary `cor:SM`(i) and pair
  non-clustering from Lemma `lem:S_rary`(ii). That lemma proves the summed
  condition (C). Corollary `cor:Non-fringe Poisson` assumes the stronger
  uniform pair bound displayed in its statement; that bound has not been
  established by the cited argument.
- **Recommendation:** Replace the invocation of Corollary
  `cor:Non-fringe Poisson`(ii) with Theorem `thm:PoissonApproximation`(ii).
  The already established conditions (M) and (C) are exactly the assumptions
  required by the general theorem.
- **Mathematical effect:** No new assumption or changed conclusion. The
  desired normalized law of large numbers, hence divergence in probability,
  follows directly from the results already cited.
- **Priority:** Normal.
- **Status:** Applied in the formal proof (`Extremes.maxString_rary_of` uses Theorem
  `thm:PoissonApproximation`(ii) directly); the TeX source is unchanged.

## R2 — Make compatible bridge endpoints explicit in periodic cases

- **Location:** periodicity discussion,
  [lines 855–883](poisson-declumping-arxiv.tex#L855-L883); bridge domination
  Lemma `lem:error_est`,
  [lines 1633–1647](poisson-declumping-arxiv.tex#L1633-L1647); microscopic
  endpoint-ratio estimates used throughout Sections 3–5.
- **Category:** Clarity recommendation — formalization domain clarification.
- **Observation:** The source explicitly writes subsequent proofs in the
  aperiodic case and describes the lattice extension. In that extension,
  $\mathbb P(S_n=k)$ can be zero for incompatible endpoints. The conditional
  expectation and denominator in the bridge ratio must only be used at
  endpoints of positive probability. A supremum over all integers in a
  bounded interval, copied literally from the aperiodic formula, does not
  express the intended periodic bridge estimate.
- **Recommendation:** When stating a version that includes periodic laws,
  restrict the endpoint supremum to compatible $k$ with
  $\mathbb P(S_n=k)>0$, retain the lattice local limit factor, and state
  size-conditioned conclusions along admissible $n$. Likewise restrict
  microscopic remainder-size ratios to compatible values in their actual
  support. Explain that the lattice factor cancels in those ratios.
- **Mathematical effect:** This makes the domain of conditioning explicit;
  it does not justify adding aperiodicity to the four main theorems. The
  source already announces the needed periodic interpretation, so this item
  is not a claim that the main theorem is false.
- **Priority:** High for formalization: periodic offspring laws remain part
  of the advertised scope.
- **Status:** Periodic laws are formalized with compatible endpoints throughout (lattice local limit
  theorem in `Stable/`, endpoint restrictions in `Bridge/`); no manuscript edit has been applied.

## R3 — State the convention for the finite maximum in cut-and-graft

- **Location:** Lemma `lem:cut_graft`,
  [lines 2512–2546](poisson-declumping-arxiv.tex#L2512-L2546).
- **Category:** Clarity recommendation — formalization domain clarification.
- **Observation:** The lemma uses a finite family indexed by $I$ and writes
  $\max_{m\in I}\mathbb P(\mathcal T\in\mathcal E\mid
  \mathcal T\in\mathcal Q_m)$ without expressly requiring that $I$ is
  nonempty or specifying an empty-maximum convention. Its actual applications
  use $I=\{0\}$ or $I=\{0,\ldots,k\}$, so they are nonempty.
- **Recommendation:** Say “a nonempty finite family” in the statement. An
  alternative is to adopt a clearly stated supremum convention and treat the
  empty case separately. The nonempty version is sufficient for both
  applications in this paper.
- **Mathematical effect:** No change to either application. This supplies the
  condition needed to interpret the displayed real-valued maximum without
  an implicit default.
- **Priority:** Normal.
- **Status:** Formalized with a nonempty finite index (`Patterns.lem_cut_graft`); no manuscript edit has
  been applied.

## Additions from the bridge-estimate audit (30 October 2026, second pass)

These come from a line-by-line extraction of the toolbox facts used in Sections 3–5
(see `docs/BRIDGE_PLAN.md`, table (c), for the F1–F15 labels used in the Lean docstrings). They concern the periodic extension and a few proof steps
whose written form needs adjustment; none changes an Introduction theorem.

## R4 — Periodic case: a base point of Lemma `lem:1` is a null conditioning event

- **Location:** Lemma `lem:1` and its proof, lines 1872–1995, definition
  $\Delta_n(k)=h_n(k)-h_n(0)$ at lines 1873, 1927, 1935.
- **Category:** Correctness issue — periodic extension (the aperiodic proof is unaffected).
- **Observation:** $h_n(0)$ conditions on $S_{n-M_n}=-1$; for admissible $n$ and a periodic law of
  span $d\ge2$ this event has probability zero unless $d\mid M_n$, so $h_n(0)$ is not defined by the
  stated conditional expectation.
- **Recommendation:** Subtract any compatible base value (the identity for $b_3$ holds after
  subtracting an arbitrary constant) and prove that the oscillation of $h_n$ over pairs of compatible
  $k,k'$ tends to zero; or assume $d\mid M_n$ along the sequence.
- **Mathematical effect:** None on the conclusion; the lattice proof is a repair of a step written
  only for the aperiodic case.

## R5 — Ratios of local probabilities must be taken at compatible points

- **Location:** Lemma `lem:forest_estimates`(ii) and Lemma `lem:consequenceM`, lines 1127–1132 and
  1236–1245; Lemma `lem:root_declumping`(iii) at 2259 and 2286–2287 (the shift from $n$ to $n-1$);
  Corollary `cor:pip` at 1653 ("for every $n\ge1$").
- **Category:** Clarity recommendation / periodic domain.
- **Observation:** "$\Psi_{n-c}(-1)\sim\Psi_n(-1)$ uniformly for $c\le M_n/8$", applying
  Lemma 3.5(ii) "with $n-c$", and the replacement of $n$ by $n-1$ divide by $\Psi_{n-c}(-1)$ or
  $\Psi_{n-1}(-1)$, which vanish whenever the shift is incompatible with the lattice of span $d\ge2$.
  Corollary `cor:pip` holds only for admissible $n$.
- **Recommendation:** State Lemma 3.5(ii) and the consequence lemma in numerator form
  ($\le C\ell/(a_ma_N)$ for all $N\ge2m$, uniformly in the endpoint) and divide by
  $\Psi_n(-1)\ge c/a_n$ at the end; restrict Corollary `cor:pip` to admissible $n$.

## R6 — Marginal tightness and a deterministic smoothing bound replace two cited tools

- **Location:** lines 1763–1770 and 1912 (functional $J_1$ tightness), lines 1987–1994
  (Skorokhod representation).
- **Category:** Proof-route note (not an error).
- **Observation:** Only the marginal tightness of $S_m/a_m$ is used, and the endpoint smoothing can be
  obtained from the local limit theorem's equicontinuity directly; the formalization takes these
  routes. The real-valued representation (B14) and actual maximal tightness are now separately
  proved; the full functional limit (B07) remains open, and the main smoothing proof still uses
  the deterministic route.

## R7 — A conditioning step in Lemma `lem:boundb2`

- **Location:** lines 1835–1845 (proof of $b_2\to0$).
- **Category:** Clarity recommendation.
- **Observation:** "two independent Bienaymé trees" is asserted on the event $\{v_{1+\ell}\notin\mathcal T\}$,
  which depends on $|\mathcal T|$; the bound needs conditioning on $\zeta=j\le\ell$ and fresh
  increments after $\zeta$.
- **Recommendation:** Condition at the stopping time $\zeta$, as the formalization does.

## R8 — Cutoff $\lfloor n^{1-\eta}\rfloor$ at $n=0$ and Kemperman's formula for forests

- **Location:** Lemmas `lem:critM`, `lem:S_rary`, `lem:S_lh` ($M_n=\lfloor n^{1-\eta}\rfloor$);
  Lemma `lem:forest_estimates` (1137–1139, 1338–1341).
- **Category:** Clarity recommendation.
- **Observation:** $M_0=0$ is not a positive integer (irrelevant, since only large $n$ matter;
  the formalization indexes cutoffs from $n\ge1$); the Dwass/Kemperman formula for forests is cited
  without proof (the formalization proves it via a generalized cycle lemma).

## R9 — Regularity in the general Potter statement

- **Location:** The definition of slow variation and `eq: potter_bound`, line 850.
- **Category:** Missing hypothesis in the literal background statement.
- **Observation:** The ratio-only definition omits the measurability or Baire
  regularity used in the cited theory. BGT retains measurability in its definition
  (p. 8), and its Theorem 1.2.2 (pp. 10–11) gives a ratio-convergent pathological
  function unbounded on every interval. Exponentiating its additive form after
  a logarithmic change of variables yields a positive slowly varying function
  contradicting any Potter bound on a compact interval far out.
- **Recommendation:** State the standard positive measurable convention, or
  restrict this displayed bound to the normalizing slow factor actually used.
  See [BGT, Chapters 1.2 and 1.5](https://api.pageplace.de/preview/DT0400.9781107107939_A23693114/preview-9781107107939_A23693114.pdf).
- **Formalization:** `RegularlyVaryingSeq.potter_floor_slowlyVarying` proves the
  all-real bound for the actual normalizing factor, without this ambiguity.
  The user chose to state explicitly that these are the Potter bounds used by the paper;
  a generic measurable theorem is not claimed by the formalization. No TeX edit was made.
