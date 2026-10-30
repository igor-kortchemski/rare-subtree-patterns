module

meta import Lean

/-! # Local statement-closure check for `Challenge` vs `Solution` (NOT a Comparator run)

Run from the project root, after `lake build Challenge Solution`:

    lake env lean verification/StatementClosure.lean

This is a local diagnostic in the spirit of `lake comparator`, run without its sandbox and without
the `leanexport` round trip or any external kernel; it is **not** a Comparator or NanoDa result.
It loads the environments of the modules `Challenge` and `Solution` *separately*, with
`Lean.importModules` at the `private` level (full bodies), and for each of the four advertised
theorems checks:

(a) the theorem's type is `Expr`-equal in both environments (and both are theorems with the same
    universe parameters);
(b) every constant reachable from these types — following, exactly as Lake's comparator
    (`Lake.Check.runForUsedConsts`), the constants of each reached constant's type and value
    (theorem values included), the constructors and mutual block of inductives, the inductive of
    constructors and the rules of recursors — exists in both environments with an equal
    `ConstantInfo` (type, value, universe parameters, reducibility hints, inductive data;
    docstrings are not part of `ConstantInfo`). Project-defined constants (from `Challenge` resp.
    `PoissonDeclumping.*`) are counted separately;
(c) the axioms used by the Solution theorems (`Lean.collectAxioms`, plus an independent traversal
    of the same shape as the comparator's axiom check) are among `propext`, `Classical.choice`,
    `Quot.sound`, and the Challenge theorems depend on `sorryAx` (the deliberate holes).

It also checks that the Challenge's import closure contains no `PoissonDeclumping` module.
This file proves no mathematics and is not imported by any library. -/

meta section

open Lean

/-- The constants a constant refers to, as in `Lake.Check.runForUsedConsts`. -/
def closureStep (ci : ConstantInfo) : Array Name := Id.run do
  let mut out : Array Name := ci.type.getUsedConstants.push ci.name
  if let some v := ci.value? (allowOpaque := true) then
    out := out ++ v.getUsedConstants
  match ci with
  | .inductInfo i => out := out ++ i.ctors.toArray ++ i.all.toArray
  | .ctorInfo i => out := out.push i.induct
  | .recInfo i =>
    for r in i.rules do
      out := (out.push r.ctor) ++ r.rhs.getUsedConstants
  | _ => pure ()
  return out

def moduleOf (env : Environment) (n : Name) : Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]!
  | none => `_current

def isProjectModule (m : Name) : Bool :=
  m == `Challenge || m == `Solution || (`PoissonDeclumping).isPrefixOf m

/-- Axioms reachable from `n` by the comparator-style traversal (independent of `collectAxioms`). -/
def axiomsByTraversal (env : Environment) (n : Name) : Except String (Array Name) := do
  let mut work : Array Name := #[n]
  let mut seen : NameSet := {}
  let mut axs : NameSet := {}
  while !work.isEmpty do
    let c := work.back!
    work := work.pop
    if seen.contains c then continue
    seen := seen.insert c
    let some ci := env.find? c | throw s!"constant not found: {c}"
    if ci matches .axiomInfo _ then axs := axs.insert c
    work := work ++ closureStep ci
  return axs.toArray.qsort Name.lt

def axiomsByCollect (env : Environment) (n : Name) : IO (Array Name) := do
  let (axs, _) ← (collectAxioms n : CoreM (Array Name)).toIO
    { fileName := "<StatementClosure>", fileMap := default } { env }
  return axs.qsort Name.lt

