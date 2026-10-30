module

public import PoissonDeclumping.MainTheorems
public import PoissonDeclumping.Probability.PoissonTV

import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

/-!
# Raw unary counts fail Poisson approximation

The asserted counterexample at source lines 373–379 and 1424–1430 (inventory U02).
For a critical nondegenerate offspring law in the stable domain, let `q = μ₁ > 0`.
Along any admissible sizes `n_j → ∞` and integer levels `k_j` such that
`n_j q^{k_j} → λ > 0`, the raw unary count has zero probability tending to
`exp (-(1-q) λ)`, which differs from the Poisson zero probability `exp (-λ)`.
Its total variation distance from `Po(λ)` consequently stays bounded away from zero.

The subsequence formulation matters: the lattice need not permit a positive limit
for `n q^{k_n}` along all sizes. The proof derives the zero event directly from the
already proved unary maximum theorem; no new clustering estimate is assumed.
-/

@[expose] public section

open MeasureTheory ProbabilityTheory Filter
open scoped Topology NNReal

namespace PoissonDeclumping.DirectApplications

open PlaneTree

/-- A positive finite unary mean fixes the centering relative to the integer level. -/
theorem unary_center_sub_level_tendsto {q lam : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    (hlam : 0 < lam) {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hmean : Tendsto (fun j => (n j : ℝ) * q ^ k j) atTop (𝓝 lam)) :
    Tendsto (fun j => tStar q (n j) - k j) atTop
      (𝓝 ((Real.log lam + Real.log (1 - q)) / Real.log (1 / q))) := by
  have hL : Real.log (1 / q) ≠ 0 :=
    (Real.log_pos (by rw [lt_div_iff₀ hq0]; linarith)).ne'
  have hlog : Real.log (1 / q) = -Real.log q := by rw [one_div, Real.log_inv]
  have h := ((hmean.log hlam.ne').add_const (Real.log (1 - q))).div_const
    (Real.log (1 / q))
  refine h.congr' ?_
  filter_upwards [hn.eventually (eventually_gt_atTop 0)] with j hj
  have hn0 : (n j : ℝ) ≠ 0 := by positivity
  rw [Real.log_mul hn0 (pow_pos hq0 _).ne', Real.log_pow, tStar]
  field_simp [hL]
  rw [hlog]
  ring

/-- The actual zero-count limit for raw complete unary non-fringe occurrences. -/
theorem unary_raw_zero_tendsto {μ : PMF ℕ} (hμ : InStableDomain μ) (hμ1 : 0 < μ 1)
    {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hadm : ∀ᶠ j in atTop, Admissible μ (n j)) {lam : ℝ} (hlam : 0 < lam)
    (hmean : Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ k j) atTop (𝓝 lam)) :
    Tendsto (fun j => (conditioned μ (n j)).real
      {T | markCount (Embeds (completeTree 1 (k j))) T = 0}) atTop
      (𝓝 (Real.exp (-((1 - (μ 1).toReal) * lam)))) := by
  obtain ⟨α, a, hSD⟩ := id hμ
  obtain ⟨hq0, hq1⟩ := Extremes.pmf_toReal_mem_Ioo hμ1 hSD.nondegenerate
  set q : ℝ := (μ 1).toReal
  set b : ℝ := (Real.log lam + Real.log (1 - q)) / Real.log (1 / q)
  set t : ℝ := -b - 1 / 2
  have hc := (unary_center_sub_level_tendsto hq0 hq1 hlam hn hmean).add_const t
  have hc' : Tendsto (fun j => tStar q (n j) + t - k j) atTop (𝓝 (-(1 / 2 : ℝ))) := by
    have hc0 : Tendsto (fun j => tStar q (n j) - k j + t) atTop (𝓝 (b + t)) := hc
    have hlim : b + t = -(1 / 2 : ℝ) := by dsimp [t]; ring
    rw [hlim] at hc0
    exact hc0.congr fun j => by ring
  have hfloor : ∀ᶠ j in atTop, ⌊tStar q (n j) + t⌋ = (k j : ℤ) - 1 := by
    have hI := hc'.eventually (Ioo_mem_nhds (show (-1 : ℝ) < -(1 / 2 : ℝ) by norm_num)
      (show -(1 / 2 : ℝ) < 0 by norm_num))
    filter_upwards [hI] with j hj
    apply Int.floor_eq_iff.mpr
    push_cast
    constructor <;> linarith [hj.1, hj.2]
  have hnadm : Tendsto n atTop (admissibleSizes μ) :=
    tendsto_inf.mpr ⟨hn, tendsto_principal.mpr hadm⟩
  have hg := ((maxString μ hμ).1 hμ1 t).comp hnadm
  have heq : ∀ᶠ j in atTop,
      (conditioned μ (n j)).real
          {T | ((maxCompleteHeight 1 T : ℕ) : ℤ) ≤ ⌊tStar q (n j) + t⌋} -
        Real.exp (-(q ^ (t + 1 - Int.fract (tStar q (n j) + t)))) =
      (conditioned μ (n j)).real {T | markCount (Embeds (completeTree 1 (k j))) T = 0} -
        Real.exp (-((1 - q) * ((n j : ℝ) * q ^ k j))) := by
    filter_upwards [hfloor, hn.eventually (eventually_gt_atTop 0)] with j hj hnj
    rw [Extremes.setOf_natCast_le_eq le_rfl, hj]
    simp only [sub_add_cancel, Int.toNat_natCast]
    have hid := ExtremesAnalysis.tStar_identity hq0 hq1 hnj t
    rw [hj, sub_add_cancel, zpow_natCast] at hid
    rw [← hid]
    congr 2
    ring
  have herr : Tendsto (fun j =>
      (conditioned μ (n j)).real {T | markCount (Embeds (completeTree 1 (k j))) T = 0} -
        Real.exp (-((1 - q) * ((n j : ℝ) * q ^ k j)))) atTop (𝓝 0) :=
    hg.congr' heq
  have hexp := ((hmean.const_mul (1 - q)).neg).rexp
  have h := herr.add hexp
  simpa only [zero_add, sub_add_cancel] using h

/-- The zero-count limit is different from the zero mass of `Po(λ)` whenever `q, λ > 0`.
This is the elementary obstruction to the asserted raw Poisson limit. -/
theorem unary_raw_zero_not_tendsto_poisson {μ : PMF ℕ} (hμ : InStableDomain μ)
    (hμ1 : 0 < μ 1) {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hadm : ∀ᶠ j in atTop, Admissible μ (n j)) {lam : ℝ} (hlam : 0 < lam)
    (hmean : Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ k j) atTop (𝓝 lam)) :
    ¬ Tendsto (fun j => (conditioned μ (n j)).real
      {T | markCount (Embeds (completeTree 1 (k j))) T = 0}) atTop
      (𝓝 (Real.exp (-lam))) := by
  intro h
  have heq := tendsto_nhds_unique (unary_raw_zero_tendsto hμ hμ1 hn hadm hlam hmean) h
  have hq0 : 0 < (μ 1).toReal := ENNReal.toReal_pos hμ1.ne' (PMF.apply_ne_top μ 1)
  have hlt : Real.exp (-lam) < Real.exp (-((1 - (μ 1).toReal) * lam)) := by
    apply Real.exp_lt_exp.mpr
    nlinarith
  exact hlt.ne' heq

/-- Raw unary counts stay a positive total-variation distance away from `Po(λ)`.
The bound is half the positive difference between the two limiting zero probabilities. -/
theorem unary_raw_eventually_tv_pos {μ : PMF ℕ} (hμ : InStableDomain μ) (hμ1 : 0 < μ 1)
    {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hadm : ∀ᶠ j in atTop, Admissible μ (n j)) {lam : ℝ} (hlam : 0 < lam)
    (hmean : Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ k j) atTop (𝓝 lam)) :
    ∃ ε : ℝ, 0 < ε ∧ ∀ᶠ j in atTop, ε ≤
      paperTVDist ((conditioned μ (n j)).map (markCount (Embeds (completeTree 1 (k j)))))
        (poissonMeasure (Real.toNNReal lam)) := by
  have hq0 : 0 < (μ 1).toReal := ENNReal.toReal_pos hμ1.ne' (PMF.apply_ne_top μ 1)
  set d : ℝ := Real.exp (-((1 - (μ 1).toReal) * lam)) - Real.exp (-lam)
  have hd : 0 < d := by
    apply sub_pos.mpr
    apply Real.exp_lt_exp.mpr
    nlinarith
  have hgap := (unary_raw_zero_tendsto hμ hμ1 hn hadm hlam hmean).sub_const (Real.exp (-lam))
  refine ⟨d / 2, by positivity, ?_⟩
  have hlarge := hgap.eventually (lt_mem_nhds (show d / 2 < d by linarith))
  filter_upwards [hlarge, hadm] with j hj hnj
  have := conditioned_isProbabilityMeasure hnj
  have hb := abs_measureReal_zero_sub_exp_le_paperTVDist
    ((conditioned μ (n j)).map (markCount (Embeds (completeTree 1 (k j)))))
    (Real.toNNReal lam)
  rw [map_measureReal_apply (Measurable.of_discrete) (measurableSet_singleton 0),
    Real.coe_toNNReal _ hlam.le] at hb
  have hab := le_abs_self ((conditioned μ (n j)).real
    {T | markCount (Embeds (completeTree 1 (k j))) T = 0} - Real.exp (-lam))
  exact hj.le.trans (hab.trans hb)

