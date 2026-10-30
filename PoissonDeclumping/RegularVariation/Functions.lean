module

public import PoissonDeclumping.RegularVariation.Potter
public import Mathlib.Order.Filter.AtTopBot.Prod

/-!
# Real-index Potter bounds for the actual normalizing slow factor

The real function used in the paper is `x ↦ a ⌊x⌋₊ / x^ρ`, where `a` is a positive monotone
regularly varying sequence. `potter_floor_slowlyVarying` extends the sequence Potter bound to
all sufficiently large **real** arguments. It does not claim the more general theorem for
arbitrary slowly varying functions without a measurability or Baire hypothesis.
-/

@[expose] public section

open Filter
open scoped Topology

namespace PoissonDeclumping.RegularlyVaryingSeq

private theorem eventually_floor_rpow_ratio_le (r : ℝ) {C : ℝ} (hC : 1 < C) :
    ∃ B : ℝ, 1 ≤ B ∧ ∀ x y : ℝ, B ≤ x → B ≤ y →
      (((⌊y⌋₊ : ℝ) / y) / ((⌊x⌋₊ : ℝ) / x)) ^ r ≤ C := by
  have hx : Tendsto (fun p : ℝ × ℝ => p.1) atTop atTop := by
    rw [← prod_atTop_atTop_eq]
    exact tendsto_fst
  have hy : Tendsto (fun p : ℝ × ℝ => p.2) atTop atTop := by
    rw [← prod_atTop_atTop_eq]
    exact tendsto_snd
  have ht := ((tendsto_nat_floor_div_atTop (R := ℝ)).comp hy).div
    ((tendsto_nat_floor_div_atTop (R := ℝ)).comp hx) (by norm_num : (1 : ℝ) ≠ 0)
  have hp := ht.rpow_const (p := r) (Or.inl (by norm_num : (1 : ℝ) / 1 ≠ 0))
  simp only [div_one, Real.one_rpow] at hp
  obtain ⟨⟨Bx, By⟩, hB⟩ := eventually_atTop.mp (hp.eventually (gt_mem_nhds hC))
  refine ⟨max 1 (max Bx By), le_max_left _ _, fun x y hx hy => ?_⟩
  exact (hB (x, y) ⟨(le_max_left Bx By).trans ((le_max_right _ _).trans hx),
    (le_max_right Bx By).trans ((le_max_right _ _).trans hy)⟩).le

/-- Real-index Potter bound for the stepwise interpolation of `a`. -/
theorem potter_floor {ρ : ℝ} {a : ℕ → ℝ}
    (hrv : RegularlyVaryingSeq ρ a) (hmono : Monotone a)
    (hpos : ∀ n : ℕ, 1 ≤ n → 0 < a n) (hρ : 0 ≤ ρ)
    {A δ : ℝ} (hA : 1 < A) (hδ : 0 < δ) :
    ∃ B : ℝ, 1 ≤ B ∧ ∀ x y : ℝ, B ≤ x → B ≤ y →
      a ⌊y⌋₊ / a ⌊x⌋₊ ≤ A * max ((y / x) ^ (ρ + δ)) ((y / x) ^ (ρ - δ)) := by
  let D : ℝ := (A + 1) / 2
  have hD : 1 < D := by dsimp [D]; linarith
  have hDA : D < A := by dsimp [D]; linarith
  have hD0 : 0 < D := by linarith
  have hC : 1 < A / D := (one_lt_div hD0).2 hDA
  obtain ⟨N, hN1, hN⟩ := hrv.potter hmono hpos hρ hD hδ
  obtain ⟨B₁, hB₁1, hB₁⟩ := eventually_floor_rpow_ratio_le (ρ + δ) hC
  obtain ⟨B₂, hB₂1, hB₂⟩ := eventually_floor_rpow_ratio_le (ρ - δ) hC
  let B : ℝ := max (N : ℝ) (max B₁ B₂)
  have hNB : (N : ℝ) ≤ B := le_max_left _ _
  have hB₁B : B₁ ≤ B := (le_max_left _ _).trans (le_max_right _ _)
  have hB₂B : B₂ ≤ B := (le_max_right _ _).trans (le_max_right _ _)
  have hB1 : 1 ≤ B := hB₁1.trans hB₁B
  refine ⟨B, hB1, fun x y hx hy => ?_⟩
  have hx1 : 1 ≤ x := hB1.trans hx
  have hy1 : 1 ≤ y := hB1.trans hy
  have hx0 : 0 < x := by linarith
  have hy0 : 0 < y := by linarith
  have hNx : N ≤ ⌊x⌋₊ := Nat.le_floor (hNB.trans hx)
  have hNy : N ≤ ⌊y⌋₊ := Nat.le_floor (hNB.trans hy)
  have hfx : (0 : ℝ) < ⌊x⌋₊ := by exact_mod_cast lt_of_lt_of_le Nat.zero_lt_one (hN1.trans hNx)
  have hfy : (0 : ℝ) < ⌊y⌋₊ := by exact_mod_cast lt_of_lt_of_le Nat.zero_lt_one (hN1.trans hNy)
  have hpow (r : ℝ) : ((⌊y⌋₊ : ℝ) / ⌊x⌋₊) ^ r =
      (y / x) ^ r * ((((⌊y⌋₊ : ℝ) / y) / ((⌊x⌋₊ : ℝ) / x)) ^ r) := by
    rw [← Real.mul_rpow (by positivity : (0 : ℝ) ≤ y / x) (by positivity)]
    congr 1
    field_simp
  have hplus : ((⌊y⌋₊ : ℝ) / ⌊x⌋₊) ^ (ρ + δ) ≤ (y / x) ^ (ρ + δ) * (A / D) := by
    rw [hpow]
    exact mul_le_mul_of_nonneg_left (hB₁ x y (hB₁B.trans hx) (hB₁B.trans hy)) (by positivity)
  have hminus : ((⌊y⌋₊ : ℝ) / ⌊x⌋₊) ^ (ρ - δ) ≤ (y / x) ^ (ρ - δ) * (A / D) := by
    rw [hpow]
    exact mul_le_mul_of_nonneg_left (hB₂ x y (hB₂B.trans hx) (hB₂B.trans hy)) (by positivity)
  calc a ⌊y⌋₊ / a ⌊x⌋₊ ≤ D * max (((⌊y⌋₊ : ℝ) / ⌊x⌋₊) ^ (ρ + δ))
        (((⌊y⌋₊ : ℝ) / ⌊x⌋₊) ^ (ρ - δ)) := hN _ _ hNx hNy
    _ ≤ D * max ((y / x) ^ (ρ + δ) * (A / D)) ((y / x) ^ (ρ - δ) * (A / D)) :=
      mul_le_mul_of_nonneg_left (max_le_max hplus hminus) hD0.le
    _ = A * max ((y / x) ^ (ρ + δ)) ((y / x) ^ (ρ - δ)) := by
      rw [← max_mul_of_nonneg _ _ (by positivity : 0 ≤ A / D)]
      field_simp

