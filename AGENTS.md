# Poisson declumping formalization

## Project

- Source: `poisson-declumping-arxiv.tex`, *Rare subtree patterns in
  size-conditioned Bienaymé trees: Poisson approximation and declumping*,
  by Igor Kortchemski and Leonard Vetter, arXiv:2607.22291v1.
- Lean library and namespace: `PoissonDeclumping`. The entry point is
  `PoissonDeclumping.lean`; add modules under `PoissonDeclumping/` and import
  completed modules from the entry point.
- Preserve Lean `leanprover/lean4:v4.35.0`, mathlib `v4.35.0`, and the exact
  revisions in `lake-manifest.json`.
- Run Lean and Lake commands from this project directory. Its existing name
  ends with a space; from the parent use `cd 'arXiv-2607.22291v1 '`.

## Local skills

Use the installed `lean-autoformalization-skills` collection. Read the relevant
local `SKILL.md` when its task arises; ordinary proof work starts with
`lean-workflow`. Load other skills selectively. When working from the parent
workspace, read this file and open the linked skills directly if they are absent
from the chat's automatic skill list.

| Task | Skill |
| --- | --- |
| Proof development, mathlib search, focused validation | [lean-workflow](.agents/skills/lean-workflow/SKILL.md) |
| Encodings, module boundaries, theorem interfaces, proof planning | [lean-project-architecture](.agents/skills/lean-project-architecture/SKILL.md) |
| Independent statement review, paper coverage, proof correspondence | [lean-statement-audit](.agents/skills/lean-statement-audit/SKILL.md) |
| Observed elaboration slowness or requested benchmarks | [lean-elaboration](.agents/skills/lean-elaboration/SKILL.md) |
| Parallel proof tasks, integration, shared builds | [lean-orchestrator](.agents/skills/lean-orchestrator/SKILL.md) |
| Requested GitHub or Palomar publication work | [lean-publication](.agents/skills/lean-publication/SKILL.md) |

Installation provenance, licenses, and templates are described in
[the skill index](.agents/README.md).

## Formalization workflow

- The intended mathematical scope is the paper's results and their required
  dependencies. Prioritize main results while retaining all other in-scope
  claims as obligations. Maintain `FORMALIZATION_REPORT.md` at coherent
  milestones; its initial state does not claim a completed paper inventory.
- Preserve assumptions, carriers, normalization, boundary cases, quantifier
  order, and dependence of constants. A conditional helper does not complete a
  result whose hypotheses remain unproved.
- Before substantial main-result proof work or work depending on a shared
  source-facing interface, obtain the independent statement-fidelity review
  required by `lean-statement-audit`. Reuse valid reviews, batch related targets,
  and revisit affected findings after semantic changes. This is an agent review,
  not a new user approval requirement; ordinary helpers need no separate review.
- Prefer the paper's main strategy and novel arguments. Record substantive
  departures, corrections, and unresolved source ambiguities in the coverage
  report. Distinguish proving a result from checking the paper's own argument.
- Search the installed mathlib revision before designing replacements. Use
  `module` and the pinned toolchain's visibility conventions.
- Do not introduce custom axioms or proof holes into maintained proof code.
  Inspect transitive axiom dependencies of exported results and report them
  accurately. Keep experimental files outside the maintained import graph.
- Compile focused targets while developing and validate affected consumers
  after interface changes. Use `lake build` for project-wide validation.
  Coordinate builds that write shared outputs, preserve dependency caches,
  and do not stop other sessions' processes.
- Resolve routine proof and implementation choices autonomously within the
  user's scope. Investigate uncertainty using available evidence and continue
  independent work when a genuine unresolved question blocks one part.
- Record useful manuscript observations in `MANUSCRIPT_RECOMMENDATIONS.md`
  when needed; its template is under `.agents/templates/`. Manuscript edits and
  publication follow the user's actual instructions and existing authorization.

## Markdown mathematics

Use `$...$` for inline mathematics. Put each `$$` display delimiter on its own
line, with a blank line before the opening delimiter and after the closing one.
Use MathJax-compatible LaTeX without undefined custom macros. Do not use
backslash-parenthesis or backslash-bracket delimiters for displayed mathematics
in Markdown prose. This convention does not change code examples or `.tex` files.