/-- In particular, the raw complete-unary count has no Poisson total-variation limit at
the raw mean, as asserted in the Introduction. -/
theorem unary_raw_not_tendsto_poisson {μ : PMF ℕ} (hμ : InStableDomain μ) (hμ1 : 0 < μ 1)
    {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hadm : ∀ᶠ j in atTop, Admissible μ (n j)) {lam : ℝ} (hlam : 0 < lam)
    (hmean : Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ k j) atTop (𝓝 lam)) :
    ¬ Tendsto (fun j =>
      paperTVDist ((conditioned μ (n j)).map (markCount (Embeds (completeTree 1 (k j)))))
        (poissonMeasure (Real.toNNReal lam))) atTop (𝓝 0) := by
  obtain ⟨ε, hε, hevent⟩ := unary_raw_eventually_tv_pos hμ hμ1 hn hadm hlam hmean
  intro h
  obtain ⟨j, hj, hj'⟩ := (hevent.and (h.eventually (gt_mem_nhds hε))).exists
  exact (not_lt_of_ge hj) hj'

/-- Replacing the limiting parameter by the actual raw mean does not rescue the Poisson
approximation. This is the direct obstruction to using Theorem 1.1 for unary marks. -/
theorem unary_raw_not_tendsto_poisson_mean {μ : PMF ℕ} (hμ : InStableDomain μ)
    (hμ1 : 0 < μ 1) {n k : ℕ → ℕ} (hn : Tendsto n atTop atTop)
    (hadm : ∀ᶠ j in atTop, Admissible μ (n j)) {lam : ℝ} (hlam : 0 < lam)
    (hmean : Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ k j) atTop (𝓝 lam)) :
    ¬ Tendsto (fun j =>
      paperTVDist ((conditioned μ (n j)).map (markCount (Embeds (completeTree 1 (k j)))))
        (poissonMeasure (Real.toNNReal ((n j : ℝ) * (μ 1).toReal ^ k j))))
      atTop (𝓝 0) := by
  intro h
  apply unary_raw_not_tendsto_poisson hμ hμ1 hn hadm hlam hmean
  refine tendsto_paperTVDist_poissonMeasure_congr _ h ?_
  have h := hmean.sub_const lam
  rw [sub_self] at h
  refine h.congr fun j => ?_
  rw [Real.coe_toNNReal _ (by positivity), Real.coe_toNNReal _ hlam.le]

