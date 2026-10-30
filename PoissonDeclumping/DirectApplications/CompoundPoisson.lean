module

public import PoissonDeclumping.LeafHeight.Consequences
public import PoissonDeclumping.LeafHeight.Tree
public import Mathlib.Probability.Distributions.Poisson.Basic
public import Mathlib.MeasureTheory.Group.Convolution
public import Mathlib.Analysis.SpecificLimits.Normed

/-!
# The compound Poisson calculation of the perspectives (inventory U12)

Source lines 3439–3471 (inventory Q02, U12). For `p ∈ [0, 1)`, `γ_p` is the geometric law on
`{1, 2, …}`, `γ_p(j) = (1 - p) p^{j-1}`, and `CP(ν, γ)` is the law of `∑_{i=1}^P J_i` with `P`
Poisson of parameter `ν` and, given `P`, i.i.d. jumps `J_i ~ γ`. The paper *conjectures*
(Q02) that the exceedance count `Λ_n^≥` is close to `CP(n ℓ_{k_n}, γ_{μ_1})`; this conjecture is
**not** formalized. Only the separately asserted calculation (U12) is proved:

* `geomPos p` is a probability measure on `ℕ` carried by `{1, 2, …}`
  (`isProbabilityMeasure_geomPos`, `geomPos_singleton_zero`) with mean `1 / (1 - p)`
  (`lintegral_geomPos`);
* `compoundPoisson ν γ = ∑_m P(P = m) γ^{*m}` (the law of the random sum, as a Poisson mixture of
  convolution powers) is a probability measure (`isProbabilityMeasure_compoundPoisson`) with mean
  `ν E[γ]` (`lintegral_compoundPoisson`), hence `CP(ν, γ_p)` has mean `ν / (1 - p)`
  (`lintegral_compoundPoisson_geomPos`);
* **U12** (`compoundPoisson_leafHeight_mean`, `mean_isEquivalent_leafHeight`): the mean of
  `CP(n ℓ_{k_n}, γ_{μ_1})` is `n ℓ_{k_n} / (1 - μ_1)`, and `n ℓ_{k_n} / (1 - μ_1) ∼ n π_{k_n}`
  when `k_n → ∞`, where `π_k = P(λ_∅(𝒯) ≥ k)` and `ℓ_k = P(λ_∅(𝒯) = k)` (for every critical `μ`
  with `μ_1 ≠ 1`; the paper uses it for `μ_1 > 0`).

U13 (source lines 3473–3491: for `μ_1 = 0` and bounded `n π_{k_n}`, `n π_{k_n + 1} → 0`, i.e.
`n |π_{k_n} - ℓ_{k_n}| → 0`) is already proved as
`PoissonDeclumping.LeafHeight.tendsto_natCast_mul_piSeq_succ` (and
`tendsto_natCast_mul_piSeq_succ_of_ell`) in `LeafHeight/Consequences.lean`.
-/

@[expose] public section

open MeasureTheory Filter Asymptotics ProbabilityTheory
open scoped Topology ENNReal NNReal Nat

namespace PoissonDeclumping.DirectApplications

/-! ### The geometric law on the positive integers -/

/-- `γ_p(j) = (1 - p) p^{j-1}` for `j ≥ 1`, and `γ_p(0) = 0`. -/
noncomputable def geomPosMass (p : ℝ) (j : ℕ) : ℝ := if j = 0 then 0 else (1 - p) * p ^ (j - 1)

theorem geomPosMass_nonneg {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) (j : ℕ) :
    0 ≤ geomPosMass p j := by
  unfold geomPosMass
  split_ifs
  · exact le_rfl
  · exact mul_nonneg (by linarith) (pow_nonneg hp0 _)

