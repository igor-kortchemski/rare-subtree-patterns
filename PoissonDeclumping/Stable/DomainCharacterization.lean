module

public import PoissonDeclumping.Stable.Convergence

import Mathlib.Topology.Sequences
import Mathlib.MeasureTheory.Measure.Prokhorov
import Mathlib.MeasureTheory.Measure.LevyProkhorovMetric
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds

/-!
# Constructing the limit law from characteristic-function asymptotics

This is the Lévy-convergence stage of the domain-of-attraction characterization
asserted at source line 712 (inventory B06). The primitive input here is pointwise
convergence of the characteristic functions of the normalized actual walk. The
limit probability measure is constructed by tightness and Prokhorov compactness;
it is not assumed to exist, nor is `StableDomain` assumed.

The truncated-second-moment Abelian estimate, a suitable inverse normalizing
sequence, and the Laplace-transform normalization are separate unfinished stages
of the full characterization. Thus the results here are conditional bridges,
not a claim to have proved that characterization.
-/

@[expose] public section

open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology

namespace PoissonDeclumping.Stable

/-- **Lévy existence theorem on the real line.** A pointwise limit of characteristic
functions which is continuous at zero is the characteristic function of an actual
probability law, and the original laws converge weakly to it. -/
theorem exists_probabilityMeasure_of_tendsto_charFun {P : ℕ → ProbabilityMeasure ℝ}
    {f : ℝ → ℂ} (hf : ContinuousAt f 0)
    (h : ∀ t : ℝ, Tendsto (fun n => charFun (P n : Measure ℝ) t) atTop (𝓝 (f t))) :
    ∃ ν : ProbabilityMeasure ℝ, (∀ t : ℝ, charFun (ν : Measure ℝ) t = f t) ∧
      Tendsto P atTop (𝓝 ν) := by
  have ht : IsTightMeasureSet (range (fun n => (P n : Measure ℝ))) :=
    isTightMeasureSet_of_tendsto_charFun hf h
  have hc : IsCompact (closure (range P)) :=
    isCompact_closure_of_isTightMeasureSet (by simpa [Set.range] using ht)
  obtain ⟨ν, -, φ, hφ, hsub⟩ := hc.tendsto_subseq (fun n => subset_closure (mem_range_self n))
  have hν : ∀ t : ℝ, charFun (ν : Measure ℝ) t = f t := by
    intro t
    have hcf := ProbabilityMeasure.tendsto_iff_tendsto_charFun.mp hsub t
    exact tendsto_nhds_unique hcf ((h t).comp hφ.tendsto_atTop)
  refine ⟨ν, hν, ProbabilityMeasure.tendsto_of_tendsto_charFun (fun t => ?_)⟩
  rw [hν]
  exact h t

/-- The limit constructed from a continuous characteristic-function limit is unique. -/
theorem probabilityMeasure_unique_of_charFun_eq {ν₁ ν₂ : ProbabilityMeasure ℝ}
    {f : ℝ → ℂ} (h₁ : ∀ t : ℝ, charFun (ν₁ : Measure ℝ) t = f t)
    (h₂ : ∀ t : ℝ, charFun (ν₂ : Measure ℝ) t = f t) : ν₁ = ν₂ := by
  apply ProbabilityMeasure.toMeasure_injective
  apply Measure.ext_of_charFun
  funext t
  rw [h₁, h₂]

/-- Characteristic-function asymptotics of the actual normalized Łukasiewicz walk
construct its stable limit law and establish weak convergence. No stable-domain
or pre-existing limit-law hypothesis is used. -/
theorem exists_stable_limit_of_tendsto_stepCF_pow {μ : PMF ℕ} {α : ℝ} {a : ℕ → ℝ}
    (hα : 0 < α)
    (hcf : ∀ t : ℝ, Tendsto (fun n : ℕ => stepCF μ (t / a n) ^ n) atTop
      (𝓝 (stableCF α t))) :
    ∃ ν : ProbabilityMeasure ℝ, (∀ t : ℝ, charFun (ν : Measure ℝ) t = stableCF α t) ∧
      ∀ f : BoundedContinuousFunction ℝ ℝ,
        Tendsto (fun n : ℕ => ∫ x, f x ∂scaledLaw μ a n) atTop
          (𝓝 (∫ x, f x ∂(ν : Measure ℝ))) := by
  let P : ℕ → ProbabilityMeasure ℝ := fun n => ⟨scaledLaw μ a n, inferInstance⟩
  have hcf' : ∀ t : ℝ, Tendsto (fun n => charFun (P n : Measure ℝ) t) atTop
      (𝓝 (stableCF α t)) := by
    intro t
    refine (hcf t).congr fun n => ?_
    exact (charFun_walkLaw_map_div μ n (a n) t).symm
  obtain ⟨ν, hν, hw⟩ := exists_probabilityMeasure_of_tendsto_charFun
    (continuous_stableCF hα).continuousAt hcf'
  refine ⟨ν, hν, ?_⟩
  rw [ProbabilityMeasure.tendsto_iff_forall_integral_tendsto] at hw
  exact hw

/-- The linearized characteristic-function asymptotic is sufficient for construction of
the stable limit. This is the form supplied by the still-unfinished Abelian stage of
the truncated-moment characterization. -/
theorem exists_stable_limit_of_tendsto_mul_stepCF_sub_one {μ : PMF ℕ} {α : ℝ}
    {a : ℕ → ℝ} (hα : 0 < α)
    (hcf : ∀ t : ℝ, Tendsto (fun n : ℕ => (n : ℂ) * (stepCF μ (t / a n) - 1))
      atTop (𝓝 ((-((t : ℂ) * Complex.I)) ^ (α : ℂ)))) :
    ∃ ν : ProbabilityMeasure ℝ, (∀ t : ℝ, charFun (ν : Measure ℝ) t = stableCF α t) ∧
      ∀ f : BoundedContinuousFunction ℝ ℝ,
        Tendsto (fun n : ℕ => ∫ x, f x ∂scaledLaw μ a n) atTop
          (𝓝 (∫ x, f x ∂(ν : Measure ℝ))) := by
  apply exists_stable_limit_of_tendsto_stepCF_pow hα
  intro t
  simpa only [add_sub_cancel, stableCF] using
    Complex.tendsto_one_add_pow_exp_of_tendsto (hcf t)

end PoissonDeclumping.Stable
