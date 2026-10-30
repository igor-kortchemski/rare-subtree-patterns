module

meta import Lean
import PoissonDeclumping

/-! Whole-library axiom audit. Run from the project root:
`lake env lean verification/AxiomAudit.lean`.

For every declaration of every module whose name starts with `PoissonDeclumping`, compute the
transitive axiom closure (`Lean.collectAxioms`) and report any declaration depending on an axiom
outside `propext`, `Classical.choice`, `Quot.sound` (in particular `sorryAx`, custom axioms, or
`Lean.ofReduceBool`). Prints the number of audited declarations and the offenders (none expected).
This file proves no mathematics and is not imported by the proof library. -/

meta section
open Lean Elab Command

run_cmd do
  let env ← getEnv
  let allowed : List Name := [``propext, ``Classical.choice, ``Quot.sound]
  let mut total : Nat := 0
  let mut bad : Array (Name × List Name) := #[]
  for (n, _) in env.constants.map₁.toList do
    match env.getModuleIdxFor? n with
    | none => pure ()
    | some idx =>
      let m := env.header.moduleNames[idx.toNat]!
      if (`PoissonDeclumping).isPrefixOf m then
        total := total + 1
        let axs ← collectAxioms n
        let extra := axs.toList.filter (fun a => !allowed.contains a)
        unless extra.length == 0 do bad := bad.push (n, extra)
  logInfo m!"audited {total} declarations from PoissonDeclumping.*; offenders: {bad.size}"
  for (n, extra) in bad do
    logInfo m!"  {n}: {extra}"
  if total == 0 then
    throwError "axiom audit found no project declarations"
  unless bad.isEmpty do
    throwError "axiom audit failed: {bad.size} declaration(s) use forbidden axioms"

end
