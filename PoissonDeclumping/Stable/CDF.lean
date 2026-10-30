module

public import PoissonDeclumping.Stable.DensityLaw
public import PoissonDeclumping.Stable.Normalization
public import PoissonDeclumping.Probability.Skorokhod
public import Mathlib.Probability.CDF
public import Mathlib.MeasureTheory.Measure.Portmanteau

/-!
# CDF bridges for the real-valued stable limit

The real-valued Skorokhod representation used at source lines 1987–1994 concerns
the actual marginal limit law. This module proves its atomlessness and CDF
continuity from the density already established in `Stable/DensityLaw`, and
the pointwise convergence of CDFs from weak convergence. These are semantic
bridges; they do not assume a coupling or almost-sure convergence.
-/

@[expose] public section

open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology

namespace PoissonDeclumping

/-- An atomless real probability law has a continuous cumulative distribution function. -/
theorem continuous_cdf_of_nullSingletonClass (ν : Measure ℝ)
    [IsProbabilityMeasure ν] [NullSingletonClass ν] : Continuous (cdf ν) := by
  apply continuous_iff_continuousAt.2
  intro x
  apply (cdf ν).mono.continuousAt_iff_leftLim_eq_rightLim.2
  rw [(cdf ν).rightLim_eq]
  have hzero : ENNReal.ofReal (cdf ν x - Function.leftLim (cdf ν) x) = 0 := by
    rw [← StieltjesFunction.measure_singleton, measure_cdf, measure_singleton]
  have hle : cdf ν x - Function.leftLim (cdf ν) x ≤ 0 :=
    ENNReal.ofReal_eq_zero.1 hzero
  exact le_antisymm ((cdf ν).mono.leftLim_le le_rfl) (by linarith)

/-- Weak convergence to an atomless real probability measure gives CDF convergence at every point. -/
theorem tendsto_cdf_of_weak_of_nullSingletonClass {ι : Type*} {l : Filter ι}
    {P : ι → ProbabilityMeasure ℝ} {ν : ProbabilityMeasure ℝ}
    [NullSingletonClass (ν : Measure ℝ)] (hP : Tendsto P l (𝓝 ν)) (x : ℝ) :
    Tendsto (fun i => cdf (P i : Measure ℝ) x) l (𝓝 (cdf (ν : Measure ℝ) x)) := by
  have hfront : (ν : Measure ℝ) (frontier (Iic x)) = 0 := by
    rw [frontier_Iic, measure_singleton]
  have h := ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto' hP hfront
  have hr := (ENNReal.continuousAt_toReal (measure_ne_top (ν : Measure ℝ) _)).tendsto.comp h
  simpa only [cdf_eq_real, measureReal_def, Function.comp_def] using hr

/-- Weak convergence to an atomless real law has a measurable almost-sure representation
on Lebesgue probability on the open unit interval, with every original law preserved. -/
theorem exists_measurable_coupling_of_weak {P : ℕ → ProbabilityMeasure ℝ}
    {ν : ProbabilityMeasure ℝ} [NullSingletonClass (ν : Measure ℝ)]
    (hP : Tendsto P atTop (𝓝 ν)) :
    ∃ X : ℕ → ℝ → ℝ, ∃ Y : ℝ → ℝ,
      (∀ n, Measurable (X n) ∧ RealCoupling.unitProbability.map (X n) = (P n : Measure ℝ)) ∧
      Measurable Y ∧ RealCoupling.unitProbability.map Y = (ν : Measure ℝ) ∧
      ∀ᵐ u ∂RealCoupling.unitProbability, Tendsto (fun n => X n u) atTop (𝓝 (Y u)) :=
  RealCoupling.exists_measurable_real_coupling (fun n => (P n : Measure ℝ))
    (ν : Measure ℝ) (tendsto_cdf_of_weak_of_nullSingletonClass hP)

namespace Stable

/-- The actual walk at a varying time, normalized by the original time's scale. -/
noncomputable def timeScaledLaw (μ : PMF ℕ) (a : ℕ → ℝ) (ψ : ℕ → ℕ)
    (n : ℕ) : ProbabilityMeasure ℝ :=
  ⟨scaledLaw μ (fun _ => a n) (ψ n), inferInstance⟩

