# Challenge and publication statements

The selected declarations are the four Introduction theorems listed in `comparator.json`.
The current Challenge was independently reviewed against the paper after removing the
unused truncated-moment conjunct from `StableDomain`: statement-fidelity PASS.
It expresses normalized weak attraction directly. No separate moment-characterization,
local-limit estimate or functional J1 convergence is assumed.

`Challenge.lean` is 558 lines and 30,016 bytes, within the hard publication limits.
Its SHA-256 is `d52483829dea2cf9b1c9115d8c8c18486acb2549dd089dc84751e2869f750452`.
It imports only Mathlib. Its four deliberate proof holes are isolated from the proof library.

Apart from the two module docstrings and the Challenge's final theorem section, the shared
text is identical to `PoissonDeclumping/Statements/Defs.lean`. Run:

```sh
bash verification/check-challenge-defs.sh
```

The shared definitions contain the complete semantic closure, plus the retained unused
background definition `SlowlyVarying`. The local comparison reaches **25,899 constants**,
including **71 project-defined constants**, and finds zero mismatches. It compares the actual
constant types and bodies in separately imported environments. This is a local diagnostic,
not an official Comparator run.

`Solution.lean` imports the library and exposes the four same-named proved theorems.
`definition_names` is empty: no semantic definition is left as an unconstrained hole.
Only `propext`, `Classical.choice` and `Quot.sound` are permitted.

The current library builds in 3,464 jobs. The whole-library axiom audit covers 1,986
project declarations with zero forbidden dependencies. The four selected proof closures
were exported with the pinned `leanexport`; standalone kernel replay is documented in
`verification/README.md` and its logs. Those checks are separate from the official
sandboxed Comparator and full Palomar mechanical verification.

The default Comparator was attempted and returned exit 2 because bubblewrap requires
Linux namespaces. The sandbox was not disabled. The prepared manual Linux workflow is
`.github/workflows/palomar-preflight.yml`; it requires the frozen public candidate commit.

The Challenge is frozen mathematically for this publication candidate. Any change to a statement
or one of its semantic definitions requires renewed fidelity review and comparison evidence.
