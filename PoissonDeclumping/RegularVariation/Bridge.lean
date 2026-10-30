module

public import PoissonDeclumping.RegularVariation.Defs
public import PoissonDeclumping.Setup.Walk

/-!
# From the paper's formulation of regular variation to `RegularlyVaryingSeq`

Source lines 846–850: "`(a_n)` is regularly varying of index `1/α`, meaning that
`a_n / n^{1/α}` is slowly varying", with slowly varying functions on `ℝ_+` as in
`PoissonDeclumping.SlowlyVarying`. A sequence is read as the step function `x ↦ a_{⌊x⌋}`.
This file shows that this formulation implies the sequential form `RegularlyVaryingSeq`.

Note: `PoissonDeclumping.StableDomain` does not contain regular variation of `a` as a field;
in the source it is a stated consequence of the stable limit theorem.
-/

@[expose] public section

open Filter
open scoped Topology

namespace PoissonDeclumping

/-- If `x ↦ a ⌊x⌋₊ / x ^ ρ` is slowly varying and `a` is positive at `n ≥ 1`, then `a` is
regularly varying of index `ρ` in the sequential sense. -/
theorem RegularlyVaryingSeq.of_slowlyVarying {ρ : ℝ} {a : ℕ → ℝ}
    (hpos : ∀ n : ℕ, 1 ≤ n → 0 < a n)
    (h : SlowlyVarying (fun x : ℝ => a ⌊x⌋₊ / x ^ ρ)) : RegularlyVaryingSeq ρ a := by
  intro c hc
  have h1 : Tendsto (fun n : ℕ => a ⌊c * (n : ℝ)⌋₊ / (c * (n : ℝ)) ^ ρ /
      (a ⌊(n : ℝ)⌋₊ / (n : ℝ) ^ ρ)) atTop (𝓝 1) :=
    (h c hc).comp tendsto_natCast_atTop_atTop
  have h2 := h1.const_mul (c ^ ρ)
  rw [mul_one] at h2
  refine h2.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with n hn
  have han := hpos n hn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hcρ : 0 < c ^ ρ := Real.rpow_pos_of_pos hc ρ
  have hnρ : 0 < (n : ℝ) ^ ρ := Real.rpow_pos_of_pos hnR ρ
  simp only [Nat.floor_natCast]
  rw [Real.mul_rpow hc.le hnR.le]
  field_simp