def theoremNames : Array Name := #[`PoissonDeclumping.poissonApproximation,
  `PoissonDeclumping.poissonApproximation2, `PoissonDeclumping.maxString,
  `PoissonDeclumping.maxLeafHeight]

def allowedAxioms : Array Name := #[``propext, ``Classical.choice, ``Quot.sound]

def runCheck : IO Unit := do
  let t0 ← IO.monoMsNow
  let chal ← importModules #[{ module := `Challenge }] {} (level := .private)
  let sol ← importModules #[{ module := `Solution }] {} (level := .private)
  IO.println "== Local statement-closure check (NOT a Comparator run) =="
  let leaked := chal.header.moduleNames.filter fun m => (`PoissonDeclumping).isPrefixOf m
  IO.println s!"Challenge import closure: {chal.header.moduleNames.size} modules; \
    PoissonDeclumping modules among them: {leaked.size}"
  let mut problems : Array String := #[]
  if !leaked.isEmpty then problems := problems.push s!"Challenge imports {leaked}"
  -- (a) theorem types
  let mut work : Array Name := #[]
  for t in theoremNames do
    match chal.find? t, sol.find? t with
    | some (.thmInfo c), some (.thmInfo s) =>
      let ok := c.type == s.type && c.levelParams == s.levelParams
      IO.println s!"(a) {t}: theorem in both; type Expr-equal: {ok}"
      unless ok do problems := problems.push s!"type mismatch for {t}"
      work := work ++ s.type.getUsedConstants
    | _, _ =>
      IO.println s!"(a) {t}: MISSING or not a theorem in one environment"
      problems := problems.push s!"theorem {t} missing or of wrong kind"
  -- (b) closure comparison
  let mut seen : NameSet := {}
  let mut total : Nat := 0
  let mut project : Array Name := #[]
  while !work.isEmpty do
    let n := work.back!
    work := work.pop
    if seen.contains n then continue
    seen := seen.insert n
    match chal.find? n, sol.find? n with
    | some c, some s =>
      total := total + 1
      let mc := moduleOf chal n
      let ms := moduleOf sol n
      if isProjectModule mc || isProjectModule ms then
        project := project.push n
        unless mc == `Challenge && (`PoissonDeclumping).isPrefixOf ms do
          problems := problems.push s!"unexpected modules for {n}: challenge {mc}, solution {ms}"
      if c != s then
        problems := problems.push s!"ConstantInfo mismatch: {n} (challenge {mc}, solution {ms})"
      work := work ++ closureStep s
    | none, _ => problems := problems.push s!"missing in Challenge: {n}"
    | _, none => problems := problems.push s!"missing in Solution: {n}"
  IO.println s!"(b) constants reached from the four statement types and compared: {total}"
  IO.println s!"(b) project-defined constants among them: {project.size}"
  for n in project.qsort Name.lt do
    IO.println s!"      {n}"
  -- (c) axioms
  for t in theoremNames do
    let solCollect ← axiomsByCollect sol t
    let solTrav ← IO.ofExcept (axiomsByTraversal sol t)
    let chalCollect ← axiomsByCollect chal t
    IO.println s!"(c) {t}: Solution collectAxioms = {solCollect}; traversal = {solTrav}; \
      Challenge collectAxioms = {chalCollect}"
    for ax in solCollect ++ solTrav do
      unless allowedAxioms.contains ax do
        problems := problems.push s!"Solution theorem {t} uses forbidden axiom {ax}"
    unless chalCollect.contains ``sorryAx do
      problems := problems.push s!"Challenge theorem {t} does not use sorryAx (unexpected)"
    for ax in chalCollect do
      unless ax == ``sorryAx || allowedAxioms.contains ax do
        problems := problems.push s!"Challenge theorem {t} uses unexpected axiom {ax}"
  let t1 ← IO.monoMsNow
  IO.println s!"problems: {problems.size}"
  for p in problems do
    IO.println s!"  PROBLEM: {p}"
  IO.println s!"RESULT: {if problems.isEmpty then "PASS" else "FAIL"} \
    (local check, {total} constants compared, {project.size} project-defined; {t1 - t0} ms)"
  unless problems.isEmpty do
    throw <| IO.userError s!"statement-closure check failed with {problems.size} problem(s)"

end

#eval runCheck
