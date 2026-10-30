# Local Lean autoformalization skills

Installed on 29 October 2026 from the sibling checkout
`../lean-autoformalization-skills` (relative to the project root).
Its origin is `https://github.com/igor-kortchemski/lean-autoformalization-skills.git`.
Refreshed later on 29 October 2026 from that checkout's clean commit
`f76ee062634c0bc5a07dc37c1504fa7163eaf0ca` (*Add early statement review and
Palomar-compatible publication defaults*). The first installation copied the
working tree over base commit `c47f0143678addb5782e0004c0bebd59f29b6c9b`.

All six skill directories are unmodified copies, including UI metadata and
reference files. Files named `.DS_Store` are excluded. These local copies do not
update automatically when the source checkout changes.

| Skill | Purpose |
| --- | --- |
| [lean-workflow](skills/lean-workflow/SKILL.md) | Ordinary Lean proof work |
| [lean-project-architecture](skills/lean-project-architecture/SKILL.md) | Encodings, interfaces, and module design |
| [lean-statement-audit](skills/lean-statement-audit/SKILL.md) | Independent fidelity and coverage review |
| [lean-elaboration](skills/lean-elaboration/SKILL.md) | Performance diagnosis and measurement |
| [lean-orchestrator](skills/lean-orchestrator/SKILL.md) | Coordination and integration |
| [lean-publication](skills/lean-publication/SKILL.md) | Requested GitHub or Palomar publication work |

Project instructions are in [AGENTS.md](../AGENTS.md). The current coverage
record is [FORMALIZATION_REPORT.md](../FORMALIZATION_REPORT.md).
Original [coverage](templates/FORMALIZATION_REPORT.md) and
[manuscript recommendations](templates/MANUSCRIPT_RECOMMENDATIONS.md) templates
are retained for reference. The project coverage record is adapted to its
current setup-only state.

The bundle's [attribution](skill-notices/lean-autoformalization-skills/ATTRIBUTION.md),
[CC BY 4.0 license](skill-notices/lean-autoformalization-skills/LICENSE), and
third-party MIT and Apache-2.0 notices are preserved together under
`skill-notices/lean-autoformalization-skills/`. These terms concern the skill
material and templates; they do not assign a license to the paper or Lean code.

Use this paper's folder as the working directory for project-local skill
discovery. When working from the parent workspace, read the project's
`AGENTS.md` and load the linked skill files directly.
