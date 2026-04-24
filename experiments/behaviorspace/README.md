# BehaviorSpace experiments

This directory documents suggested BehaviorSpace experiments for the NetLogo implementation.

## Suggested experiment: F-Q sweep

Use this setup to evaluate the relationship between cultural dimensionality (`F`), trait diversity (`Q`), and final fragmentation.

### Parameters

```text
F: 5, 10
Q: 5, 15, 30
repetitions: 30
world: approximately 61 x 61
wrap: off
```

### Setup command

```netlogo
setup
```

### Go command

```netlogo
go
```

### Stop condition

Use the model's absorbing-state condition. If the model exposes a reporter such as `absorbed?`, use:

```netlogo
absorbed?
```

If not, use the same internal condition used by the `go` procedure to stop the simulation.

### Metrics

Minimum metrics:

```netlogo
ticks
count-cultural-regions
mean-region-size
```

Recommended v2 metrics if implemented in the `.nlogo` file:

```netlogo
largest-region-size
largest-region-share
effective-interactions
absorbed?
```

## Export

Export BehaviorSpace results as CSV and place them in:

```text
experiments/sample-results/
```

Do not overwrite raw experiment exports. Keep raw files and derive cleaned analysis files separately.
