> **Provenance note.** This is the pre-implementation plan for the bridge estimates of Sections 3–5 (written
> before they were formalized). The corrections F1–F15 in its table (c) are the labels cited in the module
> docstrings of `PoissonDeclumping/Bridge/` and `Setup/Toolkit.lean`; they are summarized as R1–R8 in
> `MANUSCRIPT_RECOMMENDATIONS.md`. Where the plan says a `StableToolkit` is a temporary interface: it is now
> derived from `(H_α)` by `Stable.stableToolkit`. The coverage record is `FORMALIZATION_REPORT.md`.

# Bridge plan: the `StableToolkit` interface and the Sections 3–5 work packages

Source: `poisson-declumping-arxiv.tex` (3,504 lines). Interface file:
`PoissonDeclumping/Setup/Toolkit.lean` (builds with
`lake build PoissonDeclumping.Setup.Toolkit`, no warnings, axioms
`propext, Classical.choice, Quot.sound` only). Notation: $\Psi_m(x)$ = `walkProb μ m x`
(zero for negative time), `𝒯` = `PlaneTree.bienayme μ`, `𝒯^n` = `PlaneTree.conditioned μ n`,
admissible = `PlaneTree.Admissible μ n` (equivalently $\Psi_n(-1)>0$ by Dwass), limits along
`admissibleSizes μ`.

Every bridge lemma below takes the single hypothesis `hT : StableToolkit μ α a`. A main
theorem is complete only after the stable-toolbox worker proves
`StableDomain μ α a → StableToolkit μ α a`.

**Signature note.** The structure is `StableToolkit (μ : PMF ℕ) (α : ℝ) (a : ℕ → ℝ)`, not
`(μ) (a)`: Lemma `lem:critM` (L3.4) and its consumers L6.2, L7.3, T1.3, T1.4 quantify over
$\eta\in(0,1-1/\alpha)$, so $\alpha$ must be the same $\alpha$ as in `StableDomain μ α a`.

---

## (a) The fields, their uses, and their derivation from `StableDomain`

### The complete list of toolbox facts used by the paper (extraction)

| ID | Fact, with exact uniformity | Source lines (uses) | Covered by |
| --- | --- | --- | --- |
| TF1 | Regular variation of $a$, index $1/\alpha\in[1/2,1)$: $a_n\to\infty$; $a_n=n^{1/\alpha+o(1)}$; $a_{M_n}/a_n\to0$; $a_{n-o(n)}\sim a_n$ uniformly over the window; $a_{\lfloor\varepsilon n\rfloor}\asymp_\varepsilon a_n$; $a_q\asymp a_n$ for $q\asymp n$; $a_n=o(n)$; $a_{M_n}\to\infty$; $r_n=\sqrt{a_{M_n}a_n}$ has $r_n/a_{M_n}\to\infty$, $r_n/a_n\to0$; Karamata $\sum_{q>m}1/(qa_q)\le C/a_m$ and $\sum_{h\le n}1/a_h\le Cn/a_n$; polynomial cutoff limits | 1087–1105, 1145–1148, 1172–1177, 1218, 1236, 1346–1348, 1752–1753, 1896–1897, 1958, 1986, 2244 | fields `regularlyVarying`, `monotone`, `pos`, `alpha_mem` + `PoissonDeclumping.RegularVariation.*` (already proved) |
| TF2 | Global local bound $\sup_x\Psi_m(x)\le C/a_m$ for **all** $m\ge1$ (one $C$); hence $\Psi_{n-q}\le C/a_n$ for $q\le n/2$ | 1140, 1161–1162, 1176, 1340, 1647, 1774, 1983–1984, 2069, 2254 | field `sup_le`; `exists_le_div_of_le_two_mul` |
| TF3 | $\Psi_n(-1)\ge c/a_n$ at **every** admissible $n$ (one $c$); hence $P(\lvert\mathcal T\rvert=n)\ge c/(na_n)$ | 1034, 1164, 1231, 1329, 1653 | `exists_lower_bound_neg_one` (from `lattice`) |
| TF4 | $\Psi_N(k)\ge c/a_N$ for compatible $\lvert k\rvert\le z_N=o(a_N)$, $N$ large (incl. $N=n-M_n$) | 1647, 1958–1963, 1981 | `eventually_bounds` |
| TF5 | Ratio limits $\Psi_{N-j}(x)/\Psi_N(y)\to1$ uniformly over $j\le m_N=o(N)$ and **compatible** $\lvert x\rvert,\lvert y\rvert\le z_N=o(a_N)$. Instances: $(j,x)=(k_n,0)$ C3.1; $(j\le M_n,0)$ L3.3, C3.7, L5.1; $(c\le M_n/8,-1)$ L3.6 (avoidable, see F3); $(M_n,-1-S_{M_n})$ L4.5; $(2M_n,-1-S_{M_n}-Z)$ L4.10 | 965, 1033, 1236, 1293, 1752, 2066–2067, 2293 | `eventually_abs_div_sub_one_le`, `eventually_abs_mul_sub_le` |
| TF6 | $\max_{0\le i\le M_n}P(\lvert S_i\rvert>r_n-1)\to0$ and $P(\lvert S_{M_n}\rvert>r_n)\to0$ when $r_n/a_{M_n}\to\infty$. The paper invokes functional ($J_1$) tightness; **marginal uniform tightness suffices** | 1763–1770, 1912 | field `tight`; `eventually_walkLaw_tail_le` |
| TF7 | Endpoint smoothing in eq:approx3: for fixed $\varepsilon$, $\sup_{k}\lvert\Psi_{\lfloor\varepsilon n\rfloor}(y-k)/\Psi_{n-M_n}(-1-k)-\Psi_{\lfloor\varepsilon n\rfloor}(y)/\Psi_{n-M_n}(-1)\rvert\to0$; the paper uses Skorokhod + uniform continuity of $d_\alpha$ + dominated convergence | 1968–1994 (B14) | field `lattice.equicont` (+ TF2, TF4): the bound becomes deterministic and uniform in $y$ |
| TF8 | Admissibility: admissible $\iff\Psi_n(-1)>0$ (Dwass); aperiodic $\Rightarrow$ all large $n$ admissible | 703, 860, 1329 | Dwass: WP1; `eventually_walkProb_neg_one_pos_iff` |
| TF9 | Lattice: $S_m\in-m+d\mathbb Z$ a.s.; ratios only at compatible points; factor $d$ cancels | 855–883 | field `lattice.support` |

