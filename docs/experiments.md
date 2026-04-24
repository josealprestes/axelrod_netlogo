# Reproducibility and experiment guide

This guide describes a simple experimental protocol for using the NetLogo implementation of Axelrod's cultural dissemination model in a reproducible way.

## 1. Recommended baseline

Use the textbook-mode configuration as the baseline:

```text
Topology: two-dimensional grid
Neighborhood: von Neumann, 4-neighbor adjacency
World wrapping: off
Occupancy: one agent per patch
Interaction probability: similarity
Suggested world size: approximately 61 x 61
```

Recommended initial parameters:

```text
F = 5
Q = 15
interaction-prob = 1.0
```

## 2. Parameter sweeps

A useful v2 experiment is to inspect how fragmentation varies as `F` and `Q` change.

Suggested sweep:

| Scenario | F | Q | Purpose |
|---|---:|---:|---|
| low-diversity baseline | 5 | 5 | inspect easier convergence |
| textbook reference | 5 | 15 | approximate classic illustrative regime |
| high-trait diversity | 5 | 30 | inspect stronger fragmentation |
| higher-dimensional culture | 10 | 15 | inspect effect of more cultural features |
| high-dimensional/high-diversity | 10 | 30 | inspect harder convergence regimes |

For each scenario, run at least 30 independent repetitions with different random seeds.

## 3. Recommended outputs

Export or record, for each run:

- random seed;
- world size;
- `F`;
- `Q`;
- total ticks until absorption;
- number of cultural regions at absorption;
- mean cultural-region size at absorption;
- largest cultural-region size at absorption;
- largest-region share of the world;
- number of effective interactions;
- final absorbed status.

A suggested CSV schema is available in `experiments/sample-results/schema.csv`.

## 4. BehaviorSpace setup

In NetLogo, use **Tools > BehaviorSpace** to define an experiment.

Suggested settings:

- setup commands: `setup`
- go commands: `go`
- stop condition: use the model's absorbed-state condition or the monitor/procedure that detects whether no partially similar neighboring pairs remain;
- repetitions: 30 or more;
- metrics: include the final monitors used in the interface.

Suggested metrics:

```netlogo
count-cultural-regions
mean-region-size
ticks
```

If v2 metrics are added to the `.nlogo` file, also include:

```netlogo
largest-region-size
largest-region-share
effective-interactions
absorbed?
```

## 5. Analysis workflow

A minimal analysis workflow should:

1. export BehaviorSpace results to CSV;
2. group results by `F` and `Q`;
3. compute mean, median, and standard deviation of final region count;
4. plot convergence time by scenario;
5. compare largest-region share across scenarios;
6. inspect whether higher `Q` increases fragmentation.

## 6. Interpretation caution

The purpose of these experiments is not to infer empirical cultural dynamics directly. The model is a formal abstraction for studying how local rules can generate macro-level patterns.

When reporting results, distinguish clearly between:

- the canonical Axelrod model;
- implementation choices made in this repository;
- any exploratory extensions added in future versions.