/-- The time remaining after the two truncations in the paper's smoothing argument
is asymptotic to `(1 - ε) n`. -/
theorem tendsto_trimmed_time_ratio {M : ℕ → ℕ}
    (hM : (fun n => (M n : ℝ)) =o[atTop] (fun n => (n : ℝ)))
    {ε : ℝ} (hε0 : 0 ≤ ε) (hε1 : ε < 1) :
    Tendsto (fun n : ℕ => ((n - M n - ⌊ε * (n : ℝ)⌋₊ : ℕ) : ℝ) / n)
      atTop (𝓝 (1 - ε)) := by
  have hfloor := (tendsto_nat_floor_mul_div_atTop (R := ℝ) hε0).comp
    tendsto_natCast_atTop_atTop
  have hsum := hM.tendsto_div_nhds_zero.add hfloor
  simp only [zero_add, Function.comp_def] at hsum
  have ht : Tendsto (fun n : ℕ => (1 : ℝ) -
      ((M n : ℝ) / n + (⌊ε * (n : ℝ)⌋₊ : ℝ) / n)) atTop (𝓝 (1 - ε)) :=
    tendsto_const_nhds.sub hsum
  refine ht.congr' ?_
  filter_upwards [hsum.eventually (gt_mem_nhds hε1), eventually_ge_atTop 1] with n hn hn1
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn1
  have hbound : (M n : ℝ) + (⌊ε * (n : ℝ)⌋₊ : ℝ) < n := by
    apply (div_lt_one hn0).1
    rwa [add_div]
  have hnat : M n + ⌊ε * (n : ℝ)⌋₊ ≤ n := by exact_mod_cast hbound.le
  rw [Nat.sub_sub, Nat.cast_sub hnat, Nat.cast_add]
  field_simp

