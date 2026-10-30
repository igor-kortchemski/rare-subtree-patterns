module

public import PoissonDeclumping.Stable.Lattice
public import Mathlib.Probability.ProbabilityMassFunction.Integrals
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

/-!
# A truncated-second-moment bound for the actual step characteristic function

Analytic progress toward the characterization at source line 712 (inventory B06).
For the actual offspring-minus-one characteristic function `φ`, cosine bounds
give `1 - Re φ(t) ≥ t²/(2π²) ∑_{2≤j≤n} j² μ_j` whenever `|t| n ≤ 1`.
There is no stable-domain or characteristic-function estimate hypothesis.

The full Abelian target for `1 < α < 2` remains unfinished: writing
`U(n) = ∑_{j≤n} j² μ_j`, `β = 2-α`, and assuming `U` regularly varying of index
`β`, the centered offspring Laplace remainder should satisfy

`E[e^{-sK}-1+sK] / (s² U(⌊1/s⌋)) → Γ(3-α)/(α(α-1))` as `s ↓ 0`.

One route is the Laplace–Stieltjes identity
`E[K² e^{-sK}] = s ∫_0^∞ e^{-sx} U(⌊x⌋) dx`, dominated rescaling using Potter
bounds, and twice integrating the transform. Establishing the corresponding
complex boundary asymptotic, inverse norming and Laplace normalization of the
limit are additional required stages. The cosine bound here is not that
asymptotic equivalence and does not complete B06.
-/

@[expose] public section

open MeasureTheory ProbabilityTheory Complex Filter Set
open scoped Topology

namespace PoissonDeclumping.Stable

/-- The actual real characteristic-function defect as a nonnegative offspring sum. -/
theorem one_sub_re_stepCF_eq_tsum (μ : PMF ℕ) (t : ℝ) :
    1 - (stepCF μ t).re =
      ∑' j : ℕ, (μ j).toReal * (1 - Real.cos (t * ((j : ℝ) - 1))) := by
  have he : Integrable (fun j : ℕ => cexp (t * (((j : ℤ) - 1 : ℤ) : ℂ) * I))
      μ.toMeasure :=
    Integrable.of_bound (C := 1) (measurable_of_countable _).aestronglyMeasurable
      (Eventually.of_forall fun j => by simp [Complex.norm_exp])
  have hc : Integrable (fun j : ℕ => Real.cos (t * ((j : ℝ) - 1))) μ.toMeasure :=
    Integrable.of_bound (C := 1) (measurable_of_countable _).aestronglyMeasurable
      (Eventually.of_forall fun j => by
        simpa [Real.norm_eq_abs] using (Real.abs_cos_le_one (t * ((j : ℝ) - 1))))
  have hre : (stepCF μ t).re = ∫ j : ℕ, Real.cos (t * ((j : ℝ) - 1)) ∂μ.toMeasure := by
    rw [stepCF_eq_integral]
    calc
      (∫ k : ℕ, cexp (t * (((k : ℤ) - 1 : ℤ) : ℂ) * I) ∂μ.toMeasure).re =
          ∫ k : ℕ, (cexp (t * (((k : ℤ) - 1 : ℤ) : ℂ) * I)).re ∂μ.toMeasure :=
        (integral_re he).symm
      _ = _ := ?_
    apply integral_congr_ae
    refine Eventually.of_forall fun j => ?_
    simp [Complex.exp_re]
  calc
    1 - (stepCF μ t).re = (∫ _ : ℕ, (1 : ℝ) ∂μ.toMeasure) -
        ∫ j : ℕ, Real.cos (t * ((j : ℝ) - 1)) ∂μ.toMeasure := by simp [hre]
    _ = ∫ j : ℕ, 1 - Real.cos (t * ((j : ℝ) - 1)) ∂μ.toMeasure :=
      (integral_sub (integrable_const _) hc).symm
    _ = _ := by
      simpa only [smul_eq_mul] using PMF.integral_eq_tsum μ
        (fun j : ℕ => 1 - Real.cos (t * ((j : ℝ) - 1))) ((integrable_const _).sub hc)