theorem hasSum_geomPosMass {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) : HasSum (geomPosMass p) 1 := by
  rw [← hasSum_nat_add_iff' 1]
  have h := (hasSum_geometric_of_lt_one hp0 hp1).mul_left (1 - p)
  have hne : 1 - p ≠ 0 := by linarith
  convert h using 1
  · funext n
    simp [geomPosMass]
  · simp [geomPosMass, mul_inv_cancel₀ hne]

/-- The geometric law `γ_p` on `{1, 2, …}` (source lines 3455–3458). -/
noncomputable def geomPos (p : ℝ) : Measure ℕ :=
  Measure.sum fun j => ENNReal.ofReal (geomPosMass p j) • Measure.dirac j

theorem geomPos_singleton (p : ℝ) (j : ℕ) : geomPos p {j} = ENNReal.ofReal (geomPosMass p j) := by
  rw [geomPos, Measure.sum_smul_dirac_singleton]

/-- `γ_p` is carried by the positive integers. -/
theorem geomPos_singleton_zero (p : ℝ) : geomPos p {0} = 0 := by
  rw [geomPos_singleton]
  simp [geomPosMass]

/-- `γ_p` is a probability measure for `p ∈ [0, 1)`. -/
theorem isProbabilityMeasure_geomPos {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) :
    IsProbabilityMeasure (geomPos p) :=
  (hasSum_geomPosMass hp0 hp1).isProbabilityMeasure_sum_dirac (geomPosMass_nonneg hp0 hp1)

theorem hasSum_geomPosMass_mul {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) :
    HasSum (fun j : ℕ => geomPosMass p j * j) (1 - p)⁻¹ := by
  rw [← hasSum_nat_add_iff' 1]
  have hnorm : ‖p‖ < 1 := by rwa [Real.norm_of_nonneg hp0]
  have h := ((hasSum_coe_mul_geometric_of_norm_lt_one hnorm).add
    (hasSum_geometric_of_lt_one hp0 hp1)).mul_left (1 - p)
  have hne : 1 - p ≠ 0 := by linarith
  convert h using 1
  · funext n
    simp only [geomPosMass, Nat.add_sub_cancel, Nat.cast_add, Nat.cast_one]
    rw [ite_eq_right (Nat.succ_ne_zero n)]
    ring
  · simp only [Finset.sum_range_one, geomPosMass, ite_true, Nat.cast_zero, mul_zero, sub_zero]
    field_simp
    ring

/-- `E[γ_p] = 1 / (1 - p)`. -/
theorem lintegral_geomPos {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) :
    ∫⁻ j, (j : ℝ≥0∞) ∂geomPos p = ENNReal.ofReal (1 - p)⁻¹ := by
  have h := hasSum_geomPosMass_mul hp0 hp1
  have hnn : ∀ j : ℕ, 0 ≤ geomPosMass p j * j := fun j =>
    mul_nonneg (geomPosMass_nonneg hp0 hp1 j) (Nat.cast_nonneg j)
  rw [geomPos, lintegral_sum_measure, ← h.tsum_eq, ENNReal.ofReal_tsum_of_nonneg hnn h.summable]
  refine tsum_congr fun j => ?_
  rw [lintegral_smul_measure, lintegral_dirac, smul_eq_mul,
    ENNReal.ofReal_mul (geomPosMass_nonneg hp0 hp1 j), ENNReal.ofReal_natCast]

/-! ### Convolution powers and the compound Poisson law -/

/-- The law `γ^{*m}` of `J_1 + ⋯ + J_m` for i.i.d. `J_i ~ γ`. -/
noncomputable def convPow (γ : Measure ℕ) : ℕ → Measure ℕ
  | 0 => Measure.dirac 0
  | m + 1 => convPow γ m ∗ γ

theorem isProbabilityMeasure_convPow (γ : Measure ℕ) [IsProbabilityMeasure γ] (m : ℕ) :
    IsProbabilityMeasure (convPow γ m) := by
  induction m with
  | zero => rw [convPow]; infer_instance
  | succ m ih => rw [convPow]; infer_instance

/-- `E[J_1 + ⋯ + J_m] = m E[J_1]`. -/
theorem lintegral_convPow (γ : Measure ℕ) [IsProbabilityMeasure γ] (m : ℕ) :
    ∫⁻ x, (x : ℝ≥0∞) ∂convPow γ m = m * ∫⁻ x, (x : ℝ≥0∞) ∂γ := by
  induction m with
  | zero => simp [convPow]
  | succ m ih =>
    have := isProbabilityMeasure_convPow γ m
    rw [convPow, Measure.lintegral_conv Measurable.of_discrete]
    have hin : ∀ x : ℕ, ∫⁻ y, ((x + y : ℕ) : ℝ≥0∞) ∂γ = x + ∫⁻ y, (y : ℝ≥0∞) ∂γ := by
      intro x
      simp only [Nat.cast_add]
      rw [lintegral_add_left measurable_const, lintegral_const, measure_univ, mul_one]
    simp only [hin]
    rw [lintegral_add_right _ measurable_const, lintegral_const, measure_univ, mul_one, ih]
    push_cast
    ring

/-- The compound Poisson law `CP(ν, γ)`: the law of `∑_{i=1}^P J_i`, `P ~ Po(ν)` and, given `P`,
i.i.d. `J_i ~ γ`, i.e. the Poisson mixture `∑_m P(P = m) γ^{*m}` (source lines 3458–3461). -/
noncomputable def compoundPoisson (ν : ℝ≥0) (γ : Measure ℕ) : Measure ℕ :=
  Measure.sum fun m => poissonMeasure ν {m} • convPow γ m

theorem tsum_poissonMeasure_singleton (ν : ℝ≥0) : ∑' m : ℕ, poissonMeasure ν {m} = 1 := by
  simp only [poissonMeasure_singleton]
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun _ => by positivity)
    (hasSum_one_poissonMeasure ν).summable, (hasSum_one_poissonMeasure ν).tsum_eq,
    ENNReal.ofReal_one]

