module

public import PoissonDeclumping

/-!
# Solution: the proof development

This Comparator *Solution* module re-exports the library `PoissonDeclumping`, whose module
`PoissonDeclumping/MainTheorems.lean` proves the four theorems stated in `Challenge.lean`:

* `PoissonDeclumping.poissonApproximation : PoissonDeclumping.PoissonApproximationStatement`
  (Theorem 1.1);
* `PoissonDeclumping.poissonApproximation2 : PoissonDeclumping.PoissonApproximation2Statement`
  (Theorem 1.2);
* `PoissonDeclumping.maxString : PoissonDeclumping.MaxStringStatement` (Theorem 1.3);
* `PoissonDeclumping.maxLeafHeight : PoissonDeclumping.MaxLeafHeightStatement` (Theorem 1.4).

The theorems are declared once, in the library, under exactly the fully qualified names used by the
Challenge; importing the library places them (and every definition their statements depend on) in
this module's environment, which is what `lake comparator` exports and compares. Redeclaring them
here would clash with the library's names, so this module adds no declarations of its own.
-/