/-- An explicit sequence realizing the positive-mean regime: the ceiling of `q^{-j}` has
`n_j q^j → 1`. This also proves the unary counterexample's hypotheses are realizable. -/
theorem unary_counterexample_exists {μ : PMF ℕ} (hμ : InStableDomain μ) (hμ1 : 0 < μ 1) :
    ∃ n : ℕ → ℕ, Tendsto n atTop atTop ∧ (∀ j, Admissible μ (n j)) ∧
      Tendsto (fun j => (n j : ℝ) * (μ 1).toReal ^ j) atTop (𝓝 1) ∧
      ¬ Tendsto (fun j =>
        paperTVDist ((conditioned μ (n j)).map (markCount (Embeds (completeTree 1 j))))
          (poissonMeasure 1)) atTop (𝓝 0) := by
  obtain ⟨α, a, hSD⟩ := id hμ
  obtain ⟨hq0, hq1⟩ := Extremes.pmf_toReal_mem_Ioo hμ1 hSD.nondegenerate
  set q : ℝ := (μ 1).toReal
  have hpow : Tendsto (fun j : ℕ => q⁻¹ ^ j) atTop atTop :=
    tendsto_pow_atTop_atTop_of_one_lt ((one_lt_inv₀ hq0).mpr hq1)
  set n : ℕ → ℕ := fun j => ⌈q⁻¹ ^ j⌉₊
  have hn : Tendsto n atTop atTop := tendsto_nat_ceil_atTop.comp hpow
  have hmean : Tendsto (fun j => (n j : ℝ) * q ^ j) atTop (𝓝 1) := by
    simpa only [n, Function.comp_def, div_eq_mul_inv, inv_pow, inv_inv] using
      (tendsto_nat_ceil_div_atTop (R := ℝ)).comp hpow
  have hadm : ∀ j, Admissible μ (n j) := by
    intro j
    have hn1 : 1 ≤ n j := Nat.one_le_ceil_iff.mpr (pow_pos (inv_pos.mpr hq0) j)
    have := admissible_mul_add_one (hSD.critical.apply_zero_ne_zero hSD.nondegenerate)
      (j := 1) le_rfl hμ1.ne' (n j - 1)
    simpa only [mul_one, Nat.sub_add_cancel hn1] using this
  refine ⟨n, hn, hadm, hmean, ?_⟩
  simpa only [Real.toNNReal_one] using unary_raw_not_tendsto_poisson hμ hμ1 hn
    (Eventually.of_forall hadm) (show (0 : ℝ) < 1 by norm_num) hmean

end PoissonDeclumping.DirectApplications
