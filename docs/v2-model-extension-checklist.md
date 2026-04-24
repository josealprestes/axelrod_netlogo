# v2 model-extension checklist

This checklist is for future changes to the `.nlogo` model file. It is intentionally separated from the documentation-first v2 upgrade so that the canonical model is not modified without inspection and testing in NetLogo.

## 1. Preserve textbook mode

Before adding extensions, keep a canonical mode that preserves Axelrod's original logic:

- von Neumann neighborhood;
- no torus/wrap;
- one agent per patch;
- probability of interaction equal to cultural similarity;
- update by copying one differing trait;
- stop at absorbing state.

Recommended switch:

```netlogo
textbook-mode?
```

When `textbook-mode? = true`, all exploratory extensions should be disabled.

## 2. Recommended v2 metrics

Add reporters or monitors for:

```netlogo
absorbed?
largest-region-size
largest-region-share
effective-interactions
partial-boundary-count
identical-boundary-count
incompatible-boundary-count
```

These metrics support better analysis of convergence, fragmentation, and spatial boundaries.

## 3. Recommended run-level counters

Add global counters for:

```netlogo
effective-interactions
attempted-interactions
absorbed-at-tick
```

These should be reset in `setup` and updated during `go`.

## 4. Optional exploratory switches

Only after textbook mode is stable, consider adding:

```netlogo
torus?
noise?
bounded-confidence?
```

Do not enable these by default. They should be documented as extensions, not as part of the canonical Axelrod model.

## 5. BehaviorSpace validation

After editing the `.nlogo` file, run at least one BehaviorSpace sweep with:

```text
F = 5, 10
Q = 5, 15, 30
repetitions = 30
```

Validate that exported CSV files include:

- `ticks_until_absorption`;
- `final_cultural_regions`;
- `final_mean_region_size`;
- `largest_region_size`;
- `largest_region_share`;
- `effective_interactions`;
- `absorbed`.

## 6. Regression check

Before committing model-code changes:

- run the model manually with the baseline configuration;
- confirm that `setup` initializes without errors;
- confirm that `go` eventually reaches an absorbed state;
- confirm that region metrics update correctly;
- export one BehaviorSpace CSV and run `analysis/summarize_behaviorspace.py`.

## 7. Documentation check

If the `.nlogo` file changes, update:

- `README.md`;
- `docs/model-explanation.md`;
- `docs/experiments.md`;
- `CHANGELOG.md`.