Not toolbox (combinatorial/probabilistic walk facts, assigned to WP1/WP2/WP4): Markov property at a
deterministic time (1641–1645, 1742–1750, 1971–1974, 2058–2065), strong Markov at $\zeta$ (810–818,
1753–1760, 1837–1844), Dwass for one tree (1329) and **Kemperman for forests** (1137–1139,
1338–1341), forest first-passage decomposition (2250–2255), cyclic exchangeability of the bridge
(1720, 1728, 1952, 2049), conditional independence of blocks given endpoints (1881).
Not needed at all: functional convergence `eq:cvlaw` (B07), Skorokhod representation (B14),
an explicit density $d_\alpha$.

### The fields (exact Lean in `Setup/Toolkit.lean`)

```lean
structure LatticeLocal (μ : PMF ℕ) (a : ℕ → ℝ) (d : ℕ) (L : ℝ) : Prop where
  d_pos : 0 < d
  L_pos : 0 < L
  support : ∀ (m : ℕ) (x : ℤ), walkProb μ m x ≠ 0 → (d : ℤ) ∣ x + m
  origin : ∀ ε : ℝ, 0 < ε → ∃ η : ℝ, 0 < η ∧ ∃ N : ℕ, ∀ n : ℕ, N ≤ n → ∀ x : ℤ,
    (d : ℤ) ∣ x + n → |(x : ℝ)| ≤ η * a n → |a n * walkProb μ n x - L| ≤ ε
  equicont : ∀ ε : ℝ, 0 < ε → ∃ η : ℝ, 0 < η ∧ ∃ N : ℕ, ∀ n : ℕ, N ≤ n → ∀ x y : ℤ,
    (d : ℤ) ∣ x + n → (d : ℤ) ∣ y + n → |((x - y : ℤ) : ℝ)| ≤ η * a n →
    |a n * walkProb μ n x - a n * walkProb μ n y| ≤ ε

structure StableToolkit (μ : PMF ℕ) (α : ℝ) (a : ℕ → ℝ) : Prop where
  critical : IsCritical μ
  nondegenerate : μ 1 ≠ 1
  alpha_mem : 1 < α ∧ α ≤ 2
  monotone : Monotone a
  pos : ∀ n : ℕ, 1 ≤ n → 0 < a n
  regularlyVarying : RegularlyVaryingSeq (1 / α) a
  sup_le : ∃ C : ℝ, ∀ m : ℕ, 1 ≤ m → ∀ x : ℤ, walkProb μ m x ≤ C / a m
  tight : ∀ ε : ℝ, 0 < ε → ∃ K : ℝ, ∀ m : ℕ, 1 ≤ m →
    (walkLaw μ m).real {x : ℤ | K * a m < |(x : ℝ)|} ≤ ε
  lattice : ∃ (d : ℕ) (L : ℝ), LatticeLocal μ a d L
```

Here $d$ is the span $\gcd\{i-j:\mu_i\mu_j>0\}$ and $L=d\,p_\alpha(0)$, $p_\alpha$ the density of
$Y_\alpha$. Since $\mu_0>0$, every step is $\equiv-1\pmod d$, so $S_m\equiv-m$.

