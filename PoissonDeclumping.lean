module

public import PoissonDeclumping.Declumping.Probability
public import PoissonDeclumping.PlaneTree.Countable
public import PoissonDeclumping.PlaneTree.Patterns
public import PoissonDeclumping.Bienayme.Defs
public import PoissonDeclumping.Bienayme.Basic
public import PoissonDeclumping.Bienayme.Normalization
public import PoissonDeclumping.Bienayme.Conditioned
public import PoissonDeclumping.Declumping.Conditioned
public import PoissonDeclumping.Lukasiewicz.FirstPassage
public import PoissonDeclumping.Lukasiewicz.Coding
public import PoissonDeclumping.Lukasiewicz.CyclicShift
public import PoissonDeclumping.Lukasiewicz.Excursion
public import PoissonDeclumping.Lukasiewicz.BridgeLaw
public import PoissonDeclumping.LeafHeight.Recursion
public import PoissonDeclumping.LeafHeight.Asymptotics
public import PoissonDeclumping.LeafHeight.Consequences
public import PoissonDeclumping.LeafHeight.Tree
public import PoissonDeclumping.ChenStein.SteinSolution
public import PoissonDeclumping.ChenStein.AGG
public import PoissonDeclumping.Probability.PoissonTV
public import PoissonDeclumping.Extremes.Ineqs
public import PoissonDeclumping.Setup.Walk
public import PoissonDeclumping.Setup.Marks
public import PoissonDeclumping.Setup.Toolkit
public import PoissonDeclumping.Examples.SimpleWalk
public import PoissonDeclumping.Examples.BinomialWalk
public import PoissonDeclumping.Stable.ToolkitProof
public import PoissonDeclumping.Stable.DensityLaw
public import PoissonDeclumping.Bridge.CriterionS
public import PoissonDeclumping.Bridge.CriterionM
public import PoissonDeclumping.Bridge.WalkCalculus
public import PoissonDeclumping.Bridge.Kemperman
public import PoissonDeclumping.Bridge.Truncation0
public import PoissonDeclumping.Bridge.PairBound
public import PoissonDeclumping.Bridge.ExtremeMeans
public import PoissonDeclumping.Bridge.MainTheorems
public import PoissonDeclumping.Bridge.EndpointSmoothing
public import PoissonDeclumping.Extremes.MaxString
public import PoissonDeclumping.Extremes.MaxLeafHeight
public import PoissonDeclumping.Extremes.MaxLeafHeightFirstOrder
public import PoissonDeclumping.DirectApplications.DeclumpZero
public import PoissonDeclumping.DirectApplications.FringeCorollary
public import PoissonDeclumping.DirectApplications.Criteria
public import PoissonDeclumping.DirectApplications.NonFringe
public import PoissonDeclumping.DirectApplications.Outdegree
public import PoissonDeclumping.DirectApplications.CompoundPoisson
public import PoissonDeclumping.DirectApplications.UnaryClustering
public import PoissonDeclumping.RegularVariation.Functions
public import PoissonDeclumping.Stable.CDF
public import PoissonDeclumping.Stable.FiniteVariance
public import PoissonDeclumping.Stable.DomainCharacterization
public import PoissonDeclumping.Stable.MaximalTightness
public import PoissonDeclumping.Stable.TruncatedMoment
public import PoissonDeclumping.Bridge.ForestEstimates
public import PoissonDeclumping.Bridge.Microscopic
public import PoissonDeclumping.Bridge.RootMicroscopic
public import PoissonDeclumping.Bridge.BridgeRemoval
public import PoissonDeclumping.Bridge.Truncation
public import PoissonDeclumping.Bridge.ErrorTerms
public import PoissonDeclumping.ExtremesAnalysis.TwoPoint
public import PoissonDeclumping.ExtremesAnalysis.Unary
public import PoissonDeclumping.ExtremesAnalysis.Rary
public import PoissonDeclumping.ExtremesAnalysis.LeafHeightLevels
public import PoissonDeclumping.Applications.TreeSurgery
public import PoissonDeclumping.Applications.TreeCriteria
public import PoissonDeclumping.Applications.TreeCompleteClass
public import PoissonDeclumping.Applications.CompleteArySC
public import PoissonDeclumping.Applications.LeafHeightSC
public import PoissonDeclumping.Patterns.CutGraft
public import PoissonDeclumping.Patterns.CutGraftBound
public import PoissonDeclumping.Patterns.NonFringe
public import PoissonDeclumping.Patterns.Complete
public import PoissonDeclumping.RootDeclumping.ParentFormula
public import PoissonDeclumping.RootDeclumping.Lemma51
public import PoissonDeclumping.RootDeclumping.LeafHeightMark
public import PoissonDeclumping.RootDeclumping.Generations
public import PoissonDeclumping.RootDeclumping.LeafHeightGenerations
public import PoissonDeclumping.RootDeclumping.GenerationBranching
public import PoissonDeclumping.RootDeclumping.LeafHeightSkeleton
public import PoissonDeclumping.Statements.Main
public import PoissonDeclumping.MainTheorems
public import PoissonDeclumping.MainConsequences
public import PoissonDeclumping.RegularVariation.Defs
public import PoissonDeclumping.RegularVariation.Potter
public import PoissonDeclumping.RegularVariation.Consequences
public import PoissonDeclumping.RegularVariation.Karamata
public import PoissonDeclumping.RegularVariation.Bridge
public import PoissonDeclumping.Cyclic.WalkBridge
public import PoissonDeclumping.Cyclic.Indicators
public import PoissonDeclumping.Cyclic.RandomWalk
public import PoissonDeclumping.Cyclic.UniformVertex
public import PoissonDeclumping.Cyclic.Markov

/-!
# Rare subtree patterns in size-conditioned Bienaymé trees

Entry point for the formalization of "Rare subtree patterns in size-conditioned
Bienaymé trees: Poisson approximation and declumping" by Igor Kortchemski and
Leonard Vetter (arXiv:2607.22291v1).

The four Introduction theorems are proved in `PoissonDeclumping.MainTheorems` with exactly the
types of the statement-level propositions of `PoissonDeclumping.Statements.Main`:

* `PoissonDeclumping.poissonApproximation` (Theorem 1.1, marked Poisson approximation),
* `PoissonDeclumping.poissonApproximation2` (Theorem 1.2, root declumping),
* `PoissonDeclumping.maxString` (Theorem 1.3, maximal complete non-fringe `r`-ary height),
* `PoissonDeclumping.maxLeafHeight` (Theorem 1.4, maximum leaf-height).

They retain the paper's marking and cutoff hypotheses and its standing assumption `(H_α)` (`StableDomain`); periodic
offspring laws are included. The Bienaymé law, the Łukasiewicz coding, the stable local limit
theorem for the walk, the Chen–Stein bound, the bridge estimates and the applications are all
developed here. See `FORMALIZATION_REPORT.md` for the coverage record, the proof correspondence
(including departures from the paper's arguments), the exact scope and what is not formalized.
-/