/-- The nonnegative sum defining the real characteristic-function defect is summable. -/
theorem summable_stepCF_cosine_defect (μ : PMF ℕ) (t : ℝ) :
    Summable (fun j : ℕ => (μ j).toReal * (1 - Real.cos (t * ((j : ℝ) - 1)))) := by
  have hμ : Summable (fun j : ℕ => (μ j).toReal) :=
    ENNReal.summable_toReal μ.tsum_coe_ne_top
  refine Summable.of_nonneg_of_le (fun j => mul_nonneg ENNReal.toReal_nonneg
    (sub_nonneg.mpr (Real.cos_le_one _))) (fun j => ?_) (hμ.mul_right 2)
  exact mul_le_mul_of_nonneg_left
    (by linarith [Real.neg_one_le_cos (t * ((j : ℝ) - 1))]) ENNReal.toReal_nonneg

/-- A local cosine estimate with the offspring shift accounted for explicitly. -/
theorem truncated_cosine_lower_bound {t : ℝ} {j n : ℕ} (hj : 2 ≤ j) (hjn : j ≤ n)
    (ht : |t| * n ≤ 1) :
    (1 / (2 * Real.pi ^ 2)) * t ^ 2 * (j : ℝ) ^ 2 ≤
      1 - Real.cos (t * ((j : ℝ) - 1)) := by
  have hj2 : (2 : ℝ) ≤ j := by exact_mod_cast hj
  have hjn' : (j : ℝ) ≤ n := by exact_mod_cast hjn
  have hj0 : 0 ≤ (j : ℝ) - 1 := by linarith
  have hangle : |t * ((j : ℝ) - 1)| ≤ Real.pi := by
    rw [abs_mul, abs_of_nonneg hj0]
    calc |t| * ((j : ℝ) - 1) ≤ |t| * n := by gcongr; linarith
      _ ≤ 1 := ht
      _ ≤ Real.pi := by linarith [Real.one_le_pi_div_two]
  have hcos := Real.cos_le_one_sub_mul_cos_sq hangle
  have hs : (j : ℝ) ^ 2 ≤ 4 * ((j : ℝ) - 1) ^ 2 := by
    have h := sq_le_sq₀ (Nat.cast_nonneg j) (by linarith : 0 ≤ 2 * ((j : ℝ) - 1))
    have hh : (j : ℝ) ≤ 2 * ((j : ℝ) - 1) := by linarith
    nlinarith [h.mpr hh]
  have hfactor : (1 / (2 * Real.pi ^ 2)) * t ^ 2 * (j : ℝ) ^ 2 ≤
      2 / Real.pi ^ 2 * (t * ((j : ℝ) - 1)) ^ 2 := by
    apply (mul_le_mul_iff_right₀ (show (0 : ℝ) < 2 * Real.pi ^ 2 by positivity)).mp
    field_simp
    nlinarith [mul_nonneg (sq_nonneg t) (sub_nonneg.mpr hs)]
  exact hfactor.trans (by linarith)

/-- **Truncated-moment lower bound.** No finite second moment, stable-domain assumption,
or unproved analytic estimate is needed. The omitted `j = 1` term is necessary because
the step is `K - 1`, whose contribution at `K = 1` vanishes. -/
theorem truncated_secondMoment_le_stepCF_defect (μ : PMF ℕ) (t : ℝ) (n : ℕ)
    (ht : |t| * n ≤ 1) :
    (1 / (2 * Real.pi ^ 2)) * t ^ 2 *
        (∑ j ∈ Finset.Icc 2 n, (j : ℝ) ^ 2 * (μ j).toReal) ≤ 1 - (stepCF μ t).re := by
  rw [one_sub_re_stepCF_eq_tsum]
  calc
    (1 / (2 * Real.pi ^ 2)) * t ^ 2 *
        (∑ j ∈ Finset.Icc 2 n, (j : ℝ) ^ 2 * (μ j).toReal) =
      ∑ j ∈ Finset.Icc 2 n, (μ j).toReal *
        ((1 / (2 * Real.pi ^ 2)) * t ^ 2 * (j : ℝ) ^ 2) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro j hj
          ring
    _ ≤ ∑ j ∈ Finset.Icc 2 n, (μ j).toReal *
        (1 - Real.cos (t * ((j : ℝ) - 1))) := by
          apply Finset.sum_le_sum
          intro j hj
          exact mul_le_mul_of_nonneg_left
            (truncated_cosine_lower_bound (Finset.mem_Icc.mp hj).1 (Finset.mem_Icc.mp hj).2 ht)
            ENNReal.toReal_nonneg
    _ ≤ ∑' j : ℕ, (μ j).toReal * (1 - Real.cos (t * ((j : ℝ) - 1))) :=
      (summable_stepCF_cosine_defect μ t).sum_le_tsum _
        (fun j hj => mul_nonneg ENNReal.toReal_nonneg (sub_nonneg.mpr (Real.cos_le_one _)))