/-- The displayed real-variable Potter inequality for the slowly varying part of the positive
monotone norming sequence. Both real arguments share the same threshold `B`. -/
theorem potter_floor_slowlyVarying {ρ : ℝ} {a : ℕ → ℝ}
    (hrv : RegularlyVaryingSeq ρ a) (hmono : Monotone a)
    (hpos : ∀ n : ℕ, 1 ≤ n → 0 < a n) (hρ : 0 ≤ ρ)
    {A δ : ℝ} (hA : 1 < A) (hδ : 0 < δ) :
    ∃ B : ℝ, 1 ≤ B ∧ ∀ x y : ℝ, B ≤ x → B ≤ y →
      (a ⌊y⌋₊ / y ^ ρ) / (a ⌊x⌋₊ / x ^ ρ) ≤
        A * max ((y / x) ^ δ) ((y / x) ^ (-δ)) := by
  obtain ⟨B, hB1, hB⟩ := hrv.potter_floor hmono hpos hρ hA hδ
  refine ⟨B, hB1, fun x y hx hy => ?_⟩
  have hx0 : 0 < x := by linarith
  have hy0 : 0 < y := by linarith
  have hq : 0 < y / x := by positivity
  have hqρ : 0 < (y / x) ^ ρ := by positivity
  have hlhs : (a ⌊y⌋₊ / y ^ ρ) / (a ⌊x⌋₊ / x ^ ρ) =
      (a ⌊y⌋₊ / a ⌊x⌋₊) / (y / x) ^ ρ := by
    rw [Real.div_rpow hy0.le hx0.le]
    have : (0 : ℝ) < x ^ ρ := by positivity
    have : (0 : ℝ) < y ^ ρ := by positivity
    field_simp
  have hmax : max ((y / x) ^ (ρ + δ)) ((y / x) ^ (ρ - δ)) =
      (y / x) ^ ρ * max ((y / x) ^ δ) ((y / x) ^ (-δ)) := by
    rw [Real.rpow_add hq, sub_eq_add_neg, Real.rpow_add hq, mul_max_of_nonneg _ _ hqρ.le]
  rw [hlhs, div_le_iff₀ hqρ]
  calc a ⌊y⌋₊ / a ⌊x⌋₊ ≤ A * max ((y / x) ^ (ρ + δ)) ((y / x) ^ (ρ - δ)) := hB _ _ hx hy
    _ = A * max ((y / x) ^ δ) ((y / x) ^ (-δ)) * (y / x) ^ ρ := by
      rw [hmax]; ring

end PoissonDeclumping.RegularlyVaryingSeq