/-- Marginal weak convergence under a proportional time change. In the paper's Skorokhod
step, `ψ n = n - M n - ⌊ε n⌋` and `c = 1 - ε`. -/
theorem tendsto_timeScaledLaw {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (h : StableDomain μ α a) {ν : Measure ℝ} [IsProbabilityMeasure ν]
    (hL : ∀ lam : ℝ, 0 < lam → ∫ y, Real.exp (-lam * y) ∂ν = Real.exp (lam ^ α))
    {ψ : ℕ → ℕ} {c : ℝ} (hc : 0 < c)
    (hψ : Tendsto (fun n : ℕ => (ψ n : ℝ) / n) atTop (𝓝 c)) :
    Tendsto (timeScaledLaw μ a ψ) atTop
      (𝓝 (ProbabilityMeasure.map (⟨ν, inferInstance⟩ : ProbabilityMeasure ℝ)
        (fun y : ℝ => c ^ (1 / α) * y))) := by
  rw [ProbabilityMeasure.tendsto_iff_tendsto_charFun]
  intro t
  have hψtop := tendsto_natCast_of_div hc hψ
  have hratio := tendsto_div_of_tendsto_div' h hc hψ
  have hs := hratio.const_mul t
  have ht := tendsto_stepCF_pow h hψtop hs
  have hα0 : 0 < α := by linarith [h.alpha_mem.1]
  have hEq : ∀ᶠ n in atTop,
      t / a n = (t * (a (ψ n) / a n)) / a (ψ n) := by
    filter_upwards [hψtop.eventually (eventually_ge_atTop 1)] with n hn
    have hne := (h.pos (ψ n) hn).ne'
    field_simp
  have ht' : Tendsto (fun n => stepCF μ (t / a n) ^ ψ n) atTop
      (𝓝 (stableCF α (t * c ^ (1 / α)))) :=
    ht.congr' (hEq.mono fun n hn => by rw [← hn])
  change Tendsto (fun n => charFun
    ((walkLaw μ (ψ n)).map (fun z : ℤ => (z : ℝ) / a n)) t) atTop
    (𝓝 (charFun (ν.map (fun y : ℝ => c ^ (1 / α) * y)) t))
  simpa only [charFun_walkLaw_map_div, charFun_map_mul, charFun_eq_stableCF hα0 hL,
    mul_comm (c ^ (1 / α)) t] using ht'

/-- The stable marginal law in `(H_α)` has no atoms, since its proved density is with respect
to Lebesgue measure. -/
theorem limitLaw_nullSingletonClass {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (h : StableDomain μ α a) {ν : Measure ℝ} [IsProbabilityMeasure ν]
    (hL : ∀ lam : ℝ, 0 < lam → ∫ y, Real.exp (-lam * y) ∂ν = Real.exp (lam ^ α)) :
    NullSingletonClass ν := by
  rw [limitLaw_eq_withDensity h hL]
  infer_instance

/-- The stable marginal CDF is continuous. -/
theorem continuous_limitLaw_cdf {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (h : StableDomain μ α a) {ν : Measure ℝ} [IsProbabilityMeasure ν]
    (hL : ∀ lam : ℝ, 0 < lam → ∫ y, Real.exp (-lam * y) ∂ν = Real.exp (lam ^ α)) :
    Continuous (cdf ν) := by
  let _ := limitLaw_nullSingletonClass h hL
  exact continuous_cdf_of_nullSingletonClass ν

/-- The actual time-changed stable-walk laws admit a common measurable almost-sure
representation, preserving the laws at every time. This is the real-valued representation
invoked at source lines 1987–1994. -/
theorem exists_timeScaled_coupling {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (h : StableDomain μ α a) {ν : Measure ℝ} [IsProbabilityMeasure ν]
    (hL : ∀ lam : ℝ, 0 < lam → ∫ y, Real.exp (-lam * y) ∂ν = Real.exp (lam ^ α))
    {ψ : ℕ → ℕ} {c : ℝ} (hc : 0 < c)
    (hψ : Tendsto (fun n : ℕ => (ψ n : ℝ) / n) atTop (𝓝 c)) :
    ∃ X : ℕ → ℝ → ℝ, ∃ Y : ℝ → ℝ,
      (∀ n, Measurable (X n) ∧ RealCoupling.unitProbability.map (X n) =
        (timeScaledLaw μ a ψ n : Measure ℝ)) ∧
      Measurable Y ∧ RealCoupling.unitProbability.map Y =
        ν.map (fun y : ℝ => c ^ (1 / α) * y) ∧
      ∀ᵐ u ∂RealCoupling.unitProbability, Tendsto (fun n => X n u) atTop (𝓝 (Y u)) := by
  let _ := limitLaw_nullSingletonClass h hL
  have hd : c ^ (1 / α) ≠ 0 := (Real.rpow_pos_of_pos hc _).ne'
  have hNA : NullSingletonClass (ν.map (fun y : ℝ => c ^ (1 / α) * y)) := by
    refine ⟨fun x => ?_⟩
    rw [Measure.map_apply (by fun_prop) (measurableSet_singleton x)]
    have hp : (fun y : ℝ => c ^ (1 / α) * y) ⁻¹' {x} = {x / c ^ (1 / α)} := by
      ext y
      simp only [mem_preimage, mem_singleton_iff]
      rw [eq_div_iff hd, mul_comm (c ^ (1 / α)) y]
    rw [hp, measure_singleton]
  let Q : ProbabilityMeasure ℝ := ProbabilityMeasure.map ⟨ν, inferInstance⟩
    (fun y : ℝ => c ^ (1 / α) * y)
  let _ : NullSingletonClass (Q : Measure ℝ) := hNA
  exact exists_measurable_coupling_of_weak (ν := Q) (tendsto_timeScaledLaw h hL hc hψ)

/-- The precise two-truncation marginal appearing in the source's Skorokhod step.
All convergence hypotheses for the time change are discharged from `M = o(n)`. -/
theorem exists_trimmed_walk_coupling {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (h : StableDomain μ α a) {ν : Measure ℝ} [IsProbabilityMeasure ν]
    (hL : ∀ lam : ℝ, 0 < lam → ∫ y, Real.exp (-lam * y) ∂ν = Real.exp (lam ^ α))
    {M : ℕ → ℕ} (hM : (fun n => (M n : ℝ)) =o[atTop] (fun n => (n : ℝ)))
    {ε : ℝ} (hε0 : 0 ≤ ε) (hε1 : ε < 1) :
    ∃ X : ℕ → ℝ → ℝ, ∃ Y : ℝ → ℝ,
      (∀ n, Measurable (X n) ∧ RealCoupling.unitProbability.map (X n) =
        (timeScaledLaw μ a (fun n => n - M n - ⌊ε * (n : ℝ)⌋₊) n : Measure ℝ)) ∧
      Measurable Y ∧ RealCoupling.unitProbability.map Y =
        ν.map (fun y : ℝ => (1 - ε) ^ (1 / α) * y) ∧
      ∀ᵐ u ∂RealCoupling.unitProbability, Tendsto (fun n => X n u) atTop (𝓝 (Y u)) :=
  exists_timeScaled_coupling h hL (sub_pos.mpr hε1)
    (tendsto_trimmed_time_ratio hM hε0 hε1)

end Stable
end PoissonDeclumping