/-- **Head/tail upper bound.** The quadratic head includes the actual shift `j - 1`;
the tail costs at most twice its probability. It is valid for every real frequency
and every cutoff, including offspring laws with infinite variance. -/
theorem stepCF_defect_le_truncated_secondMoment_add_tail (μ : PMF ℕ) (t : ℝ) (n : ℕ) :
    1 - (stepCF μ t).re ≤
      (t ^ 2 / 2) * (∑ j ∈ Finset.range (n + 1), ((j : ℝ) - 1) ^ 2 * (μ j).toReal) +
        2 * μ.toMeasure.real {j : ℕ | n < j} := by
  classical
  let H : ℕ → ℝ := fun j => if j ≤ n then (t ^ 2 / 2) * ((j : ℝ) - 1) ^ 2 else 0
  let T : ℕ → ℝ := {j : ℕ | n < j}.indicator (fun _ => 2)
  have hHeq : H = (Finset.range (n + 1) : Set ℕ).indicator
      (fun j => (t ^ 2 / 2) * ((j : ℝ) - 1) ^ 2) := by
    funext j
    simp [H, Set.indicator]
  have hH : Integrable H μ.toMeasure := by
    rw [hHeq]
    exact (IntegrableOn.finset (s := Finset.range (n + 1))).integrable_indicator
      MeasurableSet.of_discrete
  have hT : Integrable T μ.toMeasure :=
    (integrable_const (2 : ℝ)).indicator MeasurableSet.of_discrete
  have hHv : ∫ j, H j ∂μ.toMeasure = (t ^ 2 / 2) *
      (∑ j ∈ Finset.range (n + 1), ((j : ℝ) - 1) ^ 2 * (μ j).toReal) := by
    rw [hHeq, integral_indicator MeasurableSet.of_discrete,
      setIntegral_finset _ IntegrableOn.finset, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j hj
    rw [measureReal_def, PMF.toMeasure_apply_singleton μ j (measurableSet_singleton j),
      smul_eq_mul]
    ring
  have hTv : ∫ j, T j ∂μ.toMeasure = 2 * μ.toMeasure.real {j : ℕ | n < j} := by
    dsimp only [T]
    rw [integral_indicator_const _ MeasurableSet.of_discrete, smul_eq_mul, mul_comm]
  have hi : Integrable (fun j : ℕ => 1 - Real.cos (t * ((j : ℝ) - 1))) μ.toMeasure :=
    Integrable.of_bound (C := 2) (measurable_of_countable _).aestronglyMeasurable
      (Eventually.of_forall fun j => by
        rw [Real.norm_of_nonneg (sub_nonneg.mpr (Real.cos_le_one _))]
        linarith [Real.neg_one_le_cos (t * ((j : ℝ) - 1))])
  have hid : 1 - (stepCF μ t).re =
      ∫ j : ℕ, 1 - Real.cos (t * ((j : ℝ) - 1)) ∂μ.toMeasure := by
    rw [one_sub_re_stepCF_eq_tsum]
    simpa only [smul_eq_mul] using (PMF.integral_eq_tsum μ _ hi).symm
  have hle : ∀ j : ℕ, 1 - Real.cos (t * ((j : ℝ) - 1)) ≤ H j + T j := by
    intro j
    by_cases hj : j ≤ n
    · have hnj : ¬ n < j := by omega
      simp only [H, ite_eq_left hj, T,
        Set.indicator_of_notMem (show j ∉ {j : ℕ | n < j} from hnj), add_zero]
      nlinarith [Real.one_sub_sq_div_two_le_cos (x := t * ((j : ℝ) - 1))]
    · have hnj : n < j := by omega
      simp only [H, ite_eq_right hj, T, Set.indicator_of_mem (show j ∈ {j : ℕ | n < j} from hnj),
        zero_add]
      linarith [Real.neg_one_le_cos (t * ((j : ℝ) - 1))]
  calc 1 - (stepCF μ t).re =
        ∫ j : ℕ, 1 - Real.cos (t * ((j : ℝ) - 1)) ∂μ.toMeasure := hid
    _ ≤ ∫ j : ℕ, H j + T j ∂μ.toMeasure := integral_mono hi (hH.add hT) hle
    _ = _ := by rw [integral_add hH hT, hHv, hTv]

end PoissonDeclumping.Stable
