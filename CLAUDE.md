# Claude continuation

Read [AGENTS.md](AGENTS.md) for project rules and local Lean skills, then
[HANDOVER_CLAUDE.md](HANDOVER_CLAUDE.md) for the task, verified exports,
source findings and remaining obligations.

Read `.agents/skills/*/SKILL.md` directly. Preserve the pinned Lean/mathlib 4.35.0
environment and original paper. The authoritative coverage record is
[FORMALIZATION_REPORT.md](FORMALIZATION_REPORT.md). The four Introduction theorems are proved
(`PoissonDeclumping/MainTheorems.lean`). Proof candidate `81fbaf9` passed Ubuntu CI,
including the whole-library axiom audit. The public documentation revision preserves its Lean
sources and configuration; fresh public-candidate CI/full preflight identify their own commit.
The first Palomar run failed at private-source fetching, before proof checks. At this
revision, official Comparator and a passing full Palomar report remain pending.
Standalone NanoDa and Lean export replay pass. Apache-2.0 and Igor Kortchemski's
credits were confirmed; see [PUBLICATION.md](PUBLICATION.md).