| Field | Used at (lines) | Derivation from `StableDomain μ α a` | Difficulty |
| --- | --- | --- | --- |
| `critical`, `nondegenerate`, `alpha_mem`, `monotone`, `pos` | standing | copied fields | trivial |
| `regularlyVarying` | TF1 | convergence of types: $S_{kn}/a_n\to k^{1/\alpha}Y_\alpha$ (strict stability from $E e^{-\lambda Y}=e^{\lambda^\alpha}$) and $S_{kn}/a_{kn}\to Y_\alpha$ give $a_{kn}/a_n\to k^{1/\alpha}$; extend to real $c$ by monotonicity; then `RegularlyVaryingSeq` (or via `RegularlyVaryingSeq.of_slowlyVarying`). Same in periodic case | **nontrivial** (convergence-of-types theorem, integer-to-real extension) |
| `sup_le` | TF2 | lattice LLT + boundedness of $p_\alpha$; finitely many small $m$ by $\Psi\le1$, $a_m>0$. Periodic: LLT on the lattice, zero off it | follows from the LLT |
| `tight` | TF6 | weak convergence of $S_m/a_m$ to a probability law (field `converges`) ⇒ tight for $m\ge m_0$ (test function $\ge 1_{\lvert x\rvert>K}$); finitely many small $m$. Lattice-independent | elementary |
| `lattice.support` | TF9, compatibility in TF3–TF5, F2–F4 | $\mu_0>0$ ⇒ steps $\equiv-1\pmod d$; induction on the convolution `walkLaw` | elementary (definition of the span) |
| `lattice.origin` | TF3, TF4, TF5, TF8 | lattice LLT $\sup_{x\in-n+d\mathbb Z}\lvert a_n\Psi_n(x)-d\,p_\alpha(x/a_n)\rvert\to0$ + continuity of $p_\alpha$ at $0$ + $p_\alpha(0)>0$ | **nontrivial**: the LLT itself (characteristic functions; lattice version with maximal span), and positivity $p_\alpha(0)=\Gamma(1+1/\alpha)\sin(\pi/\alpha)/\pi>0$ (Fourier inversion at $0$ with $\varphi(t)=\exp((-it)^\alpha)$; `Stable/Analytic.lean`'s complex Gamma integral is the right tool) |
| `lattice.equicont` | TF7 | lattice LLT + uniform continuity of $p_\alpha$ ($p_\alpha$ = Fourier inverse of an integrable $\varphi$: continuous and $\to0$ at $\pm\infty$) | follows from the LLT + Riemann–Lebesgue |

Redundancy note: `sup_le` is implied by `equicont` plus $\sum_x\Psi_m(x)=1$ (a large value of
$a_m\Psi_m$ spreads to $\asymp\eta a_m/d$ lattice neighbours), but it is kept as a field because
it is the most-used estimate and is immediate from the LLT.

### Consequences already proved in `Setup/Toolkit.lean` (do not re-prove)

All in namespace `PoissonDeclumping.StableToolkit` unless noted; `hloc : LatticeLocal μ a d L`
comes from `obtain ⟨d, L, hloc⟩ := hT.lattice`.

* instance `PoissonDeclumping.isProbabilityMeasure_walkLaw`, `walkProb_natCast`.
* `rho_pos : 0 < 1 / α`, `rho_lt_one : 1 / α < 1`, `tendsto_atTop : Tendsto a atTop atTop`.
* `exists_le_div_of_le_two_mul : ∃ C, 0 ≤ C ∧ ∀ n m, 1 ≤ n → 1 ≤ m → n ≤ 2 * m → ∀ x, walkProb μ m x ≤ C / a n`.
* `exists_eventually_le_sub : 0 < ε → ∃ δ, 0 < δ ∧ δ < 1 ∧ ∀ᶠ t in atTop, ∀ j, (j:ℝ) ≤ δ * t → (1 - ε) * a t ≤ a (t - j)`.
* `eventually_abs_mul_sub_le (hloc) (hN : Tendsto N atTop atTop) (hm : (m n : ℝ) =o (N n : ℝ)) (hz : z =o (a ∘ N)) (hε) : ∀ᶠ n, ∀ j ≤ m n, ∀ x, (d:ℤ) ∣ x + ↑(N n - j) → |x| ≤ z n → |a (N n) * walkProb μ ↑(N n - j) x - L| ≤ ε`.
* `eventually_bounds` (same hypotheses): `L / 2 / a (N n) ≤ walkProb μ ↑(N n - j) x ≤ 2 * L / a (N n)`.
* `eventually_abs_div_sub_one_le` (same + `y` with `(d:ℤ) ∣ y + N n`, `|y| ≤ z n`): `|walkProb μ ↑(N n - j) x / walkProb μ (N n) y - 1| ≤ ε`.
* `exists_lower_bound_neg_one : ∃ c, 0 < c ∧ ∀ n, 1 ≤ n → 0 < walkProb μ n (-1) → c / a n ≤ walkProb μ n (-1)`.
* `eventually_walkProb_neg_one_pos_iff (hloc) : ∀ᶠ n, (0 < walkProb μ n (-1) ↔ (d:ℤ) ∣ n - 1)`.
* `eventually_walkLaw_tail_le (hM : ∀ᶠ n, 1 ≤ M n) (hr : Tendsto (r n / a (M n)) atTop atTop) (hε) : ∀ᶠ n, ∀ i ≤ M n, (walkLaw μ i).real {x | r n < |x|} ≤ ε`.

Compatibility facts the workers will need (one-liners from `support` + WP1 Dwass): admissible
$n\Rightarrow d\mid n-1$; $P(\lvert\mathcal T\rvert=m)>0\Rightarrow d\mid m-1$, hence $0$ is
compatible with $n-m$; $S_M\equiv-M\pmod d$ a.s., hence $-1-S_M$ is compatible with $n-M$ and
$-1-S_M-Z$ with $n-2M$ at admissible $n$.

---

## (b) Work packages

Owned files are disjoint, all under `PoissonDeclumping/Bridge/`. Every file: `module`,
`public import`s, `@[expose] public section`, namespace `PoissonDeclumping.Bridge`. Lean-style
signatures below are targets; `hT : StableToolkit μ α a` is implicit wherever the toolkit is used.
Prefer list prefixes (`(List.ofFn ω).take m`) to dependent `Fin` casts.

### Dependency order

| Phase | Packages (parallel within a phase) |
| --- | --- |
| 1 (start now) | WP1 walk calculus; WP2a Kemperman (combinatorics); WP4 indicators; L3.4 of WP3 |
| 2 | WP2b forest estimates (needs WP1, WP2a); WP5 bridge removal/truncation/b1/b2 (needs WP1, WP4) |
| 3 | WP3 rest (needs WP1, WP2); WP6 endpoint smoothing (needs WP5) |
| 4 | WP7 L4.10 and assembly of T1.1, T1.2 (needs WP3, WP5, WP6) |

### WP1 — Walk calculus and the uniform-vertex identity (no toolkit)

Files: `Bridge/WalkCalculus.lean`, `Bridge/UniformVertex.lean`. Source: 719–730, 777–825,
1641–1645, 1881, B03–B05, P01, P08.

1. `walkLaw_eq_map_sum : walkLaw μ n = (Lukasiewicz.walkVecLaw μ n).map (fun ω => ∑ i, ω i)`.
2. `walkProb_eq_walkMass : walkProb μ n s = (Lukasiewicz.walkMass μ n s).toReal` and
   `walkProb_eq_measureReal : walkProb μ n s = (walkVecLaw μ n).real {ω | ∑ i, ω i = s}`.
3. Basics: `walkProb_nonneg`, `walkProb_le_one`, `walkProb_zero_left : walkProb μ 0 x = if x = 0 then 1 else 0`,
   `walkProb_of_neg : m < 0 → walkProb μ m x = 0`, `hasSum_walkProb : HasSum (walkProb μ m) 1`.
4. Chapman–Kolmogorov: `walkProb_add : walkProb μ (m + k) s = ∑' x, walkProb μ m x * walkProb μ k (s - x)`.
5. Markov at a deterministic time (P08): for `m ≤ n`, `H : List ℤ → Prop`,
   `(walkVecLaw μ n).real {ω | H ((List.ofFn ω).take m) ∧ ∑ i, ω i = k} = ∫ ω', 1_{H (List.ofFn ω')} * walkProb μ (n - m) (k - ∑ i, ω' i) ∂ walkVecLaw μ m`;
   the conditional form under `cond (walkVecLaw μ n) {∑ = k}` when `walkProb μ n k ≠ 0`; the
   two-disjoint-blocks form (for L4.10) and conditional independence of `(X_1..X_m)` and
   `(X_{m+1}..X_n)` given `S_m = k, S_n = s` (for P4.8, line 1881); suffix form (law of
   `(X_{m+1}..X_n)` is `walkVecLaw μ (n - m)`).
6. Cyclic exchangeability: `(bridgeLaw μ n).map (fun ω => rotate ω i) = bridgeLaw μ n`.
7. Dwass in $\Psi$ form: `(n : ℝ) * (bienayme μ).real {T | T.vertexCount = n} = walkProb μ n (-1)` and
   `1 ≤ n → (PlaneTree.Admissible μ n ↔ 0 < walkProb μ n (-1))` (from `natCast_mul_tsum_weight_eq_walkMass`).
8. C2.3 in measure form (from `tsum_sum_weight_mul_fringe`), valid for **every** `n` (both sides
   vanish at inadmissible `n`):
   `(uniformFringeLaw μ n).real A * walkProb μ n (-1) = ∑' T, (bienayme μ).real {T} * A.indicator 1 T * walkProb μ ((n:ℤ) - T.vertexCount) 0`,
   and the bridge form `uniformFringeLaw μ n A = bridgeLaw μ n {ω | ∃ T, PlaneTree.ofSeq (List.ofFn ω) = some T ∧ T ∈ A}` (`n ≥ 1`;
   bridges `uniformOn (Set.Iio n)` with `uniformIndex n`).

### WP2 — Kemperman and forest estimates

Files: `Bridge/Kemperman.lean` (WP2a, no toolkit), `Bridge/ForestEstimates.lean` (WP2b).
Source: 1119–1180 (L3.5, P03), 1137–1139, 1328–1342 (B11), 2250–2255.

WP2a:
1. Generalized cycle lemma: a list of `q` integers `≥ -1` with sum `-ℓ` (`ℓ ≥ 1`) has exactly
   `ℓ` rotations whose first passage to `-ℓ` is at time `q`.
2. Kemperman: `1 ≤ ℓ → 1 ≤ q → (q : ℝ≥0∞) * PlaneTree.forestSizeWeight μ ℓ q = ℓ * Lukasiewicz.walkMass μ q (-ℓ)`
   (forests coded by `forestSeq`, `exists_forestSeq_eq`).
3. Forest first-passage decomposition:
   `walkMass μ N (-ℓ) = ∑ q ∈ Finset.range (N + 1), forestSizeWeight μ ℓ q * walkMass μ (N - q) 0`.

WP2b (L3.5, corrected to numerator form, see F3/F12):
1. `forest_tail_le : ∃ C, ∀ ℓ m : ℕ, 1 ≤ ℓ → 1 ≤ m → ∑' q, (Set.Ioi m).indicator (fun q => (forestSizeWeight μ ℓ q).toReal) q ≤ C * ℓ / a m`.
2. `forest_weighted_tail_le : ∃ C, ∀ ℓ m N : ℕ, 1 ≤ ℓ → 1 ≤ m → 2 * m ≤ N → ∀ e : ℕ → ℤ, ∑' q, (Set.Ioi m).indicator (fun q => (forestSizeWeight μ ℓ q).toReal * walkProb μ ((N:ℤ) - q) (e q)) q ≤ C * ℓ / (a m * a N)`
   (the endpoint selector `e` encodes $\sup_x$).
3. Paper form as corollary: divide by `walkProb μ n (-1) ≥ c / a n` (`exists_lower_bound_neg_one`).
4. `forest_local_le : ∃ C, ∀ ℓ N, 1 ≤ ℓ → 1 ≤ N → (forestSizeWeight μ ℓ N).toReal ≤ C * ℓ / (N * a N)` and
   `tree_size_asymp : ∃ c C, 0 < c ∧ ∀ n, 1 ≤ n → Admissible μ n → c / (n * a n) ≤ (bienayme μ).real {|T| = n} ∧ (bienayme μ).real {|T| = n} ≤ C / (n * a n)` (1329).

### WP3 — Microscopicity (Section 3.2–3.3) and inherited microscopicity L5.1(iii)

Files: `Bridge/CriterionS.lean` (L3.3, L3.4), `Bridge/Microscopic.lean` (L3.6, C3.7),
`Bridge/RootMicroscopic.lean` (L5.1(iii)). Source: 1015–1110, 1182–1365, 2231–2299; P02, P04,
P05, P16.

1. L3.4 `critM (η) (hη : 0 < η ∧ η < 1 - 1/α) (ρ : ℕ → Measure (PlaneTree × ℕ × List PlaneTree)) (hρ : ∀ j, 0 < bienayme μ {G j} → Skeleton μ (G j) (ρ j)) (hmom : ∀ δ > 0, ∀ᶠ n in admissibleSizes μ, ∫⁻ ω, (ω.2.1 + ω.2.2.length : ℝ≥0∞) ∂ρ (k n) ≤ ENNReal.ofReal (n ^ δ)) : StructuralMicroscopic μ a G k (fun n => max 1 ⌊(n:ℝ) ^ (1 - η)⌋₊)`
   (only RV lemmas `tendsto_mul_div_floor_rpow`, `tendsto_div_floor_rpow`; startable now).
2. L3.3 `microscopic_of_tail (hM : IsCutoff M) (hpos : ∀ᶠ n in admissibleSizes μ, 0 < markProb μ G k n) (h : Tendsto (fun n => a n * (cond (bienayme μ) {T | G (k n) T}).real {T | M n < T.vertexCount}) (admissibleSizes μ) (𝓝 0)) : Microscopic μ G k M`.
3. L3.6 (i) `Tendsto (fun n => (cond (bienayme μ) {T | G (k n) T}).real {T | (M n : ℝ) / 4 < T.vertexCount}) (admissibleSizes μ) (𝓝 0)`;
   (ii) numerator form, uniform in the endpoint and in a time shift `j ≤ 1`:
   `∀ ε > 0, ∀ᶠ n in admissibleSizes μ, ∀ j ≤ 1, ∀ e : PlaneTree → ℤ, a n * ∫ T, {T | (M n : ℝ)/4 < T.vertexCount}.indicator (fun T => walkProb μ ((n:ℤ) - j - T.vertexCount) (e T)) T ∂ cond (bienayme μ) {T | G (k n) T} ≤ ε`;
   hypotheses `IsCutoff M`, `StructuralMicroscopic μ a G k M`.
4. C3.7 (i) `Microscopic μ G k M`; (ii) `IsEquivalent (admissibleSizes μ) (fun n => ∫ T, (markCount (G (k n)) T : ℝ) ∂ conditioned μ n) (fun n => n * markProb μ G k n)`;
   (iii) `(markProb μ G k) =O[admissibleSizes μ] (fun n => 1 / (n:ℝ)) → Tendsto (fun n => (conditioned μ n).real {T | G (k n) T}) (admissibleSizes μ) (𝓝 0)`.
5. L5.1(iii) `StructuralMicroscopic μ a G k M → IsCutoff M → 0 < cB μ B → cB μ B < ∞ → Microscopic μ (fun j => declumpedMark B (G j)) k M`
   (uses `RootDeclumping.bB_mul_le_declumped`, `parent_formula`, WP2b, L3.6(ii) with `j = 1`).

### WP4 — Indicators, the cyclic representation, and the two-start bound (no toolkit)

Files: `Bridge/Indicators.lean`, `Bridge/PairBound.lean`. Source: 740–764 (D2.1, L2.2),
1692–1695, 1720–1728, 1753–1760, 1781–1785, 1832–1845; B04, B05, P09, P11.

Definitions (fix these names first; WP5–WP7 use them):
* `firstMark (G : PlaneTree → Prop) (M : ℕ) (x : List ℤ) : Prop := ∃ T, PlaneTree.ofSeq x = some T ∧ T.vertexCount ≤ M ∧ G T` ($I_1^{(M)}$);
* `cycMark G M (ω : Fin n → ℤ) (i : Fin n) : Prop := firstMark G M ((List.ofFn ω).rotate i)` ($I_{i+1}^{(M)}$);
* `truncCount G M ω : ℕ := ∑ i, Set.indicator {i | cycMark G M ω i} 1 i` ($W^M_n$);
* `qProb μ G M n := (bridgeLaw μ n).real {ω | cycMark G M ω ⟨0, _⟩}` (or via `firstMark` on `List.ofFn ω`), `pProb μ G M := (walkVecLaw μ M).real {ω | firstMark G M (List.ofFn ω)}`;
* `cycDist n i j := min (|i - j|) (n - |i - j|)`, neighbourhood `{j | cycDist n i j < M}`.

Targets:
1. Locality: `firstMark G M x ↔ firstMark G M (x.take M)`; monotone in `M`; `firstMark G M x → firstMark G ⊤-version` (`I^{(M)} ≤ I^{(∞)}`).
2. `truncCount G M (toVec n (T.dfsSeq.rotate i)) = #{u : fringe subtree of T, size ≤ M, G}` for `T.vertexCount = n`; equals `markCount G T` when `n ≤ M`.
3. L2.2: `1 ≤ n → markedCountLaw μ G k n = (bridgeLaw μ n).map (truncCount (G (k n)) n)`, and the truncated analogue.
4. `qProb μ G M n = (uniformFringeLaw μ n).real {T | G T ∧ T.vertexCount ≤ M}` (1695, 1781) and every `cycMark i` has bridge probability `qProb` (exchangeability, WP1.6).
5. P09: `∫ ω, ((truncCount G n ω : ℝ) - truncCount G M ω) ∂ bridgeLaw μ n = n * (uniformFringeLaw μ n).real {T | G T ∧ M < T.vertexCount}` and `truncCount G M ≤ truncCount G n`.
6. Strong Markov at $\zeta$ (1753–1760): `pProb μ G M = (bienayme μ).real {T | G T ∧ T.vertexCount ≤ M}` (so `pProb ≤ markProb`) and
   `(walkVecLaw μ M).real {ω | firstMark G M (List.ofFn ω) ∧ r < |∑ ω|} ≤ ∑ j ∈ Finset.Icc 1 M, (bienayme μ).real {T | G T ∧ T.vertexCount = j} * (walkLaw μ (M - j)).real {x | r - 1 < |x|}`.
7. P11 (L4.7, audit finding 5): for `1 ≤ ℓ`, `ℓ + M ≤ N`:
   `(walkVecLaw μ N).real {ω | cycMark-at-0 ∧ cycMark-at-ℓ (non-cyclic, first N entries)} ≤ markProb μ G k n ^ 2 + pairProb μ G k n ℓ`, proved by conditioning on `ζ = j ≤ ℓ` (fresh increments), not by unconditional independence.

### WP5 — Bridge removal, truncation, $b_1$, $b_2$

Files: `Bridge/BridgeRemoval.lean` (L4.2, C4.3), `Bridge/Truncation.lean` (L4.4, L4.5),
`Bridge/ErrorTerms.lean` (P4.6, L4.7). Source: 1631–1696, 1732–1857; P08–P11.

1. L4.2 (corrected for compatible endpoints, F1): `∃ C > 0, ∀ {N m : ℕ → ℕ} {z : ℕ → ℝ}, Tendsto N atTop atTop → (m n : ℝ) =o (N n : ℝ) → z =o (a ∘ N) → ∀ᶠ n in atTop, ∀ k : ℤ, |(k:ℝ)| ≤ z n → walkProb μ (N n) k ≠ 0 → ∀ H : List ℤ → Prop, (cond (walkVecLaw μ (N n)) {ω | ∑ i, ω i = k}).real {ω | H ((List.ofFn ω).take (m n))} ≤ C * (walkVecLaw μ (m n)).real {ω | H (List.ofFn ω)}`.
   $C$ depends only on `hT` (stronger than the paper's "independent of $n$ and $H$"). Tools: WP1.5,
   `eventually_bounds`, `exists_le_div_of_le_two_mul`.
2. C4.3: `IsCutoff M → ∃ C, ∀ n, 1 ≤ n → Admissible μ n → qProb μ (G (k n)) (M n) n ≤ C * markProb μ G k n` (all admissible `n`, F5).
3. L4.4: under `Microscopic μ G k M` and bounded `n * markProb`: (i) `paperTVDist ((bridgeLaw μ n).map (truncCount (G (k n)) (M n))) ((bridgeLaw μ n).map (truncCount (G (k n)) n)) → 0`; (ii) `n * qProb - n * markProb → 0` along `admissibleSizes μ`.
4. L4.5 with `r n = √(a (M n) * a n)`: (i) `(fun n => (walkVecLaw μ (M n)).real {ω | firstMark (G (k n)) (M n) (List.ofFn ω) ∧ r n < |∑ ω|}) =o[admissibleSizes μ] (fun n => pProb …)`; (ii) `IsEquivalent (admissibleSizes μ) pProb qProb` and `IsEquivalent (admissibleSizes μ) qProb (markProb μ G k)` (Microscopic only).
5. P4.6: `Tendsto (fun n => (n : ℝ) * (2 * M n) * qProb … ^ 2) (admissibleSizes μ) (𝓝 0)` (bounded mean).
6. L4.7: under `NonClustering μ G k M` and bounded mean, `b₂ n := ∑ i, ∑ j ∈ nbhd i \ {i}, (bridgeLaw μ n).real {cycMark i ∧ cycMark j} → 0`.

### WP6 — Endpoint smoothing: Lemma `lem:1` (L4.9) and $b_3$ (P4.8)

File: `Bridge/EndpointSmoothing.lean`. Source: 1860–1995; P12, B14.

1. Block reduction (1877, 1881–1884): `b₃ n = n * |∫ (1_{cycMark 0} - q) * h n (S_{M n}) ∂ bridgeLaw μ n|`, where
   `h n k := ∫ ω, f n (1 + ∑_{j ≤ n - 2 M n} 1_{firstMark at j}) ∂ cond (walkVecLaw μ (n - M n)) {∑ = -1 - k}` (for compatible `k`);
   the identity holds after subtracting **any constant** `h n κ` (F2).
2. eq:approx1: `∃ C, ∀ ε ∈ (0,1), limsup_n sup_{compatible |k| ≤ r n} |h^ε n k - h n k| ≤ C * ε` (via L4.2 with `N n = n - M n`, `z n = 1 + r n`, and L4.5(ii)).
3. eq:approx3 (corrected, F2/F7): `∀ ε ∈ (0,1), sup over k, k' with |k|, |k'| ≤ r n, walkProb μ (n - M n) (-1 - k) ≠ 0 ≠ walkProb μ (n - M n) (-1 - k') of |h^ε n k - h^ε n k'| → 0`;
   proof by the deterministic bound
   $\lvert\Psi_t(y-k)/\Psi_{n-M}(-1-k)-\Psi_t(y-k')/\Psi_{n-M}(-1-k')\rvert\le \lvert\Psi_t(y-k)-\Psi_t(y-k')\rvert/\Psi_{n-M}(-1-k)+\Psi_t(y-k')\,\lvert\Psi_{n-M}(-1-k)^{-1}-\Psi_{n-M}(-1-k')^{-1}\rvert$,
   $t=\lfloor\varepsilon n\rfloor$, using `lattice.equicont` at time `t` ($\lvert k-k'\rvert\le2r_n=o(a_t)$),
   `eventually_abs_mul_sub_le` (`N := id`, `m := M`, `z := 1 + r`) and `sup_le`; no Skorokhod.
4. L4.9 (`n E[(I₁ - q) Δ_n(S_{M_n}) | S_n = -1] → 0`, with compatible base point) and P4.8:
   `∀ f : ℕ → ℕ → ℝ, (∀ n w, |f n w| ≤ 1) → bounded mean → Microscopic → b₃ n → 0` along `admissibleSizes μ`.

### WP7 — Boundary cases and the main assembly

Files: `Bridge/ExtremeMeans.lean` (L4.10), `Bridge/MainTheorems.lean` (T1.1, T1.2, C3.1).
Source: 1997–2144, 2303–2330, 924–969; P13, P14.

1. L4.10 (i) `n * markProb → 0 ⇒ (bridgeLaw μ n).real {1 ≤ truncCount (G (k n)) (M n)} → 0`;
   (ii) with `NonClustering`, `n * markProb → ∞ ⇒ ∀ ε > 0, (bridgeLaw μ n).real {ε < |truncCount / (n * markProb) - 1|} → 0`
   (separated pairs: WP1.5 two-block form + ratio limit at `N n = n`, `j = 2 M n`).
2. `poissonApproximation_of_toolkit (hT : StableToolkit μ α a) (G k M) (hM : IsCutoff M) (hMic : Microscopic μ G k M) (hC : NonClustering μ G k M) :` the two conclusions of `PoissonApproximationStatement` verbatim
   (AGG via `ChenStein.prop_AGG`, `paperTVDist_poissonMeasure_le_abs_sub`, L2.2).
3. `poissonApproximation2_of_toolkit (hT) (hM : IsCutoff M) (hB0 : 0 < cB μ B) (hB1 : cB μ B < ∞) (hS : StructuralMicroscopic μ a G k M) (hC : NonClustering μ (fun j => declumpedMark B (G j)) k M) :` the conclusions of `PoissonApproximation2Statement`
   (WP3.5 + `RootDeclumping.root_declumping_bounded/divergent` + item 2).
4. Final (once the stable export exists): `PoissonApproximationStatement`, `PoissonApproximation2Statement`.
5. Optional consumer: C3.1 (fringe corollary), using `eventually_abs_div_sub_one_le` with `x = 0`.

Further consumers (not in these packages; they use the toolkit only through L3.4, C3.7, T1.1,
T1.2): C3.8, P3.9, L6.2, L7.3, T1.3, T1.4.

---

## (c) Gaps, aperiodic notation, corrections

| # | Where | Issue | Resolution adopted in this plan |
| --- | --- | --- | --- |
| F1 | L4.2, 1633–1648 | $\sup_{\lvert k\rvert\le z_n}E[\,\cdot\mid S_n=k]$ quantifies over zero-probability endpoints in the periodic case; "$\Psi_n(k)\ge c/a_n$ for every $n\ge1$" is false (periodic, and small $n$) | sup over `walkProb μ n k ≠ 0`; "for $n$ large"; one constant from `hT` |
| F2 | L4.9, 1873, 1927, 1935 | $\Delta_n(k)=h_n(k)-h_n(0)$: $h_n(0)$ conditions on $S_{n-M_n}=-1$, which has probability zero unless $d\mid M_n$ (for admissible $n$). Genuine periodic gap | subtract a compatible base value (any constant works in $b_3$); prove the **oscillation** over compatible pairs $k,k'$ tends to $0$ |
| F3 | L3.5(ii) 1127–1132; L3.6 1236–1245; L5.1(iii) 2259, 2286–2287 | "$\Psi_{n-c}(-1)\sim\Psi_n(-1)$ uniformly for $c\le M_n/8$" and "replace $n$ by $n-1$": in the periodic case $\Psi_{n-c}(-1)=0$ when $d\nmid c$ (resp. always for $n-1$ if $d\ge2$), so L3.5(ii) "applied with $n-c$" divides by $0$ | state L3.5(ii) and L3.6(ii) in **numerator form** ($\le C\ell/(a_ma_N)$ for all $N\ge2m$; uniform in endpoint and in a shift $j\le1$), divide by $\Psi_n(-1)\ge c/a_n$ only at the end |
| F4 | 965, 1033, 1293, 1752, 2067, 2293 | "$\Psi_{n-m}(0)/\Psi_n(-1)\to1$ uniformly for $m\le M_n$" is false at incompatible $m$ (ratio $0$) | uniformity only over compatible points (TF5); compatibility holds automatically: $P(\lvert\mathcal T\rvert=m)>0\Rightarrow d\mid m-1$, $S_M\equiv-M$; needs `support` |
| F5 | C4.3, 1653 | "for every $n\ge1$": only admissible $n$ make sense | all admissible $n$, constant via `exists_lower_bound_neg_one` |
| F6 | L4.5 1763–1770, L4.9 1912 | uses functional ($J_1$) tightness / convergence in law | departure: only marginal uniform tightness (`tight`) is needed; B07 functional limit not required |
| F7 | P12 1987–1994 (B14) | Skorokhod representation + dominated convergence | departure: deterministic uniform bound from `equicont`, `origin`, `sup_le` (stronger, simpler) |
| F8 | T1.3(ii), 2853–2855 (R1) | cites C3.8(ii), whose uniform pair hypothesis is not established | cite T1.1(ii) with (M) from C3.7(i) and (C) from L6.2(ii) |
| F9 | L6.2(ii), 2670–2753 (P19) | proves only the **summed** pair bound $\sum_{\ell\le M_n}A_n(\ell)\le C\pi+M_n\pi^2$ (this is why F8 is needed). The forest part (2737–2743) needs explicit DFS bookkeeping (forest vertices among the first $M_n+1$ positions of $T$ are among the first $M_n$ forest positions) and fresh-increment conditioning for the fringe law at a fixed forest position. Section 6 indexes $\pi_k$ by level, Sections 3–4 by size ($\pi_n=\pi_{k_n}$) | no mathematical error found; formalize the bookkeeping explicitly |
| F10 | L4.7, 1835–1845 (audit finding 5) | "two independent Bienaymé trees" on $\{v_{1+\ell}\notin\mathcal T\}$, an event depending on $\lvert\mathcal T\rvert$ | condition on $\zeta=j\le\ell$ (WP4.7) |
| F11 | L3.4, L6.2, L7.3, T1.3, T1.4 | $M_n=\lfloor n^{1-\eta}\rfloor$ gives $M_0=0$, violating `IsCutoff.pos` ($\forall n,\ 0<M_n$) | use `fun n => max 1 ⌊(n:ℝ)^(1-η)⌋₊` (equal for $n\ge1$) — coordinator decision |
| F12 | L3.5, 1121–1149 | the role of $n$ is implicit (first bound independent of $n$; second needs $\Psi_n(-1)>0$); forest Dwass/Kemperman is cited, not proved, and is absent from the project (only one-tree Dwass exists) | WP2a proves Kemperman via a generalized cycle lemma |
| F13 | C3.7(iii) 1321–1364; L3.6/C3.7 "we may assume $\pi_n>0$" 1279 | empty forest ($\ell=0$) and $\pi_n=0$ indices must be handled explicitly | `cond` of a null event is $0$; `IsEquivalent` handles zeros; guard every division by $\pi_n$ |
| F14 | sections 2.4, 3, 4, 5 (844, 908, 1550, 2193) | proofs written for aperiodic $\mu$; periodic extension (867–883) asserted, not proved | F1–F5 are the only places needing changes; all other steps go through verbatim along admissible $n$ |
| F15 | L4.10(ii) 2024; P4.8 1881 | $\mu_n=nq_n$ clashes with the offspring law $\mu$; block independence needs $P(S_{M_n}=k,S_n=-1)>0$ | cosmetic; compatible $k$ only |

## Shared-file actions for the coordinator

1. Add `public import PoissonDeclumping.Setup.Toolkit` to `PoissonDeclumping.lean`.
2. The instance `isProbabilityMeasure_walkLaw` now lives in `Setup/Toolkit.lean`; WP1 must not
   redeclare it.
3. Decide F11 (`max 1 ⌊n^{1-η}⌋₊` in statements, or relax `IsCutoff.pos`).
4. Tell the stable-toolbox worker the exact export target:
   `theorem stableToolkit_of_stableDomain : StableDomain μ α a → StableToolkit μ α a`.