/-- `CP(ν, γ)` is a probability measure ("well defined"). -/
theorem isProbabilityMeasure_compoundPoisson (ν : ℝ≥0) (γ : Measure ℕ)
    [IsProbabilityMeasure γ] : IsProbabilityMeasure (compoundPoisson ν γ) where
  measure_univ := by
    rw [compoundPoisson, Measure.sum_apply _ MeasurableSet.univ]
    simp only [Measure.smul_apply, smul_eq_mul]
    simp only [fun m => (isProbabilityMeasure_convPow γ m).measure_univ, mul_one]
    exact tsum_poissonMeasure_singleton ν

/-- The mean of the Poisson law: `∑_m m P(P = m) = ν`. -/
theorem hasSum_poisson_mean (ν : ℝ≥0) :
    HasSum (fun m : ℕ => Real.exp (-(ν : ℝ)) * (ν : ℝ) ^ m / (m ! : ℝ) * m) ν := by
  rw [← hasSum_nat_add_iff' 1]
  have h := (hasSum_one_poissonMeasure ν).mul_left (ν : ℝ)
  convert h using 1
  · funext n
    rw [Nat.factorial_succ]
    push_cast
    field_simp
    ring
  · simp

theorem lintegral_poissonMeasure_id (ν : ℝ≥0) :
    ∑' m : ℕ, poissonMeasure ν {m} * (m : ℝ≥0∞) = ENNReal.ofReal ν := by
  have h := hasSum_poisson_mean ν
  have hnn : ∀ m : ℕ, 0 ≤ Real.exp (-(ν : ℝ)) * (ν : ℝ) ^ m / (m ! : ℝ) * m := fun m => by
    positivity
  rw [← h.tsum_eq, ENNReal.ofReal_tsum_of_nonneg hnn h.summable]
  refine tsum_congr fun m => ?_
  rw [poissonMeasure_singleton, ENNReal.ofReal_mul (by positivity), ENNReal.ofReal_natCast]

/-- Wald's identity for the compound Poisson law: `E[CP(ν, γ)] = ν E[γ]`. -/
theorem lintegral_compoundPoisson (ν : ℝ≥0) (γ : Measure ℕ) [IsProbabilityMeasure γ] :
    ∫⁻ x, (x : ℝ≥0∞) ∂compoundPoisson ν γ = ENNReal.ofReal ν * ∫⁻ x, (x : ℝ≥0∞) ∂γ := by
  rw [compoundPoisson, lintegral_sum_measure]
  simp only [lintegral_smul_measure, smul_eq_mul, lintegral_convPow]
  simp only [← mul_assoc]
  rw [ENNReal.tsum_mul_right, lintegral_poissonMeasure_id]

/-- The mean of `CP(ν, γ_p)` is `ν / (1 - p)` (source lines 3463–3467). -/
theorem lintegral_compoundPoisson_geomPos (ν : ℝ≥0) {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p < 1) :
    ∫⁻ x, (x : ℝ≥0∞) ∂compoundPoisson ν (geomPos p) = ENNReal.ofReal (ν / (1 - p)) := by
  have := isProbabilityMeasure_geomPos hp0 hp1
  rw [lintegral_compoundPoisson, lintegral_geomPos hp0 hp1, ← ENNReal.ofReal_mul (NNReal.coe_nonneg ν),
    div_eq_mul_inv]

/-! ### U12 for the leaf-height counts -/

theorem toReal_mu_one_lt_one {μ : PMF ℕ} (h1 : μ 1 ≠ 1) : (μ 1).toReal < 1 := by
  have hle : μ 1 ≤ 1 := PMF.coe_le_one μ 1
  have hlt : μ 1 < 1 := lt_of_le_of_ne hle h1
  have := ENNReal.toReal_strict_mono ENNReal.one_ne_top hlt
  rwa [ENNReal.toReal_one] at this

/-- **U12, mean** (source lines 3463–3467): for `μ_1 ≠ 1`, the proposed compound Poisson law
`CP(n ℓ_{k_n}, γ_{μ_1})` (with `ℓ_k = P(λ_∅(𝒯) = k)`) is a probability measure with mean
`n ℓ_{k_n} / (1 - μ_1)`. -/
theorem compoundPoisson_leafHeight_mean {μ : PMF ℕ} (h1 : μ 1 ≠ 1) (k : ℕ → ℕ) (n : ℕ) :
    IsProbabilityMeasure (compoundPoisson
        (Real.toNNReal ((n : ℝ) * (PlaneTree.bienayme μ).real
          {T | T.rootLeafHeight = k n})) (geomPos (μ 1).toReal)) ∧
      ∫⁻ x, (x : ℝ≥0∞) ∂compoundPoisson
        (Real.toNNReal ((n : ℝ) * (PlaneTree.bienayme μ).real {T | T.rootLeafHeight = k n}))
        (geomPos (μ 1).toReal) =
      ENNReal.ofReal ((n : ℝ) * (PlaneTree.bienayme μ).real {T | T.rootLeafHeight = k n} /
        (1 - (μ 1).toReal)) := by
  have hp0 : 0 ≤ (μ 1).toReal := ENNReal.toReal_nonneg
  have hp1 := toReal_mu_one_lt_one h1
  have := isProbabilityMeasure_geomPos hp0 hp1
  refine ⟨isProbabilityMeasure_compoundPoisson _ _, ?_⟩
  rw [lintegral_compoundPoisson_geomPos _ hp0 hp1,
    Real.coe_toNNReal _ (mul_nonneg (Nat.cast_nonneg n) measureReal_nonneg)]

/-- **U12, asymptotics** (source lines 3463–3467): for critical `μ` with `μ_1 ≠ 1` and
`k_n → ∞`, `n ℓ_{k_n} / (1 - μ_1) ∼ n π_{k_n}`, where `π_k = P(λ_∅(𝒯) ≥ k)` and
`ℓ_k = P(λ_∅(𝒯) = k)`. -/
theorem mean_isEquivalent_leafHeight {μ : PMF ℕ} (hc : IsCritical μ) (h1 : μ 1 ≠ 1)
    {k : ℕ → ℕ} (hk : Tendsto k atTop atTop) :
    (fun n : ℕ => (n : ℝ) * (PlaneTree.bienayme μ).real {T | T.rootLeafHeight = k n} /
        (1 - (μ 1).toReal)) ~[atTop]
      (fun n : ℕ => (n : ℝ) * (PlaneTree.bienayme μ).real {T | k n ≤ T.rootLeafHeight}) := by
  have hq : 1 - (μ 1).toReal ≠ 0 := by linarith [toReal_mu_one_lt_one h1]
  have hell := (LeafHeight.ellSeq_isEquivalent_mul_piSeq hc h1).comp_tendsto hk
  have h := ((IsEquivalent.refl (u := fun n : ℕ => (n : ℝ) / (1 - (μ 1).toReal))).mul hell)
  refine (h.congr_left (Eventually.of_forall fun n => ?_)).congr_right
    (Eventually.of_forall fun n => ?_)
  · simp only [Pi.mul_apply, Function.comp_apply,
      LeafHeight.bienayme_real_rootLeafHeight_eq hc h1]
    ring
  · simp only [Pi.mul_apply, Function.comp_apply,
      LeafHeight.bienayme_real_le_rootLeafHeight hc h1, LeafHeight.mass]
    field_simp

end PoissonDeclumping.DirectApplications
