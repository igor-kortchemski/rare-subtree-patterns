module

import PoissonDeclumping

/-! Headline type and axiom checks. Run from the project root:
`lake env lean verification/Axioms.lean`.
For the transitive axiom closure of EVERY declaration of the library, see `AxiomAudit.lean`.
This file proves no new mathematics and is not imported by the proof library. -/

-- The four Introduction theorems (types = the reviewed statement-level propositions).
#print PoissonDeclumping.StableDomain
#check @PoissonDeclumping.poissonApproximation
#check @PoissonDeclumping.poissonApproximation2
#check @PoissonDeclumping.maxString
#check @PoissonDeclumping.maxLeafHeight
#print axioms PoissonDeclumping.poissonApproximation
#print axioms PoissonDeclumping.poissonApproximation2
#print axioms PoissonDeclumping.maxString
#print axioms PoissonDeclumping.maxLeafHeight

-- The derived stable toolbox and the non-vacuity witnesses.
#check @PoissonDeclumping.Stable.stableToolkit
#print axioms PoissonDeclumping.Stable.stableToolkit
#print axioms PoissonDeclumping.Stable.localLimit
#print axioms PoissonDeclumping.Examples.SimpleWalk.witness
#print axioms PoissonDeclumping.Examples.BinomialWalk.witness

-- Representative intermediate exports.
#print axioms PoissonDeclumping.PlaneTree.bienayme_isProbabilityMeasure
#print axioms PoissonDeclumping.Lukasiewicz.existsUnique_zeta_rotate_eq_length
#print axioms PoissonDeclumping.ChenStein.prop_AGG
#print axioms PoissonDeclumping.Bridge.tendsto_errorB3
#print axioms PoissonDeclumping.PlaneTree.conditioned_declump_to_raw

-- Obligations completed after the audit.
#check @PoissonDeclumping.Bridge.exists_qProb_le_mul_markProb
#check @PoissonDeclumping.DirectApplications.unary_raw_not_tendsto_poisson_mean
#check @PoissonDeclumping.Stable.exists_norming_isEquivalent_sqrt
#check @PoissonDeclumping.Stable.stableDomain_of_finiteVariance
#check @PoissonDeclumping.Stable.exists_trimmed_walk_coupling
#print axioms PoissonDeclumping.Bridge.exists_qProb_le_mul_markProb
#print axioms PoissonDeclumping.DirectApplications.unary_counterexample_exists
#print axioms PoissonDeclumping.Stable.exists_norming_isEquivalent_sqrt
#print axioms PoissonDeclumping.Stable.stableDomain_of_finiteVariance
#print axioms PoissonDeclumping.RegularlyVaryingSeq.potter_floor_slowlyVarying
#print axioms PoissonDeclumping.RealCoupling.exists_measurable_real_coupling
#print axioms PoissonDeclumping.Stable.exists_trimmed_walk_coupling
#print axioms PoissonDeclumping.Stable.exists_stable_limit_of_tendsto_mul_stepCF_sub_one
#print axioms PoissonDeclumping.Stable.maximal_tight
#print axioms PoissonDeclumping.Stable.tendsto_maximal_tail
#print axioms PoissonDeclumping.Stable.truncated_secondMoment_le_stepCF_defect
#print axioms PoissonDeclumping.Stable.stepCF_defect_le_truncated_secondMoment_add_tail
